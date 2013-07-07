###

Bootstrap navbar
================

Navigation menu items
---------------------

###




module.exports = (navigation) ->
  navigation ?= [
    { title: "Start", href: "/" }
    { title: "Stakeholders", href: "/stakeholders" }
    { title: "Issues", href: "/issues" }
  ]

  div class: "navbar navbar-inverse navbar-fixed-top", ->
    div class: "navbar-inner", ->
      div class: "container", ->
        button
          type  : "button"
          class : "btn btn-navbar"
          data  : 
            toggle: "collapse"
            target: ".nav-collapse"
          ->
            span class: "icon-bar"
            span class: "icon-bar"
            span class: "icon-bar"
            
        a href: "/", class: "brand", ->
          strong "Uvaga ! "
          small class: "title", @title

        div class: "nav-collapse collapse", ->
          ul class: "nav", ->
            for item in navigation
              li -> a item, item.title

          if @profile? 
            ul class: "nav pull-right", ->
              { shape, color, background } = @profile.image
              li -> a
                title : @profile.name
                href: "/stakeholders/#{@profile.slug}"
                ->
                  img 
                    width : 24
                    height: 24
                    src   : "/avatars/#{shape}/#{color}/#{background}/24"
                    title : @profile.name
                    alt   : "Avatar of #{@profile.name} in Uvaga"
                  strong style: "margin-left: 10px", @profile.name
              li -> a
                title: "Log out"
                href: "#"
                data:
                  signout: true 
                ->
                  i class: "icon-off"
                
