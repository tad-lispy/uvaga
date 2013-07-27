module.exports = ->

  div class: "row", ->
    div class: "span12", ->
      h3 ->
        translate "My issues "
        a 
          class: "btn btn-primary"
          href: "/issues/__new"
          ->
            i class: "icon-plus-sign", " "
            translate "Add an issue"

      # $ "%j", @issues.related
      issue_list issues: @issues.related

    div class: "span12", ->
      h3 translate "Other issues"
      # $ "%j", @issues.other
      issue_list issues: @issues.other

