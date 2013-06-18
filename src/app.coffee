###
Application
===========

This is the main entry point of Uvaga application.

It's an application to ...

The app is [Flatiron][] based. Templates are powered by [Creamer][] - an excelent [Coffecup][] plugin with MVC capabilities. User authentication uses [Mozilla Persona][] with my humble [plugin][Flatiron Persona], which requires session and cookie parser middleware from [Connect][]. 
###

flatiron = require 'flatiron'
creamer  = require 'creamer'
persona  = require 'flatiron-persona'
connect  = require 'connect'
path     = require 'path'
mongoose = require 'mongoose'
$        = require "./debug"
app      = flatiron.app

###
Runtime configuration is done with [nconf](https://github.com/flatiron/nconf)
###

app.config.use 'file', file: path.join(__dirname, '/../config/config.json')
app.config.defaults {
  host    : "localhost"
  port    : 4000
  secret  : "Kiedy nikogo nie ma w domu, Katiusza maluje pazury na zielono i głośno się śmieje swoim kocim głosem. To prawda!"
}

app.use flatiron.plugins.http
app.use persona, audience: "http://#{app.config.get "host"}:#{app.config.get "port"}/"
app.use creamer,
  layout:       require "./views/layout"
  views:        __dirname + '/views'
  controllers:  __dirname + '/controllers'
app.registerHelper "textbox", require "./views/helpers/textbox"
app.registerHelper "authentication", require "./views/helpers/authentication"
app.registerHelper "$", $
app.router.configure 
  # This enables trailing slashes in routes - otherwise it's 404
  # See: https://github.com/flatiron/director/issues/74
  strict: false
  
  # TODO: access control
  # which route will be called for this request?
  # does agent have sufficien access level for this route?  
  on: ->
    # console.dir app.router.routes
    # console.dir @

app.use flatiron.plugins.static, dir: "assets/", url: "/assets/"

app.http.before.push do connect.cookieParser
app.http.before.push connect.session secret: app.config.get "secret"

# If agent is authenticated via Persona but has no profile, redirect him to `/stakeholders/__new` to create one.
app.http.before.push require "./middleware/profile"

# Let's start listening to requests from our stakeholders:

app.start (app.config.get "port"), ->
  mongoose.connect 'mongodb://localhost/uvaga'
  app.log.info "Uvaga! http://#{app.config.get "host"}:#{app.config.get "port"}/"

###
[Vicious circle]:   http://en.wikipedia.org/wiki/Vicious_circle
[Flatiron]:         http://flatironjs.org/
[Creamer]:          https://github.com/twilson63/creamer
[Coffecup]:         https://github.com/gradus/coffeecup
[Mozilla Persona]:  http://www.mozilla.org/en-US/persona/
[Flatiron Persona]: https://github.com/lzrski/flatiron-persona
[Connect]:          http://www.senchalabs.org/connect/
###