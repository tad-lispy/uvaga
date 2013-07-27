# Issue editor view
# =================
#
# Differs a lot depending on context.
#
# It can be used to
# 1. Create a new issue in `/issues/__new`
# 2. Update an issue
#

module.exports = -> 

  # No `@issue` indicates that we are in `/issues/__new`

  # Are we in /issues/__new?
  create = not @issue?

  if create then  @form_context = {}
  else            @form_context = @issue

  div class: "page-header", ->
    h1 -> 
      if create
        i class: "icon-asterisk", " "
        text translate "New"
      else
        text "# " + @form_context.number

      text " "
      small ->
        translate "issue "
        unless create
          div class: "pull-right", ->
            # Configure counters of affected, concerned and committed stakeholders
            for counter in [
              {
                name  : "affected"
                icon  : "group"
                class : "warning"
                tip   : "number of affected stakeholders."
              }
              { 
                name  : "concerned"
                icon  : "warning-sign"
                class : "important"
                tip   : "number of stakeholders who consider this issue important."
              }
              { 
                name  : "committed"
                icon  : "eye-open"
                class : "info"
                tip   : "number of stakeholders commited to work on that."
              }
            ]
              a 
                href  : "#"
                class : "badge " + (if @relation[counter.name] then "badge-" + counter.class)
                data  :
                  toggle: "tooltip"
                  title : translate counter.tip
                ->
                  i class: "icon-#{counter.icon}", " "
                  text @form_context[counter.name]
              text " "


  div class: "row", ->
    div class: "span9", id: "form", ->
      form
        class: "issue form"
        method: "post"
        action: if create then "/issues" else "/issues/#{@issue.number}"
        ->

          div class: "row", ->
            div class: "span9", ->
              textarea
                name: "description"
                class: "span9"
                style: "resize: vertical",
                @form_context.description

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
                translate "scopes"
              select
                id          : "scopes"
                name        : "scopes"
                placeholder : translate "Select one or more scopes of this issue..."
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
                  i class: "icon-ok-sign", " "
                  translate "Done!"
              text " "
              a
                class           : "btn"
                href            : if create then "/" else "/issues/#{@issue.number}"
                ->
                  i class: "icon-remove-sign", " "
                  translate "Cancel."

      unless create
        comment_box comment for comment in @issue.comments.reverse()

    unless create
      div class: "span3", id: "aside", ->
        h4 translate "Commited stakeholders"
        commited_box stakeholder for stakeholder in @commitee when stakeholder?
        