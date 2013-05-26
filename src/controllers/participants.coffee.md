    module.exports = 
      "/participants/":
        get: ->
          if @req.query.new? then @bind "profile"
          else @bind "participants"