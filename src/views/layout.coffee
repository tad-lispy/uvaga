module.exports = ->
  ###
    `session.username` is set only if participant is authenticated via Persona. Then it contains a string with users e-mail.

    `session.profile` is set only if participant is authenticated and has a profile. Then it's an object with email (same as username), name (public name) and slug (public identifier used in urls)
  ###
  if @session?.username?  then @username  = @session.username
  if @session?.profile?   then @profile   = @session.profile
  doctype 5
  html ->
    head ->
      title "Catch-22"
      meta charset: "utf-8"
      meta "http-equiv": "X-UA-Compatible", content: "IE=Edge"

      script src: "https://login.persona.org/include.js"

      script src: "http://code.jquery.com/jquery-1.9.1.min.js"
      script src: "http://code.jquery.com/jquery-migrate-1.1.1.min.js"
      script src: "http://code.jquery.com/ui/1.10.3/jquery-ui.js"
      link  href: "http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css", rel: "stylesheet", type: "text/css"

    body "data-username": @username, ->
      header ->
        h1 "Catch-22"
        h2 "An online gallery of vicious circles"
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
              a href: "/participants/#{@profile.slug}", @profile.name
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

      section id: "main", ->
        do content

      footer ->
        p "A footy footer is here"

      coffeescript ->
        ($ document).ready ->
          username = ($ "body").data "username" ? null
          if username then console.log "Logged in as #{username}"
          else console.log "Not logged in (yet?)"

          navigator.id.watch {
            loggedInUser: username
            onlogin     : (assertion) ->
              console.log "Logging in..."
              $.ajax {
                type  : "POST"
                url   : "/auth/login"
                data  : 
                  assertion : assertion
                success : -> do window.location.reload
                error   : (xhr, status, error) -> 
                  console.dir xhr
                  do navigator.id.logout
              }
            onlogout    : ->
              console.log "Logging out..."
              $.ajax {
                type  : "POST"
                url   : "/auth/logout"
                success : -> do window.location.reload
                error   : (xhr, status, error) -> console.error "Logout failed: #{error}"
              }
          }

          ($ "a[data-signin]").click  -> do navigator.id.request
          ($ "a[data-signout]").click -> do navigator.id.logout

