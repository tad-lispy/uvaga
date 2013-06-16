module.exports = -> 
  # No `@stakeholder` indicates that we are in `/stakeholders/__new`
  # TODO: Unite it! Anybody can edit anybody's profile, but before the changes will be saved, stakeholder must aggree for them.  
  
  if not @stakeholder?
    p "Hello! Thanks for authenticating."
    form class: "profile create", method: "post", action: "/stakeholders", ->
      table ->
        tr ->
          td -> label for: "email", "Your e-mail"
          td -> textbox
            name: "email"
            value: @username
            disabled: "true"
        tr ->
          td -> label for: "name", "Your name"
          td -> textbox name: "name"
    
        tr ->
          td colspan: 2, ->
            h2 ->
              text "That's all we really need to begin."
              do br
              text "Would you like to tell us more?"

        tr ->
          td -> label for: "telephone", "Your telephone"
          td -> textbox name: "telephone"
        tr ->
          td -> label for: "occupation", "Your occupation"
          td -> textbox name: "occupation"
        tr ->
          td -> label for: "groups", "Your occupation"
          td -> textbox name: "groups"

        tr ->
          td colspan: 2, -> input type: "submit", value: "done!"

  else
    h1 "Public profile of #{@stakeholder.name}"
    # if @username is @stakeholder.email then stakeholder is viewing his own profile and should be able to change it
    if @username is @stakeholder.email
      form class: "profile update", method: "post", action: "/stakeholders", ->
        label for: "name", "How shall we address you in public?"
        input type: "text", name: "name", value: @profile.name
        input type: "submit", value: "save"

    h2 "I sometimes get cought, when..."
    ol id: "catches", ->
      for the_catch in @stakeholder.catches
        li class: "catch", ->
          a href: "/catches/#{the_catch.slug}", the_catch.steps[0]
