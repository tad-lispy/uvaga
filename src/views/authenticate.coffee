module.exports = ->
  h1 class: "page-header", ->
    text "Uvaga ! "
    small translate "We share issues."

  unless @username
    p translate "Before you begin a dialogue with other stakeholders we will ask you to provide your e-mail address."
    p translate "If this is your first time here, you will be also asked for some basic info about you."

  do authentication