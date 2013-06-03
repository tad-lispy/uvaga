###
Catches controller
==================

This controlls /catches/ urls, that are related to catches (aka vicious circles).

###

Catch       = require "../models/Catch"
Participant = require "../models/Participant"
_           = require "underscore"

module.exports = 
  "/catches":
    get: ->
      if @req.query.new? then return @bind "catch"
      
      a = @
      Catch.find().populate('victims').sort(bodycount: -1).exec (error, catches) ->
        if error then throw error
        a.bind "catches", {catches}

    post: ->
      data = _.pick @req.body, ["steps"]   
      data.steps = data.steps.filter (e) -> if e then true else false
      
      a = @
      if not @req.session.username then @res.end "Not authorized."
      Participant.findOne email: @req.session.username, (error, participant) ->
        if error then thorw error
        if not participant then return a.res.end "Not authorized. Create a profile first."

        # `catch` is a reserved word :P
        new_catch = new Catch
          victims : [participant]
          steps   : data.steps

        new_catch.save (error) ->
          if error then throw error
          a.res.redirect "/catches/" + new_catch.slug
      

    "/:slug":
      get: (slug) -> 
        a = @
        Catch.findOne({ slug }).populate('victims').exec (error, the_catch) ->
          if error then throw error
          if the_catch then a.bind "catch", { catch: the_catch }
          else
            a.res.statusCode = 404
            a.bind "not-found"