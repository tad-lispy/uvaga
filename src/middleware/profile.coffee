###
Profile middleware
==================

This is a [middleware][] that checks whether authenticated participant have created a profile. If there is no profile for him, we redirect him to create one.

`Participant` is a [mongoose][] model describing a profile.
####

Participant = require "../models/Participant"

module.exports = (req, res) ->
  if req.method is "GET" and req.session.username? 
    unless req.url is "/participants?new"
      Participant.findOne email: req.session.username, (error, participant) ->
        if error then throw error
        if participant?
          # If participant has a profile then put it in session to be available everywhere.
          req.session.profile = participant
          res.emit "next"
        # else make him create one. That way there is no way for him to be logged in and not to have a profile. 
        else res.redirect "/participants?new" 

    else res.emit "next"
  else res.emit "next"