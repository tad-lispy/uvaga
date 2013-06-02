module.exports = ->
  h1 "Participants are here!"
  ul ->
    for participant in @participants
      li class: "participant", ->
        a href: "/participants/#{participant.slug}", participant.name
        if participant.email is @username then text " (that's you!)"
