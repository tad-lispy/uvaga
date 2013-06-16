###

Profile middleware
==================

This is a [middleware][] that checks whether authenticated agent have created a profile (i.e. stakeholder document). If there is no profile, we redirect this request to create one.

`Stakeholder` is a [mongoose][] model describing a profile.

####

Stakeholder = require "../models/Stakeholder"

module.exports = (req, res) ->
  # TODO: refactoring.
  # Requests should be only allowed when:
  # Method is GET and url is /stakeholders/__new
  # Method is GET and url matches /assets/*
  # Method is POST and url is /stakeholders/

  # In the mean time:
  # if it's a GET request and agent is authenticated...
  if req.method is "GET" and req.session.username?
    # ...and agent is not trying to create a profile
    unless (
      req.url is "/stakeholders/__new" or
      Boolean (req.url.match /\/assets/) or
      # This below is to let agent request suggestions for forms - /json/groups ATM.
      # TODO: This is a security hole! Gather suggestions in model or controller, not via ajax.
      Boolean (req.url.match /\/json/)
    )
      Stakeholder.findOne
        email: req.session.username,
        (error, stakeholder) ->
          if error then throw error
          
          ###
          If there is a profile for this stakeholder
          then put this profile data into agent's session
          ###
          if stakeholder? res.emit "next"
          
          else res.redirect "/stakeholders/__new"

    # if url is `/stakeholders/__new` or `/assets/*` or `/json/*`
    # then perhaps agent is trying to create a profile or access some assets
    # so proceed as usual
    else res.emit "next" 
  
  # same if `req.method` isn't GET or agent is not authenticated
  # TODO: This is a security hole as well. See above.
  else res.emit "next"
