Profile check
=============

This is a [middleware][] that checks whether authenticated participant have created a profile. If there is no profile for him, we redirect him to create one.

`Participant` is a [mongoose][] model describing a profile.

    Participant = require "./models/Participant"

    module.exports = (req, res) ->
        if req.method is "GET" and req.session.username? 
          unless req.url is "/participants?new"
            Participant.count email: req.session.username, (error, count) ->
              if error then throw error
              if not count then res.redirect "/participants?new" 
              else res.emit "next"
          else res.emit "next"
        else res.emit "next"