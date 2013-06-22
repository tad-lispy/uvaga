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
    p ->
      a
        id: "signout"
        "data-signout": true
        href: "#"
        class: "btn btn-large btn-danger"
        -> 
          i class: "icon-chevron-sign-left"
          text " Get annonymous"

    # a {
    #   id: "profile"
    #   class: "button blue"
    #   href: "/profile"
    # }, @user?.name ? "utwórz profil"
###