translate = (content) ->
  if not @i18n? then return text content
  else return @i18n.__.apply @i18n, arguments

module.exports = translate
