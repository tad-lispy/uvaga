module.exports = (attributes) ->
  stakeholder = attributes?.stakeholder ? @profile

  ul class: "thumbnails stakeholder-box", -> 
    li class: "span3", ->
      div class: "thumbnail", ->
        h4 style: "text-align: center", stakeholder.name

        if stakeholder.image?
          { shape, color, background } = stakeholder.image
          avatar { stakeholder, size: 300 }
          
        p style: "text-align: center", stakeholder.occupation
        
        dl class: "dl-horizontal", ->
          if stakeholder.groups.length
            dt -> i class: "icon-sitemap", title: translate "Groups"
            for group in stakeholder.groups
              dd group              

          if stakeholder.telephone
            dt -> i class: "icon-phone-sign", title: translate "Telephone"
            dd -> a
              href: "tel:#{stakeholder.telephone}"
              stakeholder.telephone

          dt -> i class: "icon-envelope", title: translate "e-Mail address"
          dd -> 
            if @profile.email is stakeholder.email then a 
              href: "mailto:#{stakeholder.email}"
              stakeholder.email
            else a
              href: "#"
              "*.*****@****.com"

        p -> a 
          class : "btn btn-link btn-block"
          href  : "/stakeholders/" + stakeholder.slug + "/profile"
          ->
            i class: "icon-edit", " "
            text translate "edit profile" 
              
