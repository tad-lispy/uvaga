module.exports = (attributes) ->
  stakeholder = attributes?.stakeholder ? @profile

  ul class: "thumbnails", -> 
    li class: "span3", ->
      div class: "thumbnail", ->
        h4 style: "text-align: center", -> 
          a href  : "/stakeholders/" + stakeholder.slug, stakeholder.name

        img 
          src: stakeholder.image ? "http://www.fillmurray.com/160/160"
          
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

        p style: "text-align: center; margin-top: 1em", -> 
          a 
            class : "btn"
            href  : "/stakeholders/" + stakeholder.slug + "/profile"
            ->
              i class: "icon-edit", " "
              text "edit profile" 
              
