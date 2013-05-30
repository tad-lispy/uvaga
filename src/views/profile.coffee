module.exports = ->
  h1 "Your profile, #{@username}"
  if @participant?.slug then p "Slug is #{@participant.slug}"
  else 
    p "You need to create one before you can interact with others. Here's your chance :)"
    p ->
      text "You don't want to? No problem here. Just "
      a "data-signout": true, href: "#", "logout"
      text " and we'll be fine with you."

  form method: "post", action: "/participants", ->
    label for: "name", "Participant name (public)"
    console.dir @participant
    input type: "text", name: "name"
    input type: "submit", value: "save"