###
Participants controller
=======================

This controlls /participants/ urls, that are related to participants (so called users), as you can guess.

###

Participant = require "../models/Participant"
_ = require "underscore"

module.exports = 
  "/participants":
    get: ->
      if @req.query.new? then @bind "profile"
      else @bind "participants"
    post: ->
      data = _.pick @req.body, ["email", "name"]
      console.log data
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
            console.dir participant
            a.res.redirect "/participants/" + participant.slug

      ###
      if @req.body.email is @req.session.username
        Participant.update
      ###
      

    "/:slug":
      get: (slug) -> 
        a = @
        Participant.findOne { slug }, (error, participant) ->
          if error then throw error
          a.bind "profile", { participant }