###

Stakeholder model
=================

This represents a single stakeholder.

Who is a stakeholder?
---------------------

In terms of data structures, stakeholder is a person you would normally call "a user". Why not "user"? Because it's not about using! It's about sharing goals, ideas and concerns. It's about [engaging stakeholders][stakeholder engagement] :)

All persistant data, including stakeholders profiles is handeld by [mongoose][].

###

mongoose = require "mongoose"

###

Each stakeholder has 

    * a name, which is presented to other stakeholders;
    * an e-mail, by which he is authenticated with Persona;
    * a slug, which is calculated from name to be used in urls.
      Take a look at my [mongoose slugify plugin][]

###

Stakeholder = new mongoose.Schema {
  name      :
    type      : String
    required  : true
  email     : 
    type      : String
    lowercase : true
    unique    : true
    required  : true
  image     : String
  telephone :
    type      : String
  groups    : [ String ]
  occupation: String
  # TODO
  # issues    :
  #   attended  : ?
  #   affecting :
  #   concerning:
  slug      :
    type      : String
    unique    : true
    required  : true  
}
    
Stakeholder.plugin require "./slugify"

module.exports = mongoose.model 'Stakeholder', Stakeholder

###

[mongoose]:                 http://mongoosejs.com/
[mongoose slugify plugin]:  slugify
[stakeholder engagement]:   https://en.wikipedia.org/wiki/Stakeholder_engagement

###