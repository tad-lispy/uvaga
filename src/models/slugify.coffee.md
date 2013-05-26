Slugify
=======

It's a [mongoose plugin][] make proper slugs for documents

    _ = require "underscore.string"

    defaults = 
      base: "name"

    module.exports = (schema, options = {}) ->
      for key, value of defaults
        options[key] ?= value

      if schema.paths[options.base]
        schema.pre "save", (next) ->
          # TODO: make it smarter - if slug is already in use, add suffix.
          @slug = if @slug then _.slugify @slug else _.slugify @[options.base]
          do next
          
      else throw new Error """
        Given schema has no field '#{options.base}'.
        You can set field on which slug will be based using 'base' property of options object (second parameter to Schema.plugin method).
      """

[mongoose plugin]: #