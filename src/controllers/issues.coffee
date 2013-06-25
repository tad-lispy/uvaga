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

default_relation =
  affected    : false
  concerned   : false
  commited    : false

save = (number) ->
  stakeholder = @req.session.stakeholder
  # Used in POST of /issues/ and /issue/:number

  # Issue data
  data = _.pick @req.body, [
    "description"
    "scopes"
  ]
  if typeof data.scopes is "string"
    data.scopes = data.scopes.split /; ?/

  # Stakeholder's relation to this issue
  relation = _.pick @req.body, [
    "affected"
    "concerned"
    "commited"
  ]
  relation = _.defaults relation, default_relation

  $ "New issue data:"
  $ data
  $ "Relations"
  $ relation

  # If number was set, then we are updating existing issue
  # otherwise we are creating a new one
  async.waterfall [
    (done) =>
      if number? then Issue.findOne { number }, done
      else 
        issue = new Issue data
        $ "New issue created"
        $ issue
        done null, issue

    (issue, done) =>
      $ "Setting relations of"
      $ issue
      r = issue.relations.id stakeholder
      if r? then _.extend r, relation
      else issue.relations.push (_.extend relation, _id: stakeholder)
      done null, issue
  ], (error, issue) =>
    if error then throw error
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
        
        return @res.redirect "/stakeholders/" + (number ? "__new")

      # No error
      $ "Issue saved"
      $ issue
      @res.message "Thank you! Your issue is now a public concern :)"
      @res.redirect "/issues/"

module.exports = 
  "/issues":
    get: ->
      Issue
      .find()
      .sort(importance: -1)
      .exec (error, issues) =>
        if error then throw error
        @bind "issues", { issues, title: "Issues" }

    # Store new issue
    post: save

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

    "/:number":
      get: (number) -> 
        stakeholder = @req.session.stakeholder

        $ "Show an issue # #{number}"
        data = 
          suggestions : {}
          relations   : []
          scripts     : [
            "/assets/scripts/app/issue.js"
          ]

        async.parallel [
          # Get suggested scopes
          (done) ->
            Issue
            .find()
            .distinct "scopes", (error, scopes) ->
              _.extend data.suggestions, { scopes }
              done error
          # Get issue document
          (done) =>
            Issue.findOne { number }, (error, issue) =>
              if issue
                _.extend data, { issue }
                # throw "Doesn't work!"
                data.relations = issue.relations.id stakeholder
                data.relations ?= default_relation
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

      # Update issue
      post: save
