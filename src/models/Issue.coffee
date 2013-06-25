###
Issue model
===========

Issues are the core of Uvaga.

 
###

mongoose    = require "mongoose"
ObjectId    = mongoose.Schema.Types.ObjectId
Stakeholder = require "./Stakeholder"
$           = require "../debug"

# Issue has
# * User friendly identifier (number)
# * description (text)
# * scopes (list of strings, like tags)
# * list of relations to stakeholders (affected, concerned, commited)
# * counters - how many affected, concerned and commited stakeholders
# * importance (number) - how important is it. Sum of counters.
Relation = new mongoose.Schema
  # relations to stakeholders
  _id         :
    # who?
    type        : ObjectId
    ref         : 'Stakeholder'
  affected    : Boolean 
  concerned   : Boolean 
  commited    : Boolean   

Issue = new mongoose.Schema
  number      : 
    type        : Number
    unique      : yes
    index       : yes
  description : String
  scopes      : [ String ]
  relations   : [ Relation ]
  # Counters
  affected    : Number 
  concerned   : Number 
  commited    : Number
  importance  : # affected + concerned + commited
    type        : Number
    index       : yes

# TODO: use generators? https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators
Issue.methods.getRelation = (stakeholder) ->
  # stakeholder can be ObjectId, stringified ObjectId or Stakeholder document

  # Let's cast it to ObjectId
  if stakeholder instanceof Stakeholder
    stakeholder = stakeholder._id
  if typeof stakeholder is "string"
    stakeholder = new ObjectId stakeholder
  if not stakeholder instanceof ObjectId
    throw new Error "Issue.relations method only accepts ObjectId, stringified ObjectId or Stakeholder document"
  
  # look for relation
  for relation in @relations
    if relation.stakeholder.equals stakeholder
      return relation

  # if not found
  return {
    stakeholder
    affected    : false
    concerned   : false
    commited    : false
  }

Issue.methods.setRelation = (relation) ->
  # Sanitize
  defaults = 
    stakeholder : null  # has to be ObjectId
    affected    : false
    concerned   : false
    commited    : false
  if not relation.stakeholder instanceof ObjectId
    throw new Error "relation.stakeholder has to be an ObjectId"
  relation = _.pick     relation, _.keys defaults
  relation = _.defaults relation, defaults

  for r in @relations
    if r.stakeholder.equals relation.stakeholder
      return _.extend r, relation

  # if there was no relation already, create one
  @relations.push relation

Meta = require "./Meta"
Issue.pre "validate", (next) ->
  $ "Pre validate"
  # Calculate issue number
  # TODO: plugin
  $ "@constructor (Schema)"
  $ @constructor.collection.name

  Meta.findOneAndUpdate
    _id: @constructor.collection.name
    { $inc: "data.autonumber": 1 }
    { upsert: true }
    (error, meta) =>
      if error then throw error
      $ meta
      @number = meta.data.autonumber
      do next
  
Issue.pre "validate", (next) ->
  # Make sure related stakeholders are unique and relations are in sync
  $ "Related stakeholders count"
  types = ['affected', 'concerned', 'commited']

  @importance = 0
  for type in types
    @[type] = 0
  for relation in @relations
    for type in types
      if relation[type] then @[type]++

  for type in types
    $ "  #{type}: #{@[type]}"
    @importance += @[type]
  $ "Importance: #{@importance}"

  do next

module.exports = mongoose.model 'Issue', Issue