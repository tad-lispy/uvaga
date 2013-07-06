###

Contoller
=========

Tastes good with creamer.

###
_     = require "underscore"
debug = require "debug"
$     = debug "uvaga:helper"

controller = (options, method) ->
  # Wraps a function into another function (a controller)
  $ = debug "uvaga:helper:contoller"

  me = arguments.callee # for brevity :)
  
  defaults =
    access  : me.levels.authorized

  # Takes one or two arguments. First is optional.
  if method is undefined
    method  = options
    options = defaults
  else if typeof options is "string" then options = access: options
  else options = _.defaults options, defaults

  # Access option should be a function, but we can use a shortcut string
  if typeof options.access is "string"
    options.access = me.levels[options.access]

  $ "New controller with options %j", options
  if typeof options.access isnt "function"
    throw new Error """
      Invalid access option.
      Values can be #{(_.keys me.levels).join ", "} or a function.
    """
  # Do the wrap
  return ->
    if options.access.apply @ then method.apply @, arguments
    else @res.end "Not authorized" # TODO: improve by canibalizing :)

controller.levels = 
  anyone        : -> 
    $ = debug "uvaga:helper:contoller:anyone"
    $ "Anyone can %s %s", @req.method, @req.url
    true
  
  authorized    : -> 
    $ = debug "uvaga:helper:contoller:authorized"
    if @req.session.username?
      $ "%s can %s %s", @req.session.username, @req.method, @req.url
      return true
    else
      $ "Not authorized to %s %s", @req.method, @req.url
      return false

  administrator : -> 
    $ = debug "uvaga:helper:contoller:administrator"
    if @req.session.stakeholder.role is "administrator"
      $ "%s can %s %s", @req.session.username, @req.method, @req.url
      return true
    else
      $ "%s is not authorized to %s %s", @req.session.username, @req.method, @req.url
      return true

module.exports = controller