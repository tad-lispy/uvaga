module.exports = ->
  div class: "hero-unit", ->
    h1 "Uvaga ! We are share issues."
    unless @username
      p """
        Before you start interacting with other stakeholders you need to provide your e-mail address. If this is your first time here, you will be also asked for some basic info about you. 
      """
    do authentication