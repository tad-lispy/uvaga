# Issue view
# ================
#
# Differs a lot depending on context.
#
# It can be used to
# 1. Create a new issue in `/issues/__new`
# 2. View / Update an issue
#
# TODO: make this form a helper and control it with attributes.
# 

module.exports = -> 

  # No `@issue` indicates that we are in `/issues/__new`
  # TODO: Unite it!

  if @issue
    mode          = "view"
    @form_context = @issue
    form_title    = "# #{@issue.number}"
  else # We are in `/issues/__new`
    @form_context = {}
    mode          = "create"
    form_title    = "<i class='icon-asterisk'> </i>New issue"

  form {
    class: "issue #{mode} form"
    method: "post"
    action: if mode is "create" then "/issues" else ""
  }, ->
    fieldset ->
      legend form_title
      
      div class: "row", ->
        div class: "span9", ->
          label
            class: "control-label"
            for: "description"
            "Description"
          textarea
            name: "description"
            class: "span9"
            style: "resize: vertical"

      div class: "row", ->
        checkboxes =
          affects : "<i class='icon-flag'> </i>This affects me"
          concerns: "<i class='icon-warning-sign'> </i>I think it's important"
          commit  : "<i class='icon-eye-open'> </i>I'll take care of that"

        for field, desc of checkboxes
          div "class: span3", ->
            label class: "checkbox", ->
              input
                type: "checkbox"
                name: field
              text desc

      ###
      Scopes
      
      What is the scope of this issue? E.g. 
          * Whole organisation
          * A place
          * A process
          * A group of people

      Use it like tags.
      ###
      div class: "row", ->
        div class: "span9", ->
          label
            class: "control-label"
            for: "groups"
            "scopes"
          select
            id          : "scopes"
            name        : "scopes"
            placeholder : "Select one or more scopes of this issue..."
            multiple    : true
            class       : "span9"
            ->
              for group in @suggestions.scopes
                option 
                  value: group
                  selected: @form_context.groups? and group in @form_context.groups
                  group 

      div class: "row", ->
        div class: "span9", style: "margin-top: 10px", ->
          button
            type  : "submit"
            class : "btn btn-success"
            ->
              i class: "icon-ok-sign"
              " Done!"
          text " "
          a
            class           : "btn"
            href            : "/"
            ->
              i class: "icon-remove-sign"
              " Cancel."
