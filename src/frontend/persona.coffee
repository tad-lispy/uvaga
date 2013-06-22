jQuery ($) ->
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
