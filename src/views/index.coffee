module.exports = ->
  $ @issues

  div class: "row", ->
    # TODO: pull and push grid elements
    div class: "span3", ->
      do stakeholderbox


    div class: "span9", ->
      a 
        class: "btn btn-primary btn-large"
        href: "/issues/__new"
        "I have an issue!"

    div class: "span9", ->
      h3 "My issues"
      $ @issues.related
      issue_list issues: @issues.related

    div class: "span9", ->
      h3 "Other issues"
      $ @issues.other
      issue_list issues: @issues.other

