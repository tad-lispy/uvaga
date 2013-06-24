###

Issues controller
=================

This controlls /issues/ urls and /[0-9]+ which is a shortcut to single issue.

###

mongoose    = require "mongoose"
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
      Issue
      .find()
      .sort(importance: -1)
      .exec (error, issues) =>
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
      relations = _.pick @req.body, [
        "affected"
        "concerned"
        "commited"
      ]
      $ "New issue data:"
      $ data
      $ "Relations"
      $ relations

      issue = new Issue data
      $ @req.session
      for relation of relations
        $ "Setting issue.#{relation}.stakeholders to #{[ @req.session.stakeholder._id ]}"
        issue[relation].stakeholders = [ @req.session.stakeholder._id ]
      $ "To be saved"
      $ issue
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
        $ "New issue saved"
        $ issue
        @res.message "Thank you! Your issue is now a public concern :)"
        @res.redirect "/issues/"

    "/__new":
      get: -> 
        data = 
          suggestions : {}
          relations   : ['concerned'] # let concerned be checked by default
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

    "/:slug":
      get: (slug) -> 
        $ "Show an issue # #{slug}"
        data = 
          suggestions : {}
          relations   : []
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
          (done) =>
            Issue.findOne { slug }, (error, issue) =>
              if issue
                _.extend data, { issue }
                data.relations = issue.relations @req.session.stakeholder._id
              else
                $ "issue # 404 :P"
                @res.statusCode = 404
                return @bind "not-found", message: "No such issue :("
              done error
        ], (error) =>
          if error then throw error
          $ "Data to show"
          $ data
          @bind "issue", data

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
