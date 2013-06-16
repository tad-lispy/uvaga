module.exports = ->
  h1 "Stakeholders are here!"
  ul ->
    for stakeholder in @stakeholders
      li class: "stakeholder", ->
        a href: "/stakeholders/#{stakeholder.slug}", stakeholder.name
        if stakeholder.email is @username then text " (that's you!)"
