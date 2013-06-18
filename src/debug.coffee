module.exports = (dump) ->
  if process.env.ENVIRONMENT is "development"
    if typeof dump is "string" then console.log dump
    else console.dir dump