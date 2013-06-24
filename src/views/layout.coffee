###

Layout for views
================

This is a creamer layout. It's indicated in app.coffee. ATM there can be only one layout, so this has to be pretty universal.

We do some computations here against purist's MVC dogmas. Is it that bad?

###

module.exports = ->

  ###

  Session data
  ------------

  `session.username` is set only if agent is authenticated via Persona. Then it contains a string with users e-mail.

  `session.profile` is set only if agent is authenticated and has a profile (stakeholder document). Then it's an object with profile data, i.e. at least
  
      * email (same as username),
      * name (public name),
      * and slug (public identifier used in urls).
  
  There may be other data.

  ###
  
  if @session?.username?    then @username = @session.username
  if @session?.stakeholder? then @profile  = @session.stakeholder

  ###

  Dafault title
  -------------

  TODO: internetionalization

  ###

  @title ?= "Synergy stimulant for the masses."

  ###

  Navigation menu items
  ---------------------

  See navbar below

  ###

  @navigation ?= [
    { title: "Start", href: "/" }
    { title: "Stakeholders", href: "/stakeholders" }
    { title: "Issues", href: "/issues" }
    { title: "Log out", href: "#", "data-signout": true }
  ]

  ###

  HTML
  ----
  The rest is [html as coffescript](https://github.com/gradus/coffeecup#coffeecup-).

  ###

  doctype 5
  html lang: "en", ->
    head ->
      title "Uvaga ! " + @title
      meta charset: "utf-8"
      meta "http-equiv": "X-UA-Compatible", content: "IE=Edge"
      meta 
        name    : "viewport"
        content :"width=device-width, initial-scale=1.0"

      link
        rel : "shortcut icon"
        href: "assets/icon.png"

      link
        rel : "stylesheet"
        type: "text/css"
        href: "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.no-icons.min.css"
      link
        rel : "stylesheet"
        type: "text/css"
        href: "//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css"

      link
        rel : "stylesheet"
        type: "text/css"
        href: "/assets/scripts/vendor/selectize/selectize.css"

      stylus """
        body
          padding-top 60px
        @media screen and (max-width: 979px)
          body
            padding-top 0px

        .selectize-control
          margin-left: 0
      """
    body "data-username": @username, ->
      navbar @navigation unless @layout?.navbar is false

      div class: 'container-fluid', ->
        do messages
        div class: "page-header", ->
          h1 ->
            text "Uvaga ! "
            small @title
        do content

        div class: footer ->
          do footer

      script src: "http://code.jquery.com/jquery-1.9.1.min.js"
      script src: "http://code.jquery.com/jquery-migrate-1.1.1.min.js"
      script src: "/assets/scripts/app/persona.js"
      script src: "//login.persona.org/include.js"
      script src: "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"

      script src: "/assets/scripts/vendor/selectize/selectize.js"
      if @scripts? then script src: path for path in @scripts


