###

List of issues
==============

###

module.exports = (attributes) ->
  attributes.issues ?= []
  # $ "Issues: %j", attributes.issues

  table class: "table", ->
    thead ->
      tr ->
        th style: "width: 10px", "#"
        th style: "width: 10px; text-align: center", -> i class: "icon-warning-sign"  # concerned
        th style: "width: 10px; text-align: center", -> i class: "icon-group"         # affected
        th style: "width: 10px; text-align: center", -> i class: "icon-eye-open"      # committed
        th translate "Scopes"
        th translate "Description"
    tbody ->
      # TODO: Sorting and filtering
      # http://www.datatables.net/
      # http://net.tutsplus.com/tutorials/javascript-ajax/using-jquery-to-manipulate-and-filter-data/
      for issue in attributes.issues
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
              issue.committed
          td ->
            for scope in issue.scopes
              span class: "label", scope
              text " "
          td issue.description
