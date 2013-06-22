module.exports = -> 

  # No `@stakeholder` indicates that we are in `/stakeholders/__new`
  # TODO: Unite it! Anybody can edit anybody's profile, but before the changes will be saved, stakeholder must aggree for them.  

  if @stakeholder
    @form_context = @stakeholder
    if @stakeholder.email = @username
      mode = "update"
      h1 "That's your profile!"
    else
      mode = "view"
      h1 "Public profile of #{@stakeholder.name}" 
  else # We are in `/stakeholders/__new`
    @form_context = {}
    mode = "create"
    h1 "Hello! Thanks for authenticating."
    p  "Please fill your profile beolw."

  form {
    class: "profile #{mode}"
    method: "post"
    action: "/stakeholders"
    # action: if mode is "create" then "/stakeholders" else ""
  }, ->
    table ->
      tr ->
        # This is for information only. It will be filtered out in controller anyway.
        td -> label for: "email", "Your e-mail"
        td -> textbox
          name: "email"
          value: @username
          disabled: "true"
      tr ->
        td -> label for: "name", "Name"
        td -> textbox name: "name"
  
      if mode is "create"
        tr ->
          td colspan: 2, ->
            h2 ->
              text "That's all we really need to begin."
              do br
              text "Would you like to tell us more?"

      tr ->
        td -> label for: "telephone", "Telephone"
        td -> textbox name: "telephone"
      tr ->
        td -> label for: "occupation", "Occupation"
        td -> textbox name: "occupation"
      tr ->
        td -> label for: "groups", "Groups:"
        td ->
          select
            id          : "groups"
            name        : "groups"
            placeholder : "Select one or more groups  #{if mode is 'create' then 'you' else 'a stakeholder'} belong to..."
            multiple    : true
            ->
              for group in @suggestions.groups
                option 
                  value: group
                  selected: group in @form_context.groups
                  group 

        tr ->
          td colspan: 2, -> input type: "submit", value: "done!"


    