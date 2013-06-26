###

Contoller
=========

Tastes good with creamer.

###
_ = require "underscore"
$ = require "./debug"

controller = (options, method) ->
  # Wraps a function into another function (a controller)

  my = arguments.callee # for brevity :)
  
  defaults =
    access  : my.levels.authorized

  # Takes one or two arguments. First is optional.
  if method is undefined
    method  = options
    options = defaults
  else if typeof options is "string" then options = access: options
  else options = _.defaults options, defaults

  # Access option should be a function, but we can use a shortcut string
  if typeof options.access is "string"
    options.access = my.levels[options.access]
  if typeof options.access isnt "function"
    throw new Error """
      Invalid access option.
      Values can be #{(_.keys my.levels).join ", "} or a function.
    """
  # Do the wrap
  return ->
    if options.access.apply @ then method.apply @, arguments
    else @res.end "Not authorized" # TODO: improve by canibalizing :)

controller.levels = 
  anyone        : -> true
  authorized    : -> @req.session.username?
  administrator : -> @req.session.stakeholder.role is "administrator"

module.exports = controller