###
Slugify
=======

It's a [mongoose plugin][] that makes proper slugs for documents
###

mongoose = require "mongoose"
_        = require "underscore.string"

defaults = 
  base: "name"

module.exports = (schema, options = {}) ->
  for key, value of defaults
    options[key] ?= value

  if not schema.paths[options.base] then throw new Error """
    Given schema has no field '#{options.base}'.
    You can set field on which slug will be based using 'base' property of options object (second parameter to Schema.plugin method).
  """

  schema.pre "validate", (next) ->
    # If slug is already set, then just make sure it's proper.
    if @slug then @slug = _.slugify @slug
    else
      source = @[options.base]
      # if it's an array, convert it to string
      if source instanceof Array then source = source.join "-"
      # if it's anything else, convert it to string
      else source = do source.toString
      
      @slug = _.slugify source

    if @slug.match /^[0-9]+$/ then @slug = "_" + @slug
    # Limit length of slug to 64 characters
    @slug = @slug.substr 0, 64

    # TODO: make it smarter - if slug is already in use, add suffix.
    model = @model @constructor.modelName
    doc   = @
    increment_slug = ->
      console.log "trying #{doc.slug}"
      model.count
        slug: doc.slug
        _id:
          $ne: doc.id
        (error, count) ->
          if error then throw error  
          # if the slug is unique we are done
          if not count then do next
          # if it's in use, increment it and try again
          else 
            doc.slug = if match = doc.slug.match /-(\d+)$/ 
              doc.slug.replace /\d+$/, (parseInt match[1])+1
            else doc.slug += "-1"
            do increment_slug

    do increment_slug

###
[mongoose plugin]: #
###