mongoose = require "mongoose"

User     = require "./User"
Question = require "./Question"

Answer = new mongoose.Schema {
  question:
    type  : mongoose.Schema.Types.ObjectId
    ref   : 'Question'
  text    : String
  basis   : [{
    act       : String
    unit      : String
    statement : String
    }]
  author:
    type  : mongoose.Schema.Types.ObjectId
    ref   : 'User'
}

# Be sure to drop indexes if you change that - otherwise expect unexpected
Answer.index {question: 1, author: 1}, {unique: 1, name: "One answer per author for question"}

module.exports = mongoose.model 'Answer', Answer