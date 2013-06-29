module.exports = (attributes) ->
  stakeholder = attributes?.stakeholder ? @profile

  ul class: "thumbnails", -> 
    li class: "span3", ->
      div class: "thumbnail", ->
        p style: "text-align: center", -> strong -> a        
          href: "#"
          id: "name"
          data:
            edit    : true
            type    : "text"
            title   : "Name"
          stakeholder.name
        img src: "http://fillmurray.com/g/200/200"
        p style: "text-align: center", stakeholder.occupation
        table ->
          tr ->
            td -> i class: "icon-sitemap"
            td ->
              for group in stakeholder.groups
                span class: "label", group + " "
          for label, field of {
            "phone-sign": "telephone"
            "envelope"  : "email"
          }
            if stakeholder[field]? then tr ->
              td -> i class: "icon-#{label}"
              td stakeholder[field]