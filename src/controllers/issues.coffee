###

Issues controller
=================

This controlls /issues/ urls and /[0-9]+ which is a shortcut to single issue.

###

Stakeholder = require "../models/Stakeholder"
Issue       = require "../models/Issue"
_           = require "underscore"
async       = require "async"
qrcode      = require "qrcode"
controller  = require "../access-control"
debug       = require "debug"
$           = debug "uvaga:issues-controllers"

save = (number) ->
  # Used in POST of /issues/ and /issue/:number
  $ = debug "uvaga:issues-controllers:save"

  stakeholder = new Stakeholder @req.session.stakeholder
  
  # Issue data
  data = _.pick @req.body, [
    "description"
    "scopes"
  ]
  if typeof data.scopes is "string"
    data.scopes = data.scopes.split /; ?/

  $ "New issue data: %j", data

  # If number was set, then we are updating existing issue
  # otherwise we are creating a new one
  async.waterfall [
    (done) =>
      # Retrive or create new issue
      $ = debug "uvaga:issues-controllers:save:get-or-create"
      if number? then Issue.findOne { number }, (error, issue) =>
        $ "Got one: %j", issue
        done null, (_.extend issue, data)
      else 
        issue = new Issue data
        issue.relations.push {
          _id       : stakeholder
          affected  : false
          concerned : true
          committed : false
        }
        $ "New issue created: %j", issue
        done null, issue
  ], (error, issue) =>
    if error then throw error
    $ "To be saved: %j", issue

    issue.save (error) =>
      if error
        $ "Error saving issue document: %j", error
        if error.name is "ValidationError"
          for field of error.errors
            @res.message (@i18n.__ "%s was missing.", @i18n.__ field), "error"
        else
          @res.message (@i18n.__ "There was an error. Sorry !("), "error"
        
        return @res.redirect "/issues/" + (slug ? "__new")

      # No error
      $ "Issue saved: %j", issue
      if number? then @res.message "Thank you! Your changes were applied :)"
      else            @res.message "Thank you! Your issue is now a public concern :)"
      @res.redirect "/#{issue.number}"

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
          @bind "issue-edit", data

    "/([0-9]+)":
      get: controller (number) -> 
        $ = debug "uvaga:issues-controllers:get:issue"
        $ "Show an issue #%d", number
        # TODO: there will be a mess when we let anonymous access to this
        stakeholder = new Stakeholder @req.session.stakeholder

        async.parallel {
          issue       : (done) => 
            query = Issue.findOne { number }
            query.populate "comments.author"
            query.populate "relations._id"
            query.exec done
          qrcode      : (done) =>
            url = (@app.config.get "persona:audience") + number
            qrcode.toDataURL url, done
          scripts     : (done) -> done null, [ "/assets/scripts/app/issue.js" ]
        }, (error, data) =>
          if error then throw error
          if data.issue?
            data.relation  = data.issue.relations.id stakeholder._id
            data.relation ?= {}

            # Who is commited?
            data.commitee  = (data.issue.relations.filter (relation) -> relation.committed).map (relation) ->
              relation._id
            $ "Data to show: %j", data
          else
            $ "issue # 404 :P"
            @res.statusCode = 404
            return @bind "not-found", message: "No issue by thant number (#{number})"

          @bind "issue", data

      # Update issue
      post: controller save

      "/edit":
        get: controller (number) -> 
          $ = debug "uvaga:issues-controllers:get:issue:edit"
          $ "Show an issue # #{number}"
          # TODO: there will be a mess when we let anonymous access to this
          stakeholder = new Stakeholder @req.session.stakeholder

          async.parallel {
            suggestions : (done) ->
              Issue
              .find()
              .distinct "scopes", (error, scopes) ->
                done error, { scopes }
            issue       : (done) => 
              query = Issue.findOne { number }
              query.populate "comments.author"
              query.populate "relations._id"
              query.exec done
            scripts     : (done) -> done null, [ "/assets/scripts/app/issue.js" ]
          }, (error, data) =>
            if error then throw error
            if data.issue?
              data.relation  = data.issue.relations.id stakeholder._id
              data.relation ?= default_relation

              # Who is commited?
              data.commitee  = (data.issue.relations.filter (relation) -> relation.committed).map (relation) ->
                relation._id
              $ "Data to show %j", data
            else
              $ "issue # 404 :P"
              @res.statusCode = 404
              return @bind "not-found", message: "No issue by thant number :("

            @bind "issue-edit", data


      "/relation":
        post: controller (number) ->
          # Update issue - acting stakeholder relation 
          $ = debug "uvaga:issues-controllers:relation:set"
          
          stakeholder = new Stakeholder @req.session.stakeholder
          # Stakeholder's updated relation to this issue
          relation = _.pick @req.body, [
            "affected"
            "concerned"
            "committed"
          ]
          $ "Setting relation of %s to issue # %d: %j", stakeholder.email, number, relation
          _.extend relation, _id: stakeholder
          Issue.findOne { number }, (error, issue) =>
            if error then throw new Error
            if not issue
              @res.statusCode = 404
              @res.bind "not-found", "There is no issue ##{number}"

            do (issue.relations.id stakeholder)?.remove
            issue.relations.push relation

            issue.save (error) =>
              if error 
                $ "Error saving issue document: %j", error
                if error.name is "ValidationError"
                  for field of error.errors
                    @res.message "Error in #{field}", "error"
                    @res.redirect "/issues/#{number}"
                else # error other then validation
                  @res.message "There was an error. Sorry !(", "error"
                  @res.redirect "/issues/#{number}"
              
              # finally
              return @res.redirect "/issues/#{number}"

      "/comments":
        post: controller (number) ->
          stakeholder = new Stakeholder @req.session.stakeholder
          if not @req.body.comment? then return @res.redirect "/issues/#{number}"
          content = @req.body.comment
          Issue.findOne { number }, (error, issue) =>
            if error then throw error
            $ issue
            issue.comments.push
              author  : stakeholder
              content : content
            issue.save (error) =>
              if error
                if error.name is "ValidationError"
                  for field of error.errors
                    field = do (field.split '.').pop
                    @res.message "#{field} was missing.", "error"
                else
                  @res.message "There was an error. Sorry !(", "error"
                
                return @res.redirect "/issues/#{number}"
              
              comment = do issue.comments.pop
              $ "Comment is"
              $ comment
              $ issue.comments
              return @res.redirect "/issues/#{number}#comment-#{comment._id}"
