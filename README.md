[![Build Status](https://secure.travis-ci.org/effkay/blazing.png?branch=master)](http://travis-ci.org/effkay/blazing)
[![Code Climate](https://codeclimate.com/github/effkay/blazing.png)](https://codeclimate.com/github/effkay/blazing)
[![Gem Version](https://badge.fury.io/rb/blazing.png)](http://badge.fury.io/rb/blazing)

Blazing fast and painless git push deploys
==========================================

*Oh no, yet another deployer!*

Not everyone can or wants to deploy on heroku. But now you can have the same (well, almost the same, since we're not gonna patch SSH) awesomely smooth git push deploys on whatever server you have SSH access to. Blazing helps you to create and distribute your post-receive hooks, which are executed on the remote server after you successfully pushed to it. It also helps you to easily set up remote repositories for deploying to, is extendable by simple rake tasks and is configured by a nice DSL.

Quickstart
----------

`blazing init`, edit your blazing config, run `blazing setup [target]` to deploy your post-receive hook and you're set. Deploy with `git push <target> <branch>`.

Features
--------

Out of the box, blazing can do the following:

* **uses ruby, but works for deploying pretty much anything else just as well**
* set up a repository you can push to for deployment
* set up a git post-receive hook, configurable by a simple DSL
* works with rvm/rbenv/chruby(and probably others)
* allows you to run custom rake tasks during deployment
* Makes it easy to ssh to target directory on server with env variables
  set

Usage
-----

### Installation

Make sure you have bundler available on your local machine as well as on
the server you are deploying to.

### blazing Commands

```
Commands:
  blazing goto [TARGET]    # Open ssh session on target. Use -c to specify a command to be run
  blazing help [COMMAND]   # Describe available commands or one specific command
  blazing init             # Generate a sample blazing config file
  blazing setup [TARGET]   # Setup local and remote repository/repositories for deployment
  blazing update [TARGET]  # Re-Generate and uplaod hook based on current configuration
  blazing version          # Show the blazing version
```

**Always remember to update your hooks after updating blazing**

### Configuration (blazing DSL)

Run blazing init in your project to generate a config file or look at
[the sample config
template](https://github.com/effkay/blazing/blob/master/lib/blazing/templates/config.erb)

### Deploying

Just push to your remote… so if you set up a target named `production`, use `git push production master` to deploy your master branch there.

Recipes
-------

Recipes have been removed from blazing.

Authors
-------

Felipe Kaufmann ([@effkay][])

License
-------

See the [MIT-LICENSE file](https://github.com/effkay/blazing/blob/master/MIT-LICENCE)

[@effkay]: https://github.com/effkay
