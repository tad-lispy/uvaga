# Shortcuts
module.exports = ->
  if @session?.username?  then @username = @session.username
  if @session?.user?      then @user = @session.user
  doctype 5
  html ->
    head ->
      title "Catch-22"
      meta charset: "utf-8"
      meta "http-equiv": "X-UA-Compatible", content: "IE=Edge"

      script src: "https://login.persona.org/include.js"

      script src: "http://code.jquery.com/jquery-1.9.1.min.js"
      script src: "http://code.jquery.com/jquery-migrate-1.1.1.min.js"

    body "data-username": @username, ->
      header ->
        h1 "Catch-22"
        h2 "An online gallery of vicious circles"
        unless @username
          a {
            id: "signin"
            href: "#"
            class: "persona-button dark"
          }, ->  span "Logowanie"
        else
          a {
            id: "signout"
            href: "#"
            class: "persona-button blue"
          }, ->  span "Wyloguj #{@username}"
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

          ($ "#signin").click  -> do navigator.id.request
          ($ "#signout").click -> do navigator.id.logout

