###

Profile middleware
==================

This is a [middleware][] that checks whether authenticated agent have created a profile (i.e. stakeholder document). If there is no profile, we redirect this request to create one.

`Stakeholder` is a [mongoose][] model describing a profile.

###

Stakeholder = require "../models/Stakeholder"
debug       = require "debug"
$           = debug "uvaga:middleware:profile-check"

###

Summary
-------

Requests should be only allowed when:

* Agent is authenticated and has a stakeholders profile
* Method is GET  and url is /stakeholders/__new
* Method is GET  and url is /assets/*
* Method is POST and url is /stakeholders/

###


module.exports = (req, res) ->
  $ "#{req.method}\t: #{req.url} requested"
  # If agent is not authenticated, then let him in (security will hendle him later)
  if not req.session.username? then return res.emit "next"
  # If agent is authenticated
  else
    $ "user is authenticated"
    # and if profile exists and is loaded into session
    # then let the agent in
    if req.session.stakeholder?
      $ "profile exists and is loaded into session"
      return res.emit "next"
    # else check if profile exists in DB, but is not yet loaded
    else
      $ "No profile in session"

      Stakeholder.findOne
        email: req.session.username
        (error, stakeholder) ->
          if error then throw error
          
          ###

          If there is a profile for this stakeholder,
          but it wasn't loaded into session yet
          then put this profile data into agent's session
          and let the agent in
          
          **Why?**
          
          To save a db query on every subsequent request, dear Watson.

          **Potential bug**

          If data is in the session, but not in the db (eg. if stakeholder document was removed after stakeholder authenticated), then agent will be passed through.

          Won't fix?

          ###

          if stakeholder?
            $ "there is a profile for this stakeholder, but it wasn't loaded into session yet"
            req.session.stakeholder = stakeholder
            return res.emit "next"

            ###

            If, however, there is no profile in db as well
            then redirect our fellow agent to the form,

            unless

            ###
          else
            $ "there is no profile in db as well"
            unless (
              req.method is "GET" and (
                # 1. agent is already going to fill a profile form
                req.url is "/stakeholders/__new" or
                # 2. agent wants some assets
                Boolean (req.url.match /^\/assets/) or
                # 3. agent wants an avatar
                Boolean (req.url.match /^\/avatars/)
              ) or req.method is "POST" and (
                # 3. the form is being sent along with this request
                req.url is "/stakeholders" or
                # 4. agent wants to authenticate or logout
                Boolean (req.url.match /^\/auth/)
              )
            )
              # TODO: It is displayed for new stakeholders, before they fill profile. Stop it!
              res.message "Please provide at least your name before proceeding to #{req.url}", "error" unless req.url is "/auth"
              return res.redirect "/stakeholders/__new" 
            res.emit "next"