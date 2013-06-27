###
Issue model
===========

Issues are the core of Uvaga.

 
###

mongoose    = require "mongoose"
Stakeholder = require "./Stakeholder"
_           = require "underscore"
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
    type        : mongoose.Schema.ObjectId
    ref         : 'Stakeholder'
    required    : yes
  affected    : 
    type        : Boolean 
    default     : false
  concerned   : 
    type        : Boolean 
    default     : false
  commited    : 
    type        : Boolean 
    default     : false

Issue = new mongoose.Schema
  number      : 
    type        : Number
    unique      : yes
    index       : yes
    required    : yes
  description : 
    type        : String
    required    : yes
  scopes      : [ String ]
  relations   : [ Relation ]
  # Counters
  affected    : Number 
  concerned   : Number 
  commited    : Number
  importance  : # affected + concerned + commited
    type        : Number
    index       : yes

# TODO: make a plugin
Meta = require "./Meta"
Issue.pre "validate", (next) ->
  $ "Pre validate"
  # Calculate issue number
  # TODO: plugin
  $ "@constructor (Schema)"
  $ @constructor.collection.name

  if @number 
    return do next 
  else Meta.findOneAndUpdate
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