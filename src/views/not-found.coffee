module.exports = ->
  h1 class: "page-header", ->
   text "# 404 "
   small "not found"
  p @message ? "There is nothing to see here."
  p ->
    text "We are sorry. We can only suggest you to "
    a href: "/", "go to startpage"
    text "."
    text "Or if you think this is an error in Uvaga, please"
  ul ->
    li -> a href: "/issues/__new", "write an issue about it"
    li -> a href: "mailto:wydawnictwo@lazurski.pl", "contact us by mail"
