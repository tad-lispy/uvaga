module.exports = ->
  $ "stakeholder view"

  div class: "row", ->
    # TODO: pull and push grid elements
    div class: "span3", ->
      $ "stakeholder"
      stakeholder_box stakeholder: @stakeholder

    div class: "span9", ->
      $ "related issues"
      $ @issues
      h3 "Issues related to #{@stakeholder.name}"
      $ @issues.related
      issue_list issues: @issues.related

