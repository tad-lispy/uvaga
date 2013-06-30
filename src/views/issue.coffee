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

  $ "Showing"
  $ @issue
  $ "Relation"
  $ @relation

  if @issue?
    mode          = "view"
    @form_context = @issue
    form_title    = "# #{@issue.number}"
  else # We are in `/issues/__new`
    @form_context = {}
    mode          = "create"
    form_title    = "<i class='icon-asterisk'> </i>New issue"

  form
    class: "issue #{mode} form"
    method: "post"
    action: if mode is "create" then "/issues" else ""
    ->
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
              style: "resize: vertical",
              @form_context.description

        div class: "row", ->
          checkboxes =
            affected : "<i class='icon-flag'> </i>This affects me"
            concerned: "<i class='icon-warning-sign'> </i>I think it's important"
            committed : "<i class='icon-eye-open'> </i>I'll take care of that"

          for field, desc of checkboxes
            div "class: span3", ->
              label class: "checkbox", ->
                input
                  type    : "checkbox"
                  name    : field
                  checked : @relation? and field of @relation and @relation[field]
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
                for scope in @suggestions.scopes
                  option 
                    value: scope
                    selected: @form_context.scopes? and scope in @form_context.scopes
                    scope

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

  unless mode is "create" 
    form
      class: "comment form"
      method: "post"
      action: "/issues/#{@issue.number}/comments"
      ->
        fieldset ->
          legend "Comments"
          
          div class: "row", ->
            div class: "span9", ->
              label
                class: "control-label"
                for: "comment"
                "Your comment"
              textarea
                name: "comment"
                class: "span9"
                style: "resize: vertical"
      
          div class: "row", ->
            div class: "span9", style: "margin-top: 10px", ->
              button
                type  : "submit"
                class : "btn btn-comment"
                ->
                  i class: "icon-ok-sign"
                  " Say it!"
              text " "
              a
                class           : "btn"
                href            : "/"
                ->
                  i class: "icon-remove-sign"
                  " Cancel."

    for comment in @issue.comments.reverse()
      div class: "media", id: "comment-#{comment.id}", ->
        a class: "pull-left", ->
          img
            class: "media-object"
            style: "max-width: 64px; max-heigh: 64px"
            src: comment.author.image ? "//fillmurray.com/64/64"
        div class: "media-body", ->
          h4 comment.author.name
          p comment.content
