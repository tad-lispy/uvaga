module.exports = ->
  div class: "row", ->
    div class: "span3", ->
      p -> strong @profile.name

    div class: "span9", ->
      p "Everything" 