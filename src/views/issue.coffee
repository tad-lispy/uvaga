# Issue view
# ==========
#
# Displays a single issue, relation form, comment form and comments
#

module.exports = -> 

  div class: "page-header", ->
    h1 -> 
      text "# #{@issue.number} "
      small ->
        translate "issue"
        div class: "pull-right", ->
          # Configure counters of affected, concerned and committed stakeholders
          for counter in [
            {
              name  : "affected"
              icon  : "group"
              class : "warning"
              tip   : translate "number of affected stakeholders."
            }
            { 
              name  : "concerned"
              icon  : "warning-sign"
              class : "important"
              tip   : translate "number of stakeholders who consider this issue important."
            }
            { 
              name  : "committed"
              icon  : "eye-open"
              class : "info"
              tip   : translate "number of stakeholders commited to work on that."
            }
          ]
            a 
              href  : "#"
              class : "badge " + (if @relation[counter.name] then "badge-" + counter.class)
              data  :
                toggle: "tooltip"
                title : counter.tip
              ->
                i class: "icon-#{counter.icon}", " "
                text @issue[counter.name]
            text " "

  div class: "row", ->
    div class: "span9 main", ->
      div class: "row", ->
        div class: "span9", id: "description", ->

          div class: "hero-unit", ->
            # TODO: move to controller .replace "\n\n", "<p>" .replace "\n", "<br />"
            text @issue.description
            ul class: "inline", -> for scope in @issue.scopes
              li -> a class: "label", href: "#", scope
            a 
              class: "btn btn-link btn-large pull-right"
              href: "/issues/#{@issue.number}/edit"
              ->
                i class : "icon-edit"
                translate "Edit this issue"



      div class: "row", ->
        form
          class : "relation form"
          method: "post"
          action: "/issues/#{@issue.number}/relation"
          ->
            for field, icon of {
              affected  : cede ->
                i class: 'icon-user', " "
                translate "This affects me"
              concerned :  cede -> 
                i class: 'icon-warning-sign', " "
                translate "I think it's important"
              committed : cede -> 
                i class: 'icon-eye-open', " "
                translate "I'll take care of that"
            }
              div class: "span3 relation #{field}", ->
                label class: "checkbox", ->
                  input
                    type    : "checkbox"
                    name    : field
                    checked : @relation? and field of @relation and @relation[field]
                  text icon
        
      form
        class: "comment form"
        method: "post"
        action: "/issues/#{@issue.number}/comments"
        ->
          fieldset ->
            legend translate "Comments"

            div class: "row", ->

              # TODO: stakeholders image on wide screens
              div class: "span9", ->

                label
                  class: "control-label"
                  for: "comment"
                  translate "Your comment"
                textarea
                  name: "comment"
                  class: "span9"
                  style: "resize: vertical"
          
            div class: "row", ->
              div class: "span9", style: "margin-top: 10px", ->
                button
                  type  : "submit"
                  class : "btn btn-primary"
                  ->
                    i class: "icon-comment", " "
                    translate "Say it!"
                a
                  class : "btn btn-link"
                  href  : "#"
                  ->
                    i class: "icon-remove", " "
                    translate "Cancel"

            comment_box comment for comment in @issue.comments.reverse()
              
              

    div class: "span3", id: "aside", ->
      h4 translate "Commited stakeholders"
      # TODO: Author can be null, if corresponding stakeholder document was removed from db. Take care of that in model or controller
      # TODO: helper
      commited_box stakeholder for stakeholder in @commitee when stakeholder?
        
