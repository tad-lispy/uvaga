module.exports = ->
  h1 "Theese are some of the worst catches!"
  table id: "cateches", ->
    tr ->
      th "Body count"
      th "First step"

    for the_catch in @catches
      tr class: "catch", ->
        td class: "victims", the_catch.victims.length
        td class: "step-1", ->
          a href: "/catches/#{the_catch.slug}", the_catch.steps[0]