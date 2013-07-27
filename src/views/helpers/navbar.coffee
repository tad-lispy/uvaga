###

Bootstrap navbar
================

Navigation menu items
---------------------

###




module.exports = (navigation) ->
  navigation ?= [
    { title: (translate "Start"),         href: "/" }
    { title: (translate "Stakeholders"),  href: "/stakeholders" }
    { title: (translate "Issues"),        href: "/issues" }
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
                  avatar size: 24
                  strong style: "margin-left: 10px", @profile.name
              li -> a
                title: translate "Log out"
                href: "#"
                data:
                  signout: true 
                ->
                  i class: "icon-off"
                
