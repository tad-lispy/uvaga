###

Profile middleware
==================

This is a [middleware][] that checks whether authenticated agent have created a profile (i.e. stakeholder document). If there is no profile, we redirect this request to create one.

`Stakeholder` is a [mongoose][] model describing a profile.

####

Stakeholder = require "../models/Stakeholder"

module.exports = (req, res) ->
  # if it's a GET request and agent is authenticated...
  if req.method is "GET" and req.session.username?
    # ...and agent is not trying to create a profile
    unless req.url is "/stakeholders/__new" or req.url.match /\/assets/
      # then look for the profile
      Stakeholder.findOne
        email: req.session.username,
        (error, stakeholder) ->
          if error then throw error
          
          ###
          If there is a profile for this stakeholder
          then put this profile data into agent's session
          ###
          if stakeholder?
            req.session.profile = stakeholder
            res.emit "next"
          
          else res.redirect "/stakeholders/__new"

    # if url is `/stakeholders/__new`
    # then agent is trying to create a profile
    # so proceed as usual
    else res.emit "next" 
  
  # same if `req.method` isn't GET or agent is not authenticated
  else res.emit "next"
