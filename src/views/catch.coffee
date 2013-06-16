_ = require "underscore.string"

module.exports = ->
  # No `@catch` indicates that we are in `/catches?new`
  if not @catch?
    p "What is bothering you?"
    form class: "catch create", method: "post", action: "/catches", ->
      ol id: "steps", ->
        li -> input 
          name: "steps"
          type: "text"
          placeholder: "describe what is happenig, step by step"
          size: 128
      input id: "submit", type: "submit", value: "save"

    coffeescript ->
      jQuery ($) ->
        list = $("#steps")
        do list.sortable
        do list.disableSelection

        # It seems we can't use `list.find()` here. The `live` goes nuts.
        $("#steps li:last-child input[name=steps]").live "focus", ->
          item = $(@).parent().clone().hide()
          item.appendTo(list).fadeIn "slow"
          item.find("input").val("")
          $(@).one "blur", ->
            unless $(@).val()
              do item.remove
              do $("#submit").focus
          list.sortable "refresh"

  else
    h1 "The catch is this"
    ul id: "victims", ->
      for victim in @catch.victims
        li -> a href: "/stakeholders/#{victim.slug}", victim.name
    ol id: "steps", ->
      li step for step in @catch.steps
