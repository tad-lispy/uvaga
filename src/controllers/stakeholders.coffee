###
Stakeholders controller
=======================

This controlls /stakeholders/ urls, that are related to stakeholders (so called users), as you can guess.

###

Stakeholder = require "../models/Stakeholder"
Catch       = require "../models/Catch"
_           = require "underscore"
async       = require "async"
$           = require "../debug"
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
      if typeof data.groups is "string"
        data.groups = data.groups.split /; ?/
      data.email = @req.session.username

      $ "New stakeholder's data:"
      $ data

      Stakeholder.findOne
        email: @req.session.username,
        (error, stakeholder) =>
          if error then throw error
          $ "Ok so far."

          if stakeholder?
            $ "# Warning: new stakeholder document requested, but email is already registered."
            $ "## New data:"
            $ data
            $ "## Existing data:"
            $ data
          else stakeholder = new Stakeholder data
          ###
          We need to save in order to trigger [slugify middleware](../models/slugify.coffee), which updates .slug according to .name.

          Only then we can redirect browser to this slug.
          ###
          stakeholder.save (error) =>
            if error
              $ "Error saving stakeholder's document"
              $ error
              # TODO: @bind stakeholder with error data
              return @res.redirect "/stakeholders/__new"
            @res.redirect "/stakeholders/" + stakeholder.slug
    
    "/__new":
      get: -> 
        data = 
          suggestions : {}
          scripts     : [
            "/assets/stakeholder.js"
          ]

        async.parallel [
          (done) ->
            Stakeholder
            .find()
            .distinct "groups", (error, groups) ->
              $ groups
              _.extend data.suggestions, { groups }
              done error
        ], (error) =>
          if error then throw error
          $ data
          @bind "stakeholder", data

        # Only let authenticated users in
        # if @req.session?.username? then 
        #   @bind "stakeholder"
        # else 
        #   @res.statusCode = 401
        #   @res.end "Not authenticated."

    "/:slug":
      get: (slug) -> 
        # Try to DRY here. See `/__new`
        data = 
          suggestions: {}
          scripts     : [
            "/assets/stakeholder.js"
          ]
          
        async.parallel [
          
          # Get stakeholder
          (done) ->
            Stakeholder.findOne { slug }, (error, stakeholder) =>
              if stakeholder then _.extend data, { stakeholder }
              else
                @res.statusCode = 404
                @bind "not-found", "Nobody at this address."

              done error
          
          # get group suggestions
          (done) ->
            Stakeholder
            .find()
            .distinct "groups", (error, groups) ->
              _.extend data.suggestions, { groups }
              done error
        ], (error) =>
          if error then throw error
          @bind "stakeholder", data
