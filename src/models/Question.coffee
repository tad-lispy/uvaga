mongoose = require "mongoose"

User = require "./User"

Question = new mongoose.Schema {
  # Schema definition
  short : String
  long  : String
  author:
    type  : mongoose.Schema.Types.ObjectId
    ref   : 'User'
  slug  :
    type  : String
    unique: true
}

slugify = require "./slugify"
Question.plugin slugify, base: "short"



module.exports = mongoose.model 'Question', Question