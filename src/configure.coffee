###

Configure
=========

Update configuration when on AppFog

###
debug = require "debug"
$     = debug "uvaga:configure"


appFog = (app) ->
  $ = debug "uvaga:configure:appfog"
  if process.env.VCAP_APPLICATION?
    application = JSON.parse process.env.VCAP_APPLICATION
    app.config.set "host",  application.uris[0]
    app.config.set "https", true # TODO
  if process.env.VCAP_APP_PORT?
    app.config.set "port",  process.env.VCAP_APP_PORT
    app.config.set "persona:audience", "http://#{app.config.get "host"}/"
  else
    app.config.set "persona:audience", "http://#{app.config.get "host"}:#{app.config.get "port"}/"
  if process.env.VCAP_SERVICES?
    services = JSON.parse process.env.VCAP_SERVICES
    app.config.set "mongo", services['mongodb-1.8'][0]['credentials']

  mongo = app.config.get "mongo"
  if mongo.username and mongo.password
    mongo.url = "mongodb://#{mongo.username}:#{mongo.password}@#{mongo.hostname}:#{mongo.port}/#{mongo.db}"
  else
    mongo.url = "mongodb://#{mongo.hostname}:#{mongo.port}/#{mongo.db}"
  app.config.set "mongo:url", mongo.url
  $ "Done"

modulus = (app) ->
  $ = debug "uvaga:configure:modulus"
  app.config.set "port", process.env.PORT
  app.config.set "host",  process.env.hostname
  app.config.set "mongo:url", process.env.mongourl
  app.config.set "persona:audience", "http://#{app.config.get "host"}/"
  $ "Done"
  
module.exports = (app) ->    
  app.config.set "persona:audience", "http://#{app.config.get "host"}:#{app.config.get "port"}/"
  if process.env.platform is "modulus" then modulus app
  else if process.env.VCAP_APPLICATION? then appFog app

  $ "%j", do app.config.get

