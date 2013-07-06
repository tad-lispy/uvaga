###

Main controller
===============

It controlls `/` and various other paths.

Learn [more about controllers](https://github.com/twilson63/creamer/tree/master/examples/mvc).


###
async       = require "async"
controller  = require "../access-control"
Issue       = require "../models/Issue"
Stakeholder = require "../models/Stakeholder"
_           = require "underscore"
$           = (require "debug") "Index controllers"

module.exports = 
  "/":
    get: controller ->
      stakeholder = new Stakeholder @req.session.stakeholder
      async.waterfall [
        (done) =>
          # Get related issues
          Issue.aggregate [
            { $unwind: "$relations" }
            { $match: 
              "relations._id": stakeholder._id
              $or: [
                {"relations.committed": true},
                {"relations.affected" : true},
                {"relations.concerned": true}
              ] 
            }
            { $sort: importance: -1 }
          ], done
        (related, done) =>
          # get other issues
          rids = related.map (issue) -> issue._id
          Issue.find(_id: $nin: rids).sort(importance: -1).exec (error, other) ->
            done error, {related, other}
      ], (error, issues) =>
        if error then throw error
        @bind "index", { issues }

  "/auth":
    get: ->
      @bind "authenticate", layout: navbar: false

  "/([0-9]+)":
    get: (number) -> @res.redirect "/issues/#{number}"

  "/licence":
    get: controller "anyone", ->
      # TODO: display it pretty, but don't parse markdown on each request (?)
      @res.redirect "/assets/license.md"
