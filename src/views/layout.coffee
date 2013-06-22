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
  
  if @session?.username?  then @username  = @session.username
  if @session?.profile?   then @profile   = @session.profile

  ###

  Dafault title
  -------------

  TODO: internetionalization

  ###

  @title ?= "Synergy stimulant for the masses."

  ###

  Navigation menu items
  ---------------------
  ###

  @navigation ?= [
    { title: "Start", href: "/" }
    { title: "Stakeholders", href: "/stakeholders" }
    { title: "Log out", href: "#", "data-signout": true }
  ]

  ###

  HTML
  ----
  The rest is [html as coffescript](https://github.com/gradus/coffeecup#coffeecup-).

  ###

  doctype 5
  html ->
    head ->
      title "Uvaga ! " + @title or "Hello."
      meta charset: "utf-8"
      meta "http-equiv": "X-UA-Compatible", content: "IE=Edge"
      meta 
        name    : "viewport"
        content :"width=device-width, initial-scale=1.0"


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


    body "data-username": @username, ->
      div class: "navbar navbar-inverse navbar-fixed-top", ->
        div class: "navbar-inner", ->
          div class: "container", ->
            button
              type        : "button"
              class       : "btn btn-navbar"
              data-toggle : "collapse"
              data-target : ".nav-collapse"
              ->
                span class: "icon-bar"
                span class: "icon-bar"
                span class: "icon-bar"
                
            a href: "/", class: "brand", ->
              strong "Uvaga ! "
              span class: "title", @title

            div class: "nav-collapse collapse", ->
              ul class: "nav", ->
                for item in @navigation
                  li -> a item, item.title
                    


      div class: 'container', ->
        h1 class: "brand", "Uvaga!"
        h2 class: "title", @title

        section id: "main", ->
          do content

        footer ->
          p "A footy footer is here"

        script src: "http://code.jquery.com/jquery-1.9.1.min.js"
        script src: "http://code.jquery.com/jquery-migrate-1.1.1.min.js"
        script src: "/assets/scripts/app/persona.js"
        script src: "//login.persona.org/include.js"
        script src: "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"

        script src: "/assets/scripts/vendor/selectize/selectize.js"


