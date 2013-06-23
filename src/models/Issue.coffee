###
Issue model
===========

Issues are the core of Uvaga.

 
###

mongoose    = require "mongoose"
Stakeholder = require "./Stakeholder"
$           = require "../debug"

# Issue has
# * User friendly identifier
# * description (text)
# * scopes (list of strings, like tags)
# * list of affected stakeholders
# * list of concerned stakeholders (who think it's an important issue)
# * list of attendig stakeholders (who declared to take care of it)

Issue = new mongoose.Schema
  number      : 
    type        : Number
    unique      : true
    index       : true
  description : String
  scopes      : [ String ]
  affected    :
    count       : Number
    stakeholders:
      type        : mongoose.Schema.Types.ObjectId
      ref         : 'Stakeholder'
  concerned   :
    count       : Number
    stakeholders:
      type        : mongoose.Schema.Types.ObjectId
      ref         : 'Stakeholder'
  commited    :
    count       : Number
    stakeholders:
      type        : mongoose.Schema.Types.ObjectId
      ref         : 'Stakeholder'
  slug        :
    type        : String
    unique      : true
    required    : true

Meta = require "./Meta"
Issue.pre "validate", (next) ->
  $ "Pre validate"
  # Calculate issue number
  # TODO: make sure it's really unique - even when issues were deleted or something :)
  $ "@constructor (Schema)"
  $ @constructor.collection.name

  Meta.findOneAndUpdate
    _id: "issues"
    { $inc: "data.autonumber": 1 }
    { upsert: true }
    (error, meta) =>
      if error then throw error
      $ meta
      @number = meta.data.autonumber
      do next
  

Issue.pre "validate", (next) ->
  # Make sure counts are in sync
  $ "Counters"
  for counter in ['affected', 'concerned', 'commited']
    quantity = @[counter].stakeholders?.length ? 0
    $ "There are #{quantity} #{counter} stakeholders"
    @[counter].count = quantity

  do next

slugify = require "./slugify"
Issue.plugin slugify, base: "number", numeric: yes

module.exports = mongoose.model 'Issue', Issue