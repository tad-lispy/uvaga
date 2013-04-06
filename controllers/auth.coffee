request = require "request"

module.exports =
  "/auth":
    "/login":
      post: ->
        @res.end "Authenticating..."
    "/logout":
      post: ->
        @res.end "Bye bye!"