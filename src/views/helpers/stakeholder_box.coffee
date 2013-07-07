module.exports = (attributes) ->
  stakeholder = attributes?.stakeholder ? @profile

  ul class: "thumbnails", -> 
    li class: "span3", ->
      div class: "thumbnail", ->
        h4 style: "text-align: center", stakeholder.name

        if stakeholder.image?
          { shape, color, background } = stakeholder.image
          img 
            width : 300
            height: 300
            src   : "/avatars/#{shape}/#{color}/#{background}/300"
            title : stakeholder.name
            alt   : "Avatar of #{stakeholder.name} in Uvaga"
          
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

        a 
          class : "btn btn-link btn-block"
          href  : "/stakeholders/" + stakeholder.slug + "/profile"
          ->
            i class: "icon-edit", " "
            text "edit profile" 
              
