###

Main controller
===============

It controlls `/` and various other paths.

Learn [more about controllers](https://github.com/twilson63/creamer/tree/master/examples/mvc).


###
$ = require "../debug"

module.exports = 
  "/":
    get: ->
      @bind "index"

  "/auth":
    get: ->
      @bind "authenticate", layout: navbar: false
