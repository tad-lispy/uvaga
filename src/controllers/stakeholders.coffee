###
Stakeholders controller
=======================

This controlls /stakeholders/ urls, that are related to stakeholders (so called users), as you can guess.

###

Stakeholder = require "../models/Stakeholder"
Catch       = require "../models/Catch"
_           = require "underscore"
###
TODO: integrate helpers with creamer. Maybe just add third parameter (status code) to @bind?
###
# helpers     = require "creamer-helpers"

module.exports = 
  "/stakeholders":
    get: ->
      Stakeholder.find (error, stakeholders) =>
        if error then throw error
        @bind "stakeholders", { stakeholders }

    post: ->
      unless @req.session.username?
        @res.statusCode = 407
        @bind "profile"
        return
      
      data = _.pick @req.body, [
        "name"
        "telephone"
        "occupation"
        "groups"
      ]
      if typeof data.groups == "string"
        data.groups = data.groups.split /; ?/

      console.dir data

      Stakeholder.findOneAndUpdate
        email: @req.session.username,
        data,
        upsert: true,
        (error, stakeholder) =>
          if error then throw error

          ###
          We need to save in order to trigger [slugify middleware](../models/slugify.coffee), which updates .slug according to .name.

          Only then we can redirect browser to this slug.
          ###
          stakeholder.save (error) =>
            if error then throw error
            @res.redirect "/stakeholders/" + stakeholder.slug
    
    "/__new":
      get: -> 
        # Only let authenticated users in
        # if @req.session?.username? then 
        @bind "stakeholder"
        # else 
        #   @res.statusCode = 401
        #   @res.end "Not authenticated."

    "/:slug":
      get: (slug) -> 
        Stakeholder.findOne { slug }, (error, stakeholder) =>
          if error then throw error
          # TODO: use virtuals?
          if stakeholder
            @bind "stakeholder", { stakeholder }

            # Catch.find
            #   victims: stakeholder._id,
            #   (error, catches) =>
            #     if error then throw error
            #     stakeholder.catches = catches
            #     
          else 
            @res.statusCode = 404
            @bind "not-found", "Nobody at this address."