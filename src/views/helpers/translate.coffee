translate = (content) ->
  if not @i18n? then return text content
  else return @i18n.__ content

module.exports = translate
