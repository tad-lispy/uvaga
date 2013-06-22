jQuery ($) ->
  ($ "#groups").selectize
    delimiter: ";"
    create: (input) -> text: input, value: input
