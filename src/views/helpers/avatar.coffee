module.exports = (properties) ->
  size        = properties.size        ? 48
  stakeholder = properties.stakeholder ? @profile

  stakeholder.image ?=
    # Can't happen in theory
    shape     : "deer"
    color     : "black"
    background: "black"

  { shape, color, background } = stakeholder.image
  img 
    class : properties.class
    width : size
    height: size
    src   : "/avatars/#{shape}/#{color}/#{background}/#{size}"
    title : stakeholder.name
    alt   : translate "Avatar %s - an Uvaga stakeholder", stakeholder.name