flatiron = require 'flatiron'
path     = require 'path'
app      = flatiron.app;

app.config.file file: path.join __dirname, 'config', 'config.json'

app.use(flatiron.plugins.http);

app.router.get '/', () ->
  @res.json 'hello': 'world'

app.start 4000;
