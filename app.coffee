flatiron = require 'flatiron'
creamer  = require 'creamer'

app      = flatiron.app;

app.config.file file: __dirname + '/config/config.json'

app.use flatiron.plugins.http
app.use creamer,
  layout:       require "./views/layout"
  views:        __dirname + '/views'
  controllers:  __dirname + '/controllers'


app.router.get '/', () ->
  @bind "index"

app.start 4000;
