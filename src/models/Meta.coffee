###
Metadata model
==============

It stores other models metadata (like next autonumber) and possibly other various things (config?)

###

mongoose = require "mongoose"
Meta = new mongoose.Schema { 
  _id   : String
  data  : Object
}, collection: "meta"

module.exports = mongoose.model "Meta", Meta