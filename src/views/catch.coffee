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

  else
    h1 "Public profile of #{@participant.name}"
    # if @username is @participant.email then participant is viewing his own profile and should be able to change it
    if @username is @participant.email
      form class: "profile update", method: "post", action: "/participants", ->
        label for: "name", "How shall we address you in public?"
        input type: "text", name: "name", value: @profile.name
        input type: "submit", value: "save"

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
        



