###

Access Control
==============

This is a [middleware][] that checks whether agent is authorized to access given path.

`Stakeholder` is a [mongoose][] model describing a person. 

Each authenticated agent has a profile associated with his e-mail address. Another middleware ([profile][profile middleware]) - takes care of that.

####

Stakeholder = require "../models/Stakeholder"
debug = require "debug"
$     = debug "uvaga:middleware:access-control"

module.exports = (req, res) ->
  $ "%s\t%s requested", req.method, req.url 

  unless req.session.username?
    
    ###
    
    If agent is not authenticated, then redirect him to `/auth`
    unless he is already heading there or trying to authenticate
    TODO: configuration awareness - make access control profiles, and aply them as midlewares.
    
    ###

    if req.method is 'GET'
      if req.url is '/auth'
        $ "ok: Letting agent in to authenticate"
        return res.emit "next"
      else if req.url.match /^\/assets\//
        $ "ok: Letting agent have some of our assets"
        return res.emit "next"      
      else
        $ "not authorized: Redirecting agent to authenticate"
        res.message "Not authenticated. You cannot access #{req.url} until you authenticate.", "warning" unless req.url is "/"
        # Store requested url in order to redirect agent back after succesful authentication
        req.session.redirect = req.url
        res.redirect '/auth'
    else 
      if req.method is 'POST' and req.url is '/auth/login'
        $ "ok: Agent requested authentication"
        res.emit "next"
      else
        $ "not authorized: agent is not authenticated"
        res.statusCode = 401
        res.end "Not authorized."
  else
    ###

    If agent is an authenticated stakeholder, then 

    ###
    if req.session.redirect?
      # if being redirected, greet him and redirect
      res.message "Hello, #{req.session.stakeholder?.name ? req.session.username}!"
      $ "Redirecting agent back to #{req.session.redirect}"
      res.redirect req.session.redirect
      delete req.session.redirect
    # at last common situation - authenticated and not redirected
    else res.emit "next"
    
  