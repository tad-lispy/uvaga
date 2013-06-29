###

Bootstrap navbar
================

###

module.exports = (navigation) ->
  navigation ?= []

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
          small class: "title", @title

        div class: "nav-collapse collapse", ->
          ul class: "nav", ->
            for item in navigation
              li -> a item, item.title
