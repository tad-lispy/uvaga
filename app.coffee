flatiron = require 'flatiron'
creamer  = require 'creamer'
persona  = require 'flatiron-persona'
connect  = require "connect"
app      = flatiron.app;

app.config.file file: __dirname + '/config/config.json'

app.use flatiron.plugins.http
app.use persona, audience: "http://localhost:4000/"
app.use creamer,
  layout:       require "./views/layout"
  views:        __dirname + '/views'
  controllers:  __dirname + '/controllers'

app.http.before.push do connect.cookieParser
app.http.before.push connect.session secret: "Kiedy nikogo nie ma w domu, Katiusza maluje pazury na zielono i głośno się śmieje swoim kocim głosem. To prawda!"

app.router.get '/', () ->
  @bind "index"

app.start 4000;
