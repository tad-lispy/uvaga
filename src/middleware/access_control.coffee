###
Access Control
==============

This is a [middleware][] that checks whether authenticated participant or guest is authorized to access given path

`Participant` is a [mongoose][] model describing a profile.
####

Participant = require "../models/Participant"

module.exports = (req, res) ->
  console.log "TODO: Access control"
  