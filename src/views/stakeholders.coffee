module.exports = ->
  table class: "table", ->
    caption "Registered stakeholders"
    thead ->
      tr ->
        th "Name"
        th "Occupation"
        th "Groups"
    tbody ->
      # TODO: Sorting and filtering
      # http://www.datatables.net/
      # http://net.tutsplus.com/tutorials/javascript-ajax/using-jquery-to-manipulate-and-filter-data/
      for stakeholder in @stakeholders
        tr -> 
          td -> 
            a href: "/stakeholders/#{stakeholder.slug}", ->
              avatar {stakeholder, size: 24}
              strong " " + stakeholder.name
            if stakeholder.email is @username then text " (that's you!)"
          td stakeholder.occupation
          td ->
            for group in stakeholder.groups
              span class: "label", group
              text " "

        
