###

List of issues
==============

###

module.exports = (attributes) ->
  attributes.issues ?= []
  $ "Issue list helper"
  $ attributes.issues

  table class: "table", ->
    thead ->
      tr ->
        th "#"
        th -> i class: "icon-warning-sign"  # concerned
        th -> i class: "icon-group"         # affected
        th -> i class: "icon-eye-open"      # committed
        th "Scopes"
        th "Description"
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
