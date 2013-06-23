$ = require "../debug"

module.exports = (req, res) ->
  res.message = (message, level) ->
    level ?= "info"
    req.session.messages ?= []
    req.session.messages.push { message, level }
  res.emit "next"

