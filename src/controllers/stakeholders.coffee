###
Stakeholders controller
=======================

This controlls /stakeholders/ urls, that are related to stakeholders (so called users), as you can guess.

###

Stakeholder = require "../models/Stakeholder"
Issue       = require "../models/Issue"
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
        @bind "stakeholders", { stakeholders, title: "Stakeholders" }

    post: ->
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

          if stakeholder?
            $ "# Warning: new stakeholder document requested, but email is already registered."
            $ "## New data:"
            $ data
            $ "## Existing data:"
            $ data
            @res.message """ 
              This e-mail (#{stakeholder.email}) is already in use.
              You cannot create more then one profile.
              Would you rather
              <a href='/stakeholders/#{stakeholder.slug}'>
              make changes to the one you already have
              </a>?
            """, "error"

          else stakeholder = new Stakeholder data

          stakeholder.save (error) =>
            if error
              $ "Error saving stakeholder's document"
              $ error
              if error.name is "ValidationError"
                for field of error.errors
                  @res.message "#{field} was missing.", "error"
              else
                @res.message "There was an error. Sorry !(", "error"
              # @bind stakeholder with error data
              return @res.redirect "/stakeholders/__new"

            # if everything is fine
            $ "New stakeholder document saved"
            @res.message "Thank you! You are good to go."
            @res.redirect "/"
    
    "/__new":
      get: -> 
        data = 
          suggestions : {}
          scripts     : [
            "/assets/scripts/app/stakeholder.js"
          ]

        async.parallel [
          (done) ->
            Stakeholder
            .find()
            .distinct "groups", (error, groups) ->
              _.extend data.suggestions, { groups }
              done error
        ], (error) =>
          if error then throw error
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
            "/assets/scripts/app/stakeholder.js"
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

      post: (slug) ->
        $ "Updating #{slug}"
        data = _.pick @req.body, [
          "name"
          "telephone"
          "occupation"
          "groups"
        ]
        if typeof data.groups is "string"
          data.groups = data.groups.split /; ?/

        $ "Updated stakeholder's data:"
        $ data

        Stakeholder.findOne
          slug: slug
          (error, stakeholder) =>
            if error then throw error

            if not stakeholder?
              $ "# Warning: stakeholder update requested for nonexistent slug: #{slug}."
              $ data
              @res.message "There was an error. Sorry !(", "error"
              return @res.redirect "/stakeholders/#{slug}"

            for attribute, value of  data
              stakeholder[attribute] = value

            stakeholder.save (error) =>
              if error
                $ "Error saving stakeholder's document"
                $ error
                if error.name is "ValidationError"
                  for field of error.errors
                    @res.message "#{field} was missing.", "error"
                else
                  @res.message "There was an error. Sorry !(", "error"
                return @res.redirect "/stakeholders/#{slug}"
              @res.redirect "/stakeholders/" + stakeholder.slug
