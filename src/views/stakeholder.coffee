# Stakeholder view
# ================
#
# Differs a lot depending on context.
#
# It can be used to
# 1. Create a new profile in `/stakeholders/__new`
# 2. Update own profile
# 3. View / update someone elses profile
#
# TODO: make this form a helper and control it with attributes.
# 

module.exports = -> 

  # No `@stakeholder` indicates that we are in `/stakeholders/__new`
  # TODO: Unite it! Anybody can edit anybody's profile, but before the changes will be saved, stakeholder must aggree for them.  

  if @stakeholder
    @form_context = @stakeholder
    if @stakeholder.email is @username
      mode        = "update"
      form_title  = "Your profile"
    else
      mode        = "view"
      form_title  = "Profile of #{@stakeholder.name}" 
  else # We are in `/stakeholders/__new`
    @form_context = { email: @username }
    mode          = "create"
    form_title    = "Your profile"
    div class: "hero-unit", ->
      h1 "Hello! Thanks for authenticating."
      p  "It seems to be your first time here. Please fill your profile beolw. We need at least your name, so that we know how to address you :)"

  form {
    class: "profile #{mode} form-horizontal"
    method: "post"
    action: if mode is "create" then "/stakeholders" else ""
  }, ->
    fieldset ->
      legend form_title
      
      # ## Mandatory info
      #
      # * E-mail address
      # This is for information only.
      # It will be filtered out in controller anyway. (?)
      # 
      div class: "control-group", ->

        label
          class: "control-label"
          for: "email"
          "E-mail"
        div class: "controls", ->
          textbox
            name: "email"
            disabled: true
            class: "span3"

      # * Name
      # The only thing we really need to begin
      # 
      div class: "control-group", ->
        label
          class: "control-label"
          for: "name"
          "Name"
        div class: "controls", ->
          textbox
            name      : "name"
            class     : "span3"
            required  : true
            autofocus : true

      # ## Optional info
      #
      if mode is "create"
        div class: "controls", ->
          p class: "help-block", ->
            strong "That's all we really need to begin."
            do br
            text " Would you like to tell us more?"

      # * Telephone
      #
      div class: "control-group", ->
        label
          class: "control-label"
          for: "telephone"
          "Telephone"
        div class: "controls", ->
          textbox
            name: "telephone"
            class: "span3"

      # * Occupation
      #
      div class: "control-group", ->
        label
          class: "control-label"
          for: "occupation"
          "Occupation"
        div class: "controls", ->
          textbox
            name: "occupation"
            class: "span3"

      # * Groups
      # Organisations, companies, institutions, departments etc.
      #
      div class: "control-group", ->
        label
          class: "control-label"
          for: "groups"
          "Groups"
        div class: "controls", ->
          select
            id          : "groups"
            name        : "groups"
            placeholder : "Select one or more groups..."
            multiple    : true
            class       : "span3"
            ->
              for group in @suggestions.groups
                option 
                  value: group
                  selected: @form_context.groups? and group in @form_context.groups
                  group 

      div class: "control-group", ->
        div class: "controls", ->
          button
            type  : "submit"
            class : "btn btn-success"
            ->
              i class: "icon-ok-sign"
              " Done!"
          if mode is "create" then a
            class           : "btn"
            "data-signout"  : true
            ->
              i class: "icon-remove-sign"
              " No thanks."


    