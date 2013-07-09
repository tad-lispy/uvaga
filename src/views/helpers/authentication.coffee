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
          i class: "icon-chevron-sign-right"
          text " Introduce yourself"

  else
    p ->
      text "You are authenticated as "
      if @profile?
        a href: "/stakeholders/#{@profile.slug}", @profile.name
      else text @username
      text ". You can always "
      a
        id: "signout"
        data:
          signout: true
        href: "#"
        "Get annonymous"
    a
      id: "start"
      href: "/"
      class: "btn btn-large btn-success"
      -> 
        i class: "icon-chevron-sign-right"
        text " Begin"
