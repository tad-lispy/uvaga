markdown = (md) ->
  if not @marked then text md
  else return text @marked md

module.exports = markdown