module.exports = ->
  # No `@participant` indicates that we are in `/participants?new`
  if not @participant?
    p "Hello! Thanks for authenticating."
    p "Before we let you play with us, we really need to know one thing."
    form class: "profile create", method: "post", action: "/participants", ->
      label for: "name", "How shall we address you in public?"
      input type: "text", name: "name"
      input type: "submit", value: "save"

  else
    h1 "Public profile of #{@participant.name}"
    # if @username is @participant.email then participant is viewing his own profile and should be able to change it
    if @username is @participant.email
      form class: "profile update", method: "post", action: "/participants", ->
        label for: "name", "How shall we address you in public?"
        input type: "text", name: "name", value: @profile.name
        input type: "submit", value: "save"

