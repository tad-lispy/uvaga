module.exports = (dump) ->
  if process.env.NODE_ENV isnt "production"
    if typeof dump is "string" then console.log dump
    else console.dir dump