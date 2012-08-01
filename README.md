[![Build Status](https://secure.travis-ci.org/effkay/blazing.png?branch=master)](http://travis-ci.org/effkay/blazing)

Blazing fast and painless git push deploys
==========================================

*Oh no, yet another deployer!*

Not everyone can or wants to deploy on heroku. But now you can have the same (well, almost the same, since we're not gonna patch SSH) awesomely smooth git push deploys on whatever server you have SSH access to. Blazing helps you to create and distribute your post-receive hooks, which are executed on the remote server after you successfully pushed to it. It also helps you to easily set up remote repositories for deploying to, is extendable by recipes and is configured by a nice DSL.

Quickstart
----------

`blazing init`, edit your blazing config, run `blazing setup [target]` to deploy your post-receive hook and you're set. Deploy with `git push <target> <branch>`.

Features
--------

Out of the box, blazing can do the following:

* set up a repository you can push to for deployment
* set up a git post-receive hook, configurable by a simple DSL
* works with rvm
* uses bundler for dependency management
* allows you to run custom rake tasks after deployment
* is extendable by blazing recipes

Overview & Background
---------------------

Blazing is a deployment tool written in Ruby. It provides helpers to setup your project with a git post-receive hook, which is triggered every time you push to your production repository.

I initially started working on an extension to capistrano which would cover most of my needs and the nees of my team. After a short while I noticed that bolting more functionality on top of capistrano was just going to be messy (and a PTA to maintain). We were alerady using tons of own recipes and customizations, capistrano multistage, capistrano-ext, etc.

I had a look at what others were doing and after a round of trying around and not getting what I wanted, I started this.

#### Design Goals

When I started working on blazing, I had some design goals in mind which I think should stay relevant for this project:

- it must be well tested
- it must stay robust, simple and with small code base with as few moving parts as possible. Minimum code in the main project, extensions live outside.
- no messy rake scripts: Define the desired behavior trough a DSL, and extensions add to this DSL in a clean and modular way
- Deployments should be fast

#### Inspiration & Alternatives

I looked at [Inploy](https://github.com/dcrec1/inploy) and [Vlad](https://github.com/seattlerb/vlad) after having used [Capistrano](https://github.com/capistrano/capistrano) for several
years. Then got inspired by defunkt's
[blog post](https://github.com/blog/470-deployment-script-spring-cleaning) about deployment script spring cleaning. Other's doing a similar thing with git push deployments are Mislav's [git-deploy](https://github.com/mislav/git-deploy) (which was a great inspiration and resource) and [pushand](https://github.com/remi/pushand.git) by remi. If you don't like blazing, you might give them a try.

Usage
-----

#### Installation

Your machine should be setup with ruby, rubygems, bundler and git. Install blazing by adding it to your `Gemfile` or run `gem install blazing`. The basic assumption from now on will be that you are working on a project with bundler and a Gemfile. Support for other ways to handle dependencies might be added in the future but **at the moment bundler is required**.

#### blazing Commands

##### `blazing init`

Generate a blazing config file

##### `blazing setup <target>`

Setup target repository for deployment and add git remote localy. Use 'all' as target name to update all configured targets at once.

##### `blazing update <target>`

Update post-receive hook according to current config. Run it after changing the blazing config. Use 'all' as target name to update all configured targets at once.

##### `blazing list`

List available recipes

##### `blazing recipes`

Run the configured recipes (used on deployment target, can be used to test recipes localy)

The `setup` and `update` commands also take 'all' as an option. This will perform the action on all your defined targets.

#### Configuration (blazing DSL)

```ruby
# Sample target definition:
#
#   target <target_name>, <target_location>, [options]
#
# The options provided in the target definition will override any
# options provided in the recipe call.
#
# Options recognized by blazing core:
#   rails_env: used when calling the rake task after deployment

target :staging, 'user@server:/var/www/someproject.com',
       :recipe_specific_option => 'foo', :rails_env => 'production'


# Sample rvm setup:
#
#    rvm <rvm-string>
#
# Setting the rvm string will make sure that the correct rvm ruby and
# gemset is used before the post-receive hook does anything at all.
# Use :rvmrc as rvm string if you want blazing to use the rvm
# environment specified in your project's .rvmrc file.

rvm 'ruby-1.9.3@some-gemset'


# Sample config for custom rvm location:
#
#    rvm_scripts <path_to_rvm_scripts>
#
# If you have installed rvm to a custom location, use this method to
# specify where the rvm scripts are located.

rvm_scripts '/opt/rvm/scripts/rvm'


# Sample recipe setup:
#
#     recipe <recipe_name>, [options]
#
# The given recipe will be called with the provided options. Refer to each
# recipe's documentation for available options. Options provided here
# may be overridden by target specific options.
# Recipes will be executed in the order they are defined!yy

recipe :precompile_assets, :recipe_specific_option => 'bar'


# Sample rake file config:
#
#     rake <task>, [environment variables]
#
# The provided rake task will be run after all recipes have run.
# Note: you can only call a single rake task. If you need to run several
# tasks just create one task that wrapps all the others.

rake :post_deploy, 'RAILS_ENV=production'
```

#### Deploying

Just push to your remote… so if you set up a target named `production`, use `git push production master` to deploy your master branch there.

Recipes
-------

Blazing only offers a small set of core features. However, it is extendable by recipes.

#### Available Recipes

* [blazing-passenger](https://github.com/effkay/blazing-passenger)
* [blazing-rails](https://github.com/effkay/blazing-rails)

#### Creating a blazing Recipe

Creating a blazing recipe is very easy. There are some ground rules:

* recipes should live in gems called `blazing-<somename>`
* blazing converts the symbol given in the config to the class name and calls run on it. So if you have `recipe :passenger_restart` blazing will try to run `Blazing::Recipe::PassengerRestart.run` with the options provided.
* Recipes should live in the `Blazing::Recipe` namespace and inherit from `Blazing::Recipe` as well
* Recipes are run in the order they are specified in the config, so there is no way to handle inter-recipe dependencies yet.
* Make sure your recipe classes are loaded when the recipe gem itself is
  loaded
* A minimal recipe implementation might look like this:

```ruby
class Blazing::Recipe::Example < Blazing::Recipe
  def run(target_options = {})
    super target_options
    # do some stuff
    # access options with @options[:key]
  end
end
```
Please have a look at [blazing-passenger](https://github.com/effkay/blazing-passenger) to get an idea of how to implement your recipe.

Development
-----------

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested.
* Update the README.
* Update the CHANGELOG for noteworthy changes.
* Please **do not change** the version number.

Authors
-------

Felipe Kaufmann ([@effkay][])

License
-------

See the [MIT-LICENSE file](https://github.com/effkay/blazing/blob/master/MIT-LICENCE)

[@effkay]: https://github.com/effkay
