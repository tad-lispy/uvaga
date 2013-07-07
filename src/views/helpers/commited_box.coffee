module.exports = (stakeholder) ->
  div class: "media well", id: "commited-stakeholder-#{stakeholder.id}", ->
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
      p ->
        for label, field of {
          "phone-sign": "telephone"
          "envelope"  : "email"
        }
          if stakeholder[field]? 
            small ->
              i class: "icon-#{label}", " "
              text stakeholder[field]
            do br