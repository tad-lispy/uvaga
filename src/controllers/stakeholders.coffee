###

Stakeholders controller
=======================

This controlls /stakeholders/ urls, that are related to stakeholders (so called users), as you can guess.

###

Stakeholder = require "../models/Stakeholder"
Issue       = require "../models/Issue"
_           = require "underscore"
async       = require "async"
glob        = require "glob"
path        = require "path"
controller  = require "../access-control"
debug       = require "debug"
$           = debug "uvaga:controllers:stakeholders"

suggestions = (done) ->
  $ = debug "uvaga:controllers:stakeholders:suggestions"
  # get suggestions
  async.parallel {
    groups: (done) =>
      Stakeholder
      .find()
      .distinct "groups", (error, groups) ->
        if error then done error
        done null, groups
    
    occupations: (done) =>
      Stakeholder
      .find()
      .distinct "occupation", (error, occupations) ->
        if error then done error
        done null, occupations

    shapes: (done) =>
      pattern = path.resolve __dirname, "../../avatars/*.svg"
      $ "shapes pattern is %s", pattern
      glob pattern, (error, files) =>
        if error then throw error
        shapes = files.map (file) -> path.basename file, ".svg"
        done null, shapes

    colors: (done) =>
      done null, [
        "white"
        "red"
        "maroon"
        "pink"
        "crimson"
        "hotpink"
        "deeppink"
        "MediumVioletRed"
        "magenta"
        "DarkMagenta"
        "purple"
        "indigo"
        "DarkSlateBlue"
        "blue"
        "MidnightBlue"
        "NavyBlue"
        "RoyalBlue"
        "CornflowerBlue"
        "LightSteelBlue"
        "DarkCyan"
        "lime"
        "LimeGreen"
        "ForestGreen"
        "GreenYellow"
        "DarkOliveGreen"
        "yellow"
        "gold2"
        "goldenrod"
        "wheat"
        "orange"
        "DarkOrange"
        "OrangeRed2"
        "silver"
        "gray"
        "dimgray"
        "black"
      ]
  }, (error, suggestions) =>
    if error then throw error

    # Suggest random avatar - used only in __new
    suggestions.image =
      shape: (
        length = suggestions.shapes.length
        random = Math.floor (Math.random() * length)
        suggestions.shapes[random]
      )
      color: (
        length = suggestions.colors.length
        random = Math.floor (Math.random() * length)
        suggestions.colors[random]
      )
      background: (
        length = suggestions.colors.length
        random = Math.floor (Math.random() * length)
        suggestions.colors[random]
      )

    done null, suggestions


save = (slug) ->
  $ = debug "uvaga:controllers:stakeholders:save"
  # Used in POST of /stakeholders/ and /stakeholders/:slug
  create = not slug?

  data = _.pick @req.body, [
    "name"
    "image"
    "telephone"
    "occupation"
    "groups"
  ]
  data.image = _.pick @req.body, [
    "shape"
    "color"
    "background"
  ]

  if typeof data.groups is "string"
    data.groups = data.groups.split /; ?/
  if create 
    data.email = @req.session.username
    $ "New stakeholder's data:"
    $ data
  else
    $ "Updating stakeholder #{slug} with new data" 
    $ data

  async.waterfall [
    (done) =>
      # 1. Retrive or create new stakeholder
      if create then Stakeholder.findOne
        email: @req.session.username,
        (error, stakeholder) =>
          # Make sure agent is not trying to create new stakeholder document, while one exists already
          if stakeholder? then done new Error """ 
              This e-mail (#{stakeholder.email}) is already in use.
              You cannot create more then one profile.
              Would you rather
              <a href='/stakeholders/#{stakeholder.slug}'>
              make changes to the one you already have
              </a>?
            """
          done null, new Stakeholder data
      else Stakeholder.findOne { slug }, (error, stakeholder) ->
        if not stakeholder? then done new Error """
          No such stakeholder: #{slug}.
          Stakeholder update requested, but wrong url was used.
        """          
        for attribute, value of data
          stakeholder[attribute] = value
        done null, stakeholder

    # 2. Save stakeholder's data
    (stakeholder, done) =>
      stakeholder.save (error) => 
        # Update session data
        unless create
          if @req.session.stakeholder.slug is stakeholder.slug and not error
            @req.session.stakeholder = stakeholder
        done error
  ], (error) =>
    if error
      $ "Error saving stakeholder's document"
      $ error
      if error.name is "ValidationError"
        for field of error.errors
          @res.message "#{field} was missing.", "error"
      else
        @res.message "There was an error. Sorry !( <br />" + error.message, "error"
      # @bind stakeholder with error data
      return @res.redirect (
        if create then  "/stakeholders/__new"
        else            "/stakeholders/#{slug}"
      )

    # if everything is fine
    $ "New stakeholder document saved"
    @res.message "Thank you! You are good to go."
    return @res.redirect (
      if create then  "/"
      else            "/stakeholders/#{slug}"
    )

module.exports = 
  "/stakeholders":
    get: ->
      $ = debug "uvaga:controllers:get"
      Stakeholder.find (error, stakeholders) =>
        if error then throw error
        @bind "stakeholders", { stakeholders, title: "Stakeholders" }

    post: controller save
    
    "/__new":
      get: ->
        $ = debug "uvaga:controllers:stakeholders:new" 
        $ "Gathering suggestions"

        async.parallel {
          suggestions : suggestions
          scripts     : (done) -> done null, [
            "/assets/scripts/app/stakeholder.js"
          ]
        }, (error, data) =>
          if error then throw error
          $ "New stakeholder %j", data
          @bind "profile", data

        # Only let authenticated users in
        # if @req.session?.username? then 
        #   @bind "stakeholder"
        # else 
        #   @res.statusCode = 401
        #   @res.end "Not authenticated."

    "/:slug":
      get: controller (slug) ->
        $ = debug "uvaga:controllers:single:get"
        async.waterfall [
          (done) =>
            # get stakeholder
            Stakeholder.findOne { slug }, (error, stakeholder) =>
              if stakeholder then done error, stakeholder
              else
                @res.statusCode = 404
                @bind "not-found", "Nobody at this address."
          (stakeholder, done) =>
            # get related issues
            Issue.aggregate [
              { $unwind: "$relations" }
              { $match: 
                "relations._id": stakeholder._id
                $or: [
                  {"relations.committed": true},
                  {"relations.affected" : true},
                  {"relations.concerned": true}
                ] 
              }
              { $sort: importance: -1 }
            ], (error, related) -> done error, { stakeholder, issues: { related } }
          # TODO: try to mark them in one aggregate call
          # http://docs.mongodb.org/manual/reference/aggregation/#exp._S_cond ?
          # (data, done) =>
          #   # get common issues
          #   agent = @req.session.stakeholder
          #   rids  = _.pluck data.related, '_id'
          #   Issue.aggregate [
          #     # Only those that are related to a stakeholder from previous step
          #     { $match: _id: $in: rids }
          #     { $unwind: "$relations" }
          #     # and that are related to acting stakeholder (agent)
          #     { $match: 
          #       "relations._id": agent._id
          #       $or: [
          #         {"relations.committed": true},
          #         {"relations.affected" : true},
          #         {"relations.concerned": true}
          #       ] 
          #     }
          #     { $sort: importance: -1 }
        ], (error, data) =>
          if error then throw error
          $ "Stakeholder data: %j", data
          @bind "stakeholder", data

      "/profile":
        get: (slug) -> 
          $ = debug "uvaga:controllers:stakeholders:single:profile"
          async.parallel {
            stakeholder: (done) =>
              # Get stakeholder
              Stakeholder.findOne { slug }, (error, stakeholder) =>
                if error then done error
                if stakeholder then done null, stakeholder
                else done 404
            
            suggestions: suggestions
              
            scripts: (done) ->
              done null, [
                "/assets/scripts/app/stakeholder.js"
              ]
          }, (error, data) =>
            if error 
              if error is 404
                @res.statusCode = 404
                @bind "not-found", "Nobody at this address."
              else throw error
            $ "Profile data %j", data
            @bind "profile", data

      post: controller save
