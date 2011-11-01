## master

## 0.2.2 - November 1, 2011

* Changed the way the target repository is initialized so it works on
  older git versions (Old git versions don't take a path as parameter
  when doing git init)

## 0.2.1 - October 27, 2011

* Improved Logging: Hook and recipes are much more verbose, colored
  output

## 0.2.0 - October 27, 2011

* Recipes accept target specific options (RECIPE API CHANGED! See [this commit](https://github.com/effkay/blazing/commit/f7fe22b822c00b55db6f2a870d67b449fcb7fce1) for details)

## 0.1.3 - October 25, 2011

* fix erros in hook and improve its logging

## 0.1.2 - October 25, 2011

* setup initializes an empty repository, so first push will work (#47)

* simplified cli workflow (#45):
  * update runs update and setup:local
  * setup:remote renamed to setup
  * setup:remote also runs update

## 0.1.1 - October 25, 2011

* [BUG]: fix #48: dont bundle test and dev gems, do it quietly
* [BUG]: fix #44: accept target as argument
* [BUG]: fix #41: recipe gem loading issues resolved
* remove documentation of external recipes

## 0.1.0 - October 24, 2011

[@effkay]: https://github.com/effkay
