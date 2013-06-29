###

Issues controller
=================

This controlls /issues/ urls and /[0-9]+ which is a shortcut to single issue.

###
Stakeholder = require "../models/Stakeholder"
Issue       = require "../models/Issue"
_           = require "underscore"
async       = require "async"
controller  = require "../access-control"
$           = require "../debug"
###

TODO: integrate helpers with creamer. Maybe just add third parameter (status code) to @bind?

###
default_relation =
  affected    : false
  concerned   : false
  commited    : false

save = (number) ->
  # Used in POST of /issues/ and /issue/:number

  stakeholder = new Stakeholder @req.session.stakeholder
  
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
      # Retrive or create new issue
      if number? then Issue.findOne { number }, (error, issue) =>
        done null, (_.extend issue, data)
      else 
        issue = new Issue data
        $ "New issue created"
        $ issue
        done null, issue

    (issue, done) =>
      # Set relation to current stakeholder
      $ "Setting relations"
      relation = _.extend relation, _id: stakeholder
      $ relation
      do (issue.relations.id stakeholder)?.remove
      issue.relations.push relation
      $ issue
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
      @res.redirect "/"

module.exports = 
  "/issues":
    get: controller ->
      Issue
      .find()
      .sort(importance: -1)
      .exec (error, issues) =>
        if error then throw error
        @bind "issues", { issues, title: "Issues" }

    # Store new issue
    post: controller save

    "/stats": 
      get: controller "administrator", -> @res.end "Got through!"

    "/__new":
      get: controller -> 
        async.parallel {
          suggestions : (done) ->
            Issue
            .find()
            .distinct "scopes", (error, scopes) ->
              done error, { scopes }
          # TODO: improve async to support immediate assignment if values is not a function
          relation    : (done) -> done null, concerned: true
          scripts     : (done) -> done null, [ "/assets/scripts/app/issue.js" ]
        }, (error, data) =>
          if error then throw error
          @bind "issue", data

    "/([0-9]+)":
      get: controller (number) -> 
        $ "Show an issue # #{number}"
        stakeholder = new Stakeholder @req.session.stakeholder
        $ "stakeholder instanceof Stakeholder?"
        $  stakeholder instanceof Stakeholder
        $ stakeholder

        async.parallel {
          suggestions : (done) ->
            Issue
            .find()
            .distinct "scopes", (error, scopes) ->
              done error, { scopes }
          issue       : (done) => Issue.findOne { number }, done
          scripts     : (done) -> done null, [ "/assets/scripts/app/issue.js" ]
        }, (error, data) =>
          if error then throw error
          if data.issue?
            data.relation  = data.issue.relations.id stakeholder

            data.relation ?= default_relation
            $ "Data to show"
            $ data
          else
            $ "issue # 404 :P"
            @res.statusCode = 404
            return @bind "not-found", message: "No issue by thant number :("

          @bind "issue", data

      # Update issue
      post: controller save
