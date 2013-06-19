###

Access Control
==============

This is a [middleware][] that checks whether agent is authorized to access given path.

`Stakeholder` is a [mongoose][] model describing a person. 

Each authenticated agent has a profile associated with his e-mail address. Another middleware ([profile][profile middleware]) - takes care of that.

####

Stakeholder = require "../models/Stakeholder"
$ = require "../debug"

module.exports = (req, res) ->
  $ "# Access control middleware"
  $ "#{req.method}\t: #{req.url} requested"
  # If agent is not authenticated, then redirect him to `/`
  # unless he is already heading there or trying to authenticate
  # TODO: configuration awareness - make access control profiles, and aply them as midlewares.
  if req.session.username? then res.emit "next"
  else
    if req.method is 'GET'
      if req.url is '/auth'
        $ "ok: Letting agent in to authenticate"
        return res.emit "next"
      else
        $ "not authorized: Redirecting agent to authenticate"
        res.redirect '/auth'
    else 
      if req.method is 'POST' and req.url is '/auth/login'
        $ "ok: Agent requested authentication"
        res.emit "next"
      else
        $ "not authorized: agent is not authenticated"
        res.statusCode = 401
        res.end "Not authorized."
    
  