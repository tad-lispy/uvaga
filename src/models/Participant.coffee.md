Participant model
=================

This represents a single participant.

Who is a participant?
---------------------

Participant is a person, you would normally call "a user". Why not "user"? Because we don't use them, nor do they use us. We all participate in the experiment :)

All persistant data, including participants profiles is handeld by [mongoose][].

    mongoose = require "mongoose"

Each participant has 

* a name, which is presented to other participants;
* an e-mail, by which he is authenticated with Persona;
* a slug, which is calculated from name to be used in urls.

Take a look at my [mongoose slugify plugin][]

    Participant = new mongoose.Schema {
      name  :
        type      : String
        unique    : true
        required  : true
      email : 
        type      : String
        lowercase : true
        unique    : true
        required  : true
      slug  :
        type      : String
        unique    : true
    }
    
    Participant.plugin require "./slugify"

    module.exports = mongoose.model 'Participant', Participant

[mongoose]:                 http://mongoosejs.com/
[mongoose slugify plugin]:  slugify