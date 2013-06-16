module.exports = (attributes) ->
  attributes     ?= {}
  unless @username
    p -> 
      text "You are annonymous to us. You may "
      a {
        id: "signin"
        "data-signin": true
        href: "#"
        class: "persona-button dark"
      }, ->  span "introduce yourself"
      text " at any time."
  else
    p ->
      text "We know who you are. You are "
      if @profile?
        a href: "/stakeholders/#{@profile.slug}", @profile.name
      else text @username
      text "! Would you rather "
      a {
        id: "signout"
        "data-signout": true
        href: "#"
        class: "persona-button blue"
      }, ->  span "stay annonymous"
      text "?"
    # a {
    #   id: "profile"
    #   class: "button blue"
    #   href: "/profile"
    # }, @user?.name ? "utwórz profil"
###