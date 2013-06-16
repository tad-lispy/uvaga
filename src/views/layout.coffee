module.exports = ->

  ###
  `session.username` is set only if agent is authenticated via Persona. Then it contains a string with users e-mail.

  `session.profile` is set only if agent is authenticated and has a profile (stakeholder document). Then it's an object with profile data, i.e. at least
  
      * email (same as username),
      * name (public name),
      * and slug (public identifier used in urls).
  
  There may be other data.
  ###
  if @session?.username?  then @username  = @session.username
  if @session?.profile?   then @profile   = @session.profile
  if not @title?          then @title = "Synergy stimulant for the masses."
  ###
  The rest is [html as coffescript](https://github.com/gradus/coffeecup#coffeecup-).
  ###
  doctype 5
  html ->
    head ->
      title "Uvaga ! " + @title or "Hello."
      meta charset: "utf-8"
      meta "http-equiv": "X-UA-Compatible", content: "IE=Edge"

      script src: "https://login.persona.org/include.js"

      script src: "http://code.jquery.com/jquery-1.9.1.min.js"
      script src: "http://code.jquery.com/jquery-migrate-1.1.1.min.js"
      # script src: "http://code.jquery.com/ui/1.10.3/jquery-ui.js"
      # link  href: "http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css", rel: "stylesheet", type: "text/css"

      script src: "/assets/scripts/vendor/selectize/selectize.js"
      link {
        rel: "stylesheet",
        type: "text/css",
        href: "/assets/scripts/vendor/selectize/selectize.css"
      }
      style """
        .selectize-control {
          width: 100%;
        }
      """

    body "data-username": @username, ->
      header ->
        h1 "Uvaga!"
        h2 @title

      div class: "authentication", do authentication

      section id: "main", ->
        do content

      footer ->
        p "A footy footer is here"

      script src: "/assets/scripts/app/persona.js"

