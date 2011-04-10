Blazing -- Fast and painless git push deploys
=============================================

## What

Blazing aims to be a fast and hassle free way to deploy web
applications. It may work for other frameworks, but it is mainly
designed to deploy Ruby on Rails and Rack based applications, as well as
static sites.

Some design goals:

  * A deploy is just a git push to another remote. All that must be done afterwards is triggered by pre and post receveie git hooks.
  * initial setup done by ruby script, so unexerpienced users do not
    have to fiddle with the git config files
  * clean API for writing your own recipes, no messy rake file jungles
  * DRY, clean and minimal configuration file
  * blazing fast!

## Why

I initially started working on an extension to capistrano which would
cover most of my needs and the needs we had at [Screen
Concept](http://www.screencocnept.ch). After a short while I noticed
that bolting more functionality on top of capistrano was just going to
be messy (and a PTA to maintain). We were alerady using tons of own recipes and customizations,
capistrano multistage, capistrano-ext, etc.

I had a look at what others were doing and after a round of trying
around and not getting what I wanted, I started this.

### Inspiration & Alternatives

I looked at [Inploy](https://github.com/dcrec1/inploy) and [Vlad](https://github.com/seattlerb/vlad) after having used [Capistrano](https://github.com/capistrano/capistrano) for several
years. Then got inspired by defunkt's
[blog post](https://github.com/blog/470-deployment-script-spring-cleaning) about deployment script spring cleaning. Other's doing a similar thing with git push deployments are Mislav's [git-deploy](https://github.com/mislav/git-deploy) and [pushand](https://github.com/remi/pushand.git) by remi.

## Installation & Setup

Run `blazing init` in your project's root, this will create the necessary files to use and configure blazing.

## Configuration & Blazing DSL

The blazing config file features a DSL similar to capistrano or other
such systems.

Examples:

    repository 'git@github.com:someones/repository.git'

    use [:rvm, :bundler, :whenever]

    target :stagigng, :deploy_to => 'user@hostname:/path/to/target', :default => true
    target :production, :deploy_to => 'user@somehostname:/path/to/target'

    ...

## Deploying

    blazing deploy <target_name>

Or, if everyting is already set up on the remote etc. you can acutally
just do a git push to your target name.

## Development 

Report Issues/Questions/Feature requests on [GitHub
Issues](http://github.com/effkay/blazing/issues)

### Extending / Fixing Blazing itself

Pull requests are very welcome as long as they are well tested. Please
create a topic branch for every separate change you intend to make.

### Developing Blazing Extensions

**(Still work in progress and not a stable API yet)**

Example:

    class SomeFunkyRecipe < Blazing::Recipe

      def self.run
        # do something
      end

    end

## Authors

[Felipe Kaufmann](http://github.com/effkay)

## License

Copyright (c) 2011 Felipe Kaufmann

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
