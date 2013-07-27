# TODO: DRY - merge with stakeholder box
module.exports = (stakeholder) ->
  div class: "media well commited-box", id: "commited-stakeholder-#{stakeholder.id}", ->
    if stakeholder.image?
      a 
        class : "pull-left"
        href  : "/stakeholders/" + stakeholder.slug
        ->
          avatar { stakeholder, class: "media-object" }
    div class: "media-body", ->
      p ->
        strong -> a
          href  : "/stakeholders/" + stakeholder.slug
          title : stakeholder.name
          stakeholder.name
        do br
        small ([stakeholder.occupation].concat stakeholder.groups).join ", "
      
      dl class: "dl-horizontal", ->
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
