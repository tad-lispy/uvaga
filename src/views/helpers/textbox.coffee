module.exports = (attributes) ->
  attributes     ?= {}
  attributes.type = "text"
  attributes.id  ?= attributes.name
  unless attributes.value
    if @form_context?[attributes.name]?
      value = @form_context[attributes.name]
      if value instanceof Array then value = value.join ";"
      attributes.value = value

  input attributes