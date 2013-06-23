module.exports = ->
  div class: "row", ->
    div class: "span3", ->
      p -> strong @profile.name

    div class: "span9", ->
      div class: "row", ->
        a 
          class: "btn-primary btn-large"
          href: "/issues/__new"
          "I have an issue!"