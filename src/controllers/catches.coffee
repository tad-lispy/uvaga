###
Catches controller
==================

This controlls /catches/ urls, that are related to catches (aka vicious circles).

###

Catch       = require "../models/Catch"
Participant = require "../models/Participant"
_           = require "underscore"
helpers     = require "creamer-helpers"


module.exports = 
  "/catches":
    get: ->
      Catch.find().populate('victims').sort(bodycount: -1).exec (error, catches) =>
        if error then throw error
        @bind "catches", {catches}

    post: ->
      # Sanitize
      data = _.pick @req.body, ["steps"]
      # Strip empty steps (there is usually at least one - the last)
      data.steps = data.steps.filter (e) -> if e then true else false
      
      if not @req.session.username then @res.end "Not authorized."
      Participant.findOne email: @req.session.username, (error, participant) =>
        if error then thorw error
        if not participant then return @res.end "Not authorized. Create a profile first."

        # `catch` is a reserved word :P
        new_catch = new Catch
          victims : [participant]
          steps   : data.steps

        new_catch.save (error) =>
          if error then throw error
          @res.redirect "/catches/" + new_catch.slug
      
    "/__new": 
      get: ->
        @bind "catch", action: "new"

      post: ->
        helpers.not_implemented @


    "/:slug":
      get: (slug) -> 
        Catch.findOne({ slug }).populate('victims').exec (error, the_catch) =>
          if error then throw error
          if the_catch then @bind "catch", { catch: the_catch }
          else helpers.not_found @