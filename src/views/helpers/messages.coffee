###
Messages helper
===============

It displays messages stored in agents session. See `middleware/session-messages.coffee`.

###

module.exports = ->
  if @session.messages?
    for message in @session.messages
      div class: "alert alert-#{message.level}", ->
        button
          type          : "button"
          class         : "close"
          "data-dismiss": "alert"
          "&times"
        i class: if message.level is "info" then "icon-info-sign" else "icon-warning-sign"
        text " " + message.message
    delete @session.messages
