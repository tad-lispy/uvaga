###
Catch model
===========

Catch is a vicious circle. 

Catch has:

1. victims (stakeholders affected)
2. steps to reproduce (list of at least two 128 character strings)
3. recoveries
4. bodycount (number of victims)
###

mongoose = require "mongoose"

Stakeholder = require "./Stakeholder"

Catch = new mongoose.Schema {
  # Schema definition
  steps  : [String]
  victims: [
    type  : mongoose.Schema.Types.ObjectId
    ref   : 'Stakeholder'
  ]
  # We use bodycount to count victims. We need that to sort catches when querying.
  bodycount: Number
  slug  :
    type  : String
    unique: true
}

Catch.pre "save", (next) ->
  # Make sure bodycount is in sync with victims
  @bodycount = @victims.length
  do next

slugify = require "./slugify"
Catch.plugin slugify, base: "steps"

module.exports = mongoose.model 'Catch', Catch