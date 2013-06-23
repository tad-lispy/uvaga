jQuery ($) ->
  ($ "#scopes").selectize
    delimiter: ";"
    create: (input) -> text: input, value: input
