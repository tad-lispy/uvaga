module.exports = ->
  table class: "table", ->
    thead ->
      tr ->
        th "#"
        th -> i class: "icon-warning-sign"  # concerned
        th -> i class: "icon-group"         # affected
        th -> i class: "icon-eye-open"      # commited
        th "Scopes"
        th "Description"
    tbody ->
      # TODO: Sorting and filtering
      # http://www.datatables.net/
      # http://net.tutsplus.com/tutorials/javascript-ajax/using-jquery-to-manipulate-and-filter-data/
      for issue in @issues
        tr -> 
          td -> a href: "/#{issue.number}", issue.number
          td -> 
            span
              class: "badge badge-important"
              issue.concerned
          td -> 
            span
              class: "badge badge-inverse"
              issue.affected
          td -> 
            span
              class: "badge badge-info"
              issue.commited
          td ->
            for scope in issue.scopes
              span class: "label", scope
              text " "
          td issue.description

    caption "Registered stakeholders"

  a class: "btn btn-primary", href: "/issues/__new", ->
    i class: "icon-plus-sign", " "
    text "New issue"

        
