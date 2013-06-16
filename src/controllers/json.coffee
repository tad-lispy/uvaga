Stakeholder = require "../models/Stakeholder"

module.exports =
  "/json":
    "/groups":
      get: ->
        Stakeholder.find().distinct "groups", (error, groups) =>
          if error then throw error
          @res.json { groups }