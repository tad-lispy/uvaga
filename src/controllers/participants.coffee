###
Participants controller
=======================

This controlls /participants/ urls, that are related to participants (so called users), as you can guess.

###

Participant = require "../models/Participant"
Catch       = require "../models/Catch"
_           = require "underscore"

module.exports = 
  "/participants":
    get: ->
      if @req.query.new? then @bind "profile"
      else 
        a = @
        Participant.find (error, participants) ->
          if error then throw error
          a.bind "participants", { participants }

    post: ->
      unless @req.session.username
        @res.statusCode = 407
        @bind "profile"
        return
      
      data = _.pick @req.body, ["email", "name"]
      a = @
      Participant.findOneAndUpdate
        email: @req.session.username,
        data,
        upsert: true,
        (error, participant) ->
          if error then throw error

          ###
          We need to save in order to trigger [slugify middleware](../models/slugify.coffee), which updates .slug according to .name.

          Only then we can redirect browser to this slug.
          ###
          participant.save (error) ->
            if error then throw error
            a.res.redirect "/participants/" + participant.slug
      

    "/:slug":
      get: (slug) -> 
        a = @
        Participant.findOne { slug }, (error, participant) ->
          if error then throw error
          # TODO: use virtuals?
          if participant 
            Catch.find
              victims: participant._id,
              (error, catches) ->
                if error then throw error
                participant.catches = catches
                a.bind "profile", { participant }
          else
            # a.res.end 404, "No such participant" 
            a.res.statusCode = 404
            a.bind "not-found"