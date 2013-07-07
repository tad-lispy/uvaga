###

Avatars controller
==================

It controlls `/avatars`

###

im          = require "imagemagick"
fs          = require "fs"
path        = require "path"
async       = require "async"
controller  = require "../access-control"
_           = require "underscore"
debug       = require "debug"
$           = debug "uvaga:controller:avatars"

module.exports = 
  "/avatars/:shape/:background/:color/:size":
    # TODO: secure it (DOS and other nasty things on the horizon)
    get: controller "anyone", (shape, background, color, size) ->
      $ = debug "uvaga:controller:avatars:get"
      dir   = path.resolve __dirname, "../../avatars/"
      cache = "#{dir}/cache/"
      if not fs.existsSync cache then fs.mkdirSync cache
      file  = "#{cache}/#{shape}-#{background}-#{color}-#{size}.png"
      $ "Getting file %s", file
      fs.exists file, (exists) =>
        if exists then return (fs.createReadStream file).pipe @res
        else 
          $ "%s doesnt exist yet", file
          svg_file = path.resolve __dirname, "../../avatars/#{shape}.svg"
          fs.exists svg_file, (exists) =>
            if not exists
              $ "%s doesnt exist either", svg_file
              @res.statusCode = 404
              return @bind "not-foind", "No such shape avatar as #{shape}"
            

            im.convert [
              svg_file
              "-resize"
              size
              "+level-colors"
              "#{background},#{color}"
              file
            ], (error) =>
              if error then throw error
              return (fs.createReadStream file).pipe @res

