Yet another deployment utility
==============================

**WARNING: This gem is in early development. Use at your own risk.**

But why? Well, Capistrano was bloated for our use-cases, to much stuff bolted on. Inploy looked really interesting, but does not have multistage support from what I could tell. So I did what any reasonable developer would do and befell to the "Not Invented here syndrome".

Top Design goals, ideas:
------------------------

  * deploy is just a push to another remote. all that must be done is triggered by pre and post receveie git hooks.
  * initial setup done by ruby script, so unexerpienced users do not
    have to fiddle with the git config files
  * extensible recipe system, so you can plug in and out what you need and easily roll your own recipes

Usage
=====

Setup a project with

 blazing init

Then edit your config/blazing.rb file.

If you are ready to do your first deploy, run 

 blazing setup <target_name>

Afterwards you can just deploy with

  blazing deploy <target_name>

Or just use

  git push <target_name>

which does basically the same

Roadmap
=======

You have guessed it, and the version number does not lie. This is all in early development. So here's my little roadmap, aka the backlog:

  * finish rvm recipe

  * Bundler
    * before running recipes? (so we have the gems blazing needs)
    * after reseting code (so the app has the gems it needs)

  * improve logging: bubbling of messages, only print them out if needed

Recipes:

  * sync fs recipes
  * sync db recipes for
    * mysql
    * postgres
    * mongodb
    * redis
  * hoptoad notifier
  * maintenance page recipe
  * rollback recipe/feature
  * rvm recipe
  * whenever recipe
  * coffescript recipe
  * sass recipe
  * passenger recipe
  * unicorn recipe
  * apache recipe
  * nginx recipe
  * nanoc deploy
