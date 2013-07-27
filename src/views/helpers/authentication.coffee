module.exports = (attributes) ->
  attributes     ?= {} # Obsolate?
  unless @username
    p -> 
      a
        id: "signin"
        "data-signin": true
        href: "#"
        class: "btn btn-large btn-primary"
        ->
          i class: "icon-chevron-sign-right", " "
          translate "Introduce yourself"

  else
    p ->
      translate "You are authenticated as %s. You can always %s.",
        cede =>
          if @profile? then a
            href: "/stakeholders/#{@profile.slug}",
            @profile.name
          else text @username

        cede => a
          id: "signout"
          data:
            signout: true
          href: "#"
          translate "Get annonymous"
    a
      id: "start"
      href: "/"
      class: "btn btn-large btn-success"
      -> 
        i class: "icon-chevron-sign-right", " "
        translate "Begin"
