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
    stakeholders: [
      type        : mongoose.Schema.Types.ObjectId
      ref         : 'Stakeholder'
    ]
  concerned   :
    count       : Number
    stakeholders: [
      type        : mongoose.Schema.Types.ObjectId
      ref         : 'Stakeholder'
    ]
  commited    :
    count       : Number
    stakeholders: [
      type        : mongoose.Schema.Types.ObjectId
      ref         : 'Stakeholder'
    ]
  importance  : Number # affected + concerned + commited
  slug        :
    type        : String
    unique      : true
    required    : true

Issue.methods.relations = (stakeholder) ->
  # stakeholder can be ObjectId, stringified ObjectId or Stakeholder document

  # Let's cast it to ObjectId ...
  ObjectId = mongoose.Types.ObjectId
  if stakeholder instanceof Stakeholder
    stakeholder = stakeholder._id
  if typeof stakeholder is "string"
    stakeholder = new ObjectId stakeholder
  if not stakeholder instanceof ObjectId
    throw new Error "Issue.relations method only accepts ObjectId, stringified ObjectId or Stakeholder document"

  # ... and then back to string (any better idea for validation?)
  stakeholder = do stakeholder.toString
  
  relations = []
  for relation in ['affected', 'concerned', 'commited']
    # Get all related stakeholders ids as strings
    related = @[relation].stakeholders.map (uuid) ->
      do uuid.toString
    # And look for the one we are lookig for
    if stakeholder in related then relations.push relation

  return relations


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
  # Make sure related stakeholders are unique and relations are in sync
  $ "Relations"
  @importance = 0
  for relation in ['affected', 'concerned', 'commited']
    $ "* " + relation
    stakeholders  = @[relation].stakeholders
    stakeholders  = _.unique stakeholders
    quantity      = stakeholders.length ? 0
    $ "  #{quantity} stakeholders"
    @[relation].count = quantity
    @importance      += quantity
  $ "Importance is #{@importance}"

  do next

slugify = require "./slugify"
Issue.plugin slugify, base: "number", numeric: yes

module.exports = mongoose.model 'Issue', Issue