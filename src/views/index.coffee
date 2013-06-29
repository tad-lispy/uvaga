module.exports = ->
  $ @issues

  div class: "row", ->
    # TODO: pull and push grid elements
    div class: "span3", ->
      ul class: "thumbnails", -> 
        li class: "span3", ->
          div class: "thumbnail", ->
            img src: "http://fillmurray.com/g/200/200"
            h3 style: "font-size: 120%", ->
              a
                href: "#"
                id: "name"
                data:
                  editable: true
                  type    : "text"
                  title   : "Name"
                @profile.name
            p @profile.occupation
            table ->
              tr ->
                td "Groups"
                td ->
                  for group in @profile.groups
                    span class: "label", group + " "
              for label, field of {
                "T": "telephone"
                "@": "email"
              }
                if @profile[field]? then tr ->
                  td label
                  td @profile[field]

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

