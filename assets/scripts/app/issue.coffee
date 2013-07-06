jQuery ($) ->
  ($ "input#scopes, select#scopes").selectize
    delimiter: ";"
    create: (input) -> text: input, value: input
  $relation_form = $ "form.relation"
  ($relation_form.find "input").change ->
    do $relation_form.submit
    