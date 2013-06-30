module.exports = (attributes) ->
  attributes ?= {}
  if typeof attributes isnt "object" then attributes = email: attributes
  
  attributes.email ?= @profile?.email
  attributes.size  ?= 160

  img src: "//gravatar.com/avatar/#{md5(attributes.email)}?s=#{attributes.size}"
