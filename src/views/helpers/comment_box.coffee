module.exports = (comment) ->
  div class: "media well commited", id: "comment-#{comment.id}", ->

    a 
      class : "pull-left"
      href  : "/stakeholders/#{comment.author.slug}"
      -> 
        avatar 
          stakeholder: comment.author
          class: "media-object"

    div class: "media-body", ->
      p comment.content
      a
        class: "btn btn-link"
        href  : "/stakeholders/#{comment.author.slug}"
        comment.author.name
      small class: "muted", " " + comment._id.getTimestamp().toLocaleDateString()
      