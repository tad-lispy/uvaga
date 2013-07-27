module.exports = ->
  h1 class: "page-header", ->
   text "# 404 "
   small @message ? translate "not found"
  p ->
    translate "We are sorry. We can only suggest you to %s. If you think this is an error in Uvaga, please: %s",
      cede -> a href: "/", translate "go to start page"
      cede -> ul ->
        li -> a href: "/issues/__new",                  translate "write an issue about it"
        li -> a href: "mailto:wydawnictwo@lazurski.pl", translate "contact us by mail"
