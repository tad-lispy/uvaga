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
      if @req.query.new? then @bind "catch"
      else @bind "catches"

    post: ->
      data = _.pick @req.body, ["steps", "victim"]
      console.dir data
      console.dir @req.body
      do @res.end
    #   a = @
    #   # TODO: Check permission
    #   Participant.findOneAndUpdate
    #     email: @req.session.username,
    #     data,
    #     upsert: true,
    #     (error, participant) ->
    #       if error then throw error

    #       ###
    #       We need to save in order to trigger [slugify middleware](../models/slugify.coffee), which updates .slug according to .name.

    #       Only then we can redirect browser to this slug.
    #       ###
    #       participant.save (error) ->
    #         if error then throw error
    #         a.res.redirect "/participants/" + participant.slug
      

    # "/:slug":
    #   get: (slug) -> 
    #     a = @
    #     Participant.findOne { slug }, (error, participant) ->
    #       if error then throw error
    #       if participant then a.bind "profile", { participant }
    #       else
    #         # a.res.end 404, "No such participant" 
    #         a.res.statusCode = 404
    #         a.bind "not-found"