[![Build Status](https://secure.travis-ci.org/effkay/blazing.png?branch=master)](http://travis-ci.org/effkay/blazing)

# Blazing fast and painless git push deploys

*Oh no, yet another deployer!*

Not everyone can or wants to deploy on heroku. But now you can have the same (well, almost the same, since we're not gonna patch SSH) awesomely smooth git push deploys on whatever server you have SSH access to.

## Quickstart

`blazing init`, edit the configuration, run `blazing setup [target]` and you're set. Deploy with `git push <target> <branch>` or setup git to always push your current branch.

## Overview & Background

Blazing is a deployment tool written in Ruby. It provides helpers to setup your project with a git post-receive hook, which is triggered every time you push to your production repository.

I initially started working on an extension to capistrano which would cover most of my needs and the nees of my team. After a short while I noticed that bolting more functionality on top of capistrano was just going to be messy (and a PTA to maintain). We were alerady using tons of own recipes and customizations, capistrano multistage, capistrano-ext, etc.
 
I had a look at what others were doing and after a round of trying around and not getting what I wanted, I started this.
 
## Design Goals

When I started working on blazing, I had some design goals in mind which I think should stay relevant for this project:

- it must be well tested
- it must stay robust, simple and with small code base with as few moving parts as possible. Minimum code in the main project, extensions live outside.
- no messy rake scripts: Define the desired behavior trough a DSL, and extensions add to this DSL in a clean and modular way
- Deployments should be fast

### Inspiration & Alternatives
 
I looked at [Inploy](https://github.com/dcrec1/inploy) and [Vlad](https://github.com/seattlerb/vlad) after having used [Capistrano](https://github.com/capistrano/capistrano) for several
years. Then got inspired by defunkt's
[blog post](https://github.com/blog/470-deployment-script-spring-cleaning) about deployment script spring cleaning. Other's doing a similar thing with git push deployments are Mislav's [git-deploy](https://github.com/mislav/git-deploy) (which was a great inspiration and resource) and [pushand](https://github.com/remi/pushand.git) by remi. If you don't like blazing, you might give them a try.

## Installation

Your machine should be setup with ruby, rubygems, bundler and git. Install blazing by adding it to your `Gemfile` or run `gem install blazing`. The basic assumption from now on will be that you are working on a project with bundler and a Gemfile. Support for other ways to handle dependencies might be added in the future, but for now bundler is required.

## Usage

### Init

Run `blazing init` in your project root to create a sample config file. 

### Configuration

See the generated configuration file or [the template file](https://github.com/effkay/blazing/blob/master/lib/blazing/templates/config.erb) for available configuration options.

### Setup

`blazing setup` will:

* setup your local repository for deployment with blazing/git push. Basically, it will add a remote for each target you defined in the configuration file.
* clone the repository to the specified location
* setup the repository to allow a currently checked out branch to be pushed to it

Whenever you change something in your blazing config file you can run the `update` command so your git post-receive hook and your git remotess get updated.

### Deploying

Just push to your remote… so if you set up a target named `:production`, use `git push production master` to deploy your master branch there.

### Recipes

Right now blazing does the following things out of the box:

* use rvm if you specify it in your config (by passing an rvm string or just `:rvmrc`, which will load the rvmrc)
* checkout the pushed ref… so if you do git push production master, the last commit of the master branch will be checked out. Before doing a checkout blazing will reset to HEAD so no errors happen due to changed files. **This means that you will loose any uncommited changes on the production repository. Having changes there is a bad idea anyway!**
* run bundle --deployment so the dependencies are installed
* run all recipes, in the order that they are defined
* run the rake task if one was specified

Run all recipes? Well yes, blazing can be extended by recipes. So far, these are available:

* [blazing-passenger](https://github.com/effkay/blazing-passenger)
* [blazing-rails](https://github.com/effkay/blazing-rails)

Feel free to roll your own recipes!

## Development & Contribution

### Improving Blazing itself

If you like blazing and want to improve/fix something, feel free, I'm glad for every pull request. Maybe contact me beforehand so we don't fix the same bugs twice and make sure you stick with a similar code style and have tests in your pull request. 

### Creating custom Blazing Recipes

I would like to add recipes that encapuslate common deployment strategies to blazing. If you have an idea for that, you are welcome to contribute. Right now I am still working on a clever API for this. At the moment the recipe API works as follows:

* recipes should live in gems called `blazing-<somename>`
* blazing converts the symbol given in the config to the class name and calls run on it. So if you have `recipe :passenger_restart` blazing will try to run `Blazing::Recipe::PassengerRestart.run` with the options provided.
* Recipes should live in the `Blazing::Recipe` namespace and inherit from `Blazing::Recipe` as well
* Recipes are run in the order they are specified in the config, so there is no way to handle inter-recipe dependencies yet.
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

## Authors

Felipe Kaufmann ([@effkay][])

## License

See the [MIT-LICENSE file](https://github.com/effkay/blazing/blob/master/MIT-LICENCE)

[@effkay]: https://github.com/effkay
