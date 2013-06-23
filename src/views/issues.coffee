module.exports = ->
  table class: "table", ->
    caption "Registered stakeholders"
    thead ->
      tr ->
        th "#"
        th -> i class: "icon-important" # concerned
        th -> i class: "icon-group"     # affected
        th -> i class: "icon-eye-open"  # commited
        th "Scopes"
        th "Description"
    tbody ->
      # TODO: Sorting and filtering
      # http://www.datatables.net/
      # http://net.tutsplus.com/tutorials/javascript-ajax/using-jquery-to-manipulate-and-filter-data/
      for issue in @issues
        tr -> 
          td -> a href: "/#{issue.slug}", issue.number
          td -> 
            span
              class: "badge badge-important"
              issue.concerned.count
          td -> 
            span
              class: "badge badge-inverse"
              issue.affected.count
          td -> 
            span
              class: "badge badge-info"
              issue.commited.count
          td ->
            for scope in issue.scopes
              span class: "label", scope
              text " "
          td issue.description

        
