module.exports = ->
  issue_list issues: @issues

  a class: "btn btn-primary", href: "/issues/__new", ->
    i class: "icon-plus-sign", " "
    translate "New issue"
        
