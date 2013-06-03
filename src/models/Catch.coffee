###
Catch model
===========

Catch is a vicious circle. 

Catch has:

1. victims (participants affected)
2. steps to reproduce (list of at least two 128 character strings)
3. recoveries
4. bodycount (number of victims)
###

mongoose = require "mongoose"

Participant = require "./Participant"

Catch = new mongoose.Schema {
  # Schema definition
  steps  : [String]
  victims: [
    type  : mongoose.Schema.Types.ObjectId
    ref   : 'Participant'
  ]
  bodycount: Number
  slug  :
    type  : String
    unique: true
}

Catch.pre "save", (next) ->
  @bodycount = @victims.length
  do next

slugify = require "./slugify"
Catch.plugin slugify, base: "steps"

module.exports = mongoose.model 'Catch', Catch