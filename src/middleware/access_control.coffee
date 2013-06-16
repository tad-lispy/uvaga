###

Access Control
==============

This is a [middleware][] that checks whether agent is authorized to access given path.

`Stakeholder` is a [mongoose][] model describing a person. 

Each authenticated agent has a profile associated with his e-mail address. Another middleware ([profile][profile middleware]) - takes care of that.

####

Stakeholder = require "../models/Stakeholder"

module.exports = (req, res) ->
  console.log "TODO: Access control"
  