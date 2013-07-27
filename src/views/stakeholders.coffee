module.exports = ->
  table class: "table table-hover", ->
    caption translate "Registered stakeholders"
    thead ->
      tr ->
        th translate "Name"
        th translate "Occupation"
        th translate "Groups"
    tbody ->
      # TODO: Sorting and filtering
      # http://www.datatables.net/
      # http://net.tutsplus.com/tutorials/javascript-ajax/using-jquery-to-manipulate-and-filter-data/
      for stakeholder in @stakeholders
        tr class: ("info" if stakeholder.email is @username), -> 
          td -> 
            a href: "/stakeholders/#{stakeholder.slug}", ->
              avatar {stakeholder, size: 24}
              strong " " + stakeholder.name
            
          td stakeholder.occupation
          td ->
            for group in stakeholder.groups
              span class: "label", group
              text " "

        
