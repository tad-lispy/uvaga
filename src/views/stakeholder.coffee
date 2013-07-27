module.exports = ->
  div class: "row", ->
    # TODO: pull and push grid elements
    div class: "span3", ->
      # $ "Stakeholder: %j", @stakeholder
      stakeholder_box stakeholder: @stakeholder

    div class: "span9", ->
      # $ "Related issues: %j", @issues
      h3 translate "Issues related to %s", @stakeholder.name
      issue_list issues: @issues.related

