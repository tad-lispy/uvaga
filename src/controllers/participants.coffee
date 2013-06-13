###
Participants controller
=======================

This controlls /participants/ urls, that are related to participants (so called users), as you can guess.

###

Participant = require "../models/Participant"
Catch       = require "../models/Catch"
_           = require "underscore"
###
TODO: integrate helpers with creamer. Maybe just add third parameter (status code) to @bind?
###
helpers     = require "creamer-helpers"


module.exports = 
  "/participants":
    get: ->
      if @req.query.new? then @bind "profile"
      else
        Participant.find (error, participants) =>
          if error then throw error
          @bind "participants", { participants }

    post: ->
      unless @req.session.username
        @res.statusCode = 407
        @bind "profile"
        return
      
      data = _.pick @req.body, ["email", "name"]
      Participant.findOneAndUpdate
        email: @req.session.username,
        data,
        upsert: true,
        (error, participant) =>
          if error then throw error

          ###
          We need to save in order to trigger [slugify middleware](../models/slugify.coffee), which updates .slug according to .name.

          Only then we can redirect browser to this slug.
          ###
          participant.save (error) ->
            if error then throw error
            @res.redirect "/participants/" + participant.slug
      

    "/:slug":
      get: (slug) -> 
        Participant.findOne { slug }, (error, participant) =>
          if error then throw error
          # TODO: use virtuals?
          if participant 
            Catch.find
              victims: participant._id,
              (error, catches) =>
                if error then throw error
                participant.catches = catches
                @bind "profile", { participant }
          else helpers.not_found @, "Nobody at this address."