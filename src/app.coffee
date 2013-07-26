###

Uvaga application
=================

This is the main entry point of Uvaga application.

It's an application to share issues.

The app is [Flatiron][] based. Templates are powered by [Creamer][] - an excelent [Coffecup][] plugin with MVC capabilities. User authentication uses [Mozilla Persona][] with my humble [plugin][Flatiron Persona], which requires session and cookie parser middleware from [Connect][]. 

Copyright 2013 Tadeusz Łazurski
 
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

###

do (require "source-map-support").install

debug    = require "debug"
$        = debug "uvaga"

fs       = require 'fs'
flatiron = require 'flatiron'
creamer  = require 'creamer'
persona  = require 'flatiron-persona'
connect  = require 'connect'
path     = require 'path'
mongoose = require 'mongoose'
I18n     = require 'i18n-2'

app      = flatiron.app

###
Runtime configuration is done with [nconf](https://github.com/flatiron/nconf)
###

app.config.use 'file', file: path.join(__dirname, '/../config/config.json')
app.config.defaults {
  host    : "localhost"
  port    : 4000
  secret  : "Kiedy nikogo nie ma w domu, Katiusza maluje pazury na zielono i głośno się śmieje swoim kocim głosem. To prawda!"
  mongo   :
    url     :  "mongodb://localhost/uvaga"
  locales : [
    "pl"
    "en"
  ]
}
(require "./configure") app

i18n = new I18n 
  locales: app.config.get "locales"

app.use flatiron.plugins.http
app.use persona, audience: app.config.get "persona:audience"
app.use creamer,
  layout      : require "./views/layout"
  views       : __dirname + '/views'
  helpers     : __dirname + '/views/helpers'
  controllers : __dirname + '/controllers'
  attach      : (data) ->
    $ "running creamer attach"
    data.i18n = i18n

app.registerHelper "$", debug "uvaga:view"

app.router.configure 
  # This enables trailing slashes in routes - otherwise it's 404
  # See: https://github.com/flatiron/director/issues/74
  strict: false
  notfound: ->
    $ = debug "uvaga:404"
    $ @req.url
    @res.message "Error accessing #{@req.url}", "error"
    @bind "not-found"
app.router.attach ->
  @i18n = i18n

assets = __dirname + "/../assets/"
app.use flatiron.plugins.static, dir: assets, url: "/assets/"

app.http.before.push do connect.cookieParser
app.http.before.push connect.session secret: app.config.get "secret"
app.http.before.push require "./middleware/session-messages"

# If agent is authenticated via Persona but has no profile, redirect him to `/stakeholders/__new` to create one.
app.http.before.push require "./middleware/profile"
app.http.before.push require "./middleware/access-control"

# Let's start listening to requests from our stakeholders:

app.start (app.config.get "port"), ->
  $ = debug "uvaga:init"
  mongoose.connect (app.config.get "mongo:url")
  app.log.info "Uvaga! http://#{app.config.get "host"}:#{app.config.get "port"}/"
  app.log.info i18n.__ "System is up and running!"

###
[Flatiron]:         http://flatironjs.org/
[Creamer]:          https://github.com/twilson63/creamer
[Coffecup]:         https://github.com/gradus/coffeecup
[Mozilla Persona]:  http://www.mozilla.org/en-US/persona/
[Flatiron Persona]: https://github.com/lzrski/flatiron-persona
[Connect]:          http://www.senchalabs.org/connect/
###