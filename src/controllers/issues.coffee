###
Issues controller
=================

This controlls /issues/ urls and /[0-9]+ which is a shortcut to single issue.

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
  "/issues":
    get: ->
      Issue.find (error, issues) =>
        if error then throw error
        @bind "issues", { issues, title: "Issues" }

    post: ->
      # Issue data
      data = _.pick @req.body, [
        "description"
        "scopes"
      ]
      if typeof data.scopes is "string"
        data.scopes = data.scopes.split /; ?/

      # Stakeholder's relation to this issue
      relation = _.pick @req.body, [
        "affects"
        "concerns"
        "commit"
      ]
      $ "New issue data:"
      $ data
      $ "Relation"
      $ relation

      issue = new Issue data
      issue.save (error) =>
        if error
          $ "Error saving issue document"
          $ error
          if error.name is "ValidationError"
            for field of error.errors
              @res.message "#{field} was missing.", "error"
          else
            @res.message "There was an error. Sorry !(", "error"
          
          return @res.redirect "/stakeholders/__new"

        # No error
        $ "New stakeholder document saved"
        @res.message "Thank you! Your issue is now a public concern :)"
        @res.redirect "/"

      # async.parralel [
      #   (done) ->
      #     Stakeholder
      #     .findOne
      #       email: @req.session.username
      #       (error, stakeholder) =>
      #         if error then done error

      # ]

    "/__new":
      get: -> 
        data = 
          suggestions : {}
          scripts     : [
            "/assets/scripts/app/issue.js"
          ]

        async.parallel [
          (done) ->
            Issue
            .find()
            .distinct "scopes", (error, scopes) ->
              _.extend data.suggestions, { scopes }
              done error
        ], (error) =>
          if error then throw error
          @bind "issue", data

    # "/:slug":
    #   get: (slug) -> 
    #     # Try to DRY here. See `/__new`
    #     data = 
    #       suggestions: {}
    #       scripts     : [
    #         "/assets/scripts/app/stakeholder.js"
    #       ]

    #     async.parallel [
          
    #       # Get stakeholder
    #       (done) ->
    #         Stakeholder.findOne { slug }, (error, stakeholder) =>
    #           if stakeholder then _.extend data, { stakeholder }
    #           else
    #             @res.statusCode = 404
    #             @bind "not-found", "Nobody at this address."

    #           done error
          
    #       # get group suggestions
    #       (done) ->
    #         Stakeholder
    #         .find()
    #         .distinct "groups", (error, groups) ->
    #           _.extend data.suggestions, { groups }
    #           done error
    #     ], (error) =>
    #       if error then throw error
    #       @bind "stakeholder", data

    #   post: (slug) ->
    #     $ "Updating #{slug}"
    #     data = _.pick @req.body, [
    #       "name"
    #       "telephone"
    #       "occupation"
    #       "groups"
    #     ]
    #     if typeof data.groups is "string"
    #       data.groups = data.groups.split /; ?/

    #     $ "Updated stakeholder's data:"
    #     $ data

    #     Stakeholder.findOne
    #       slug: slug
    #       (error, stakeholder) =>
    #         if error then throw error

    #         if not stakeholder?
    #           $ "# Warning: stakeholder update requested for nonexistent slug: #{slug}."
    #           $ data
    #           @res.message "There was an error. Sorry !(", "error"
    #           return @res.redirect "/stakeholders/#{slug}"

    #         for attribute, value of  data
    #           stakeholder[attribute] = value

    #         stakeholder.save (error) =>
    #           if error
    #             $ "Error saving stakeholder's document"
    #             $ error
    #             if error.name is "ValidationError"
    #               for field of error.errors
    #                 @res.message "#{field} was missing.", "error"
    #             else
    #               @res.message "There was an error. Sorry !(", "error"
    #             return @res.redirect "/stakeholders/#{slug}"
    #           @res.redirect "/stakeholders/" + stakeholder.slug
