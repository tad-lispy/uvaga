module.exports = ->
  p -> translate "%s is an %s software by %s. %s!",
    cede -> strong "Uvaga!"
    cede -> a href: "/licence", translate "an open source"
    cede -> a href: "http://lazurski.pl/", "Tadeusz Łazurski"
    cede -> a href: "http://github.com/lzrski/uvaga/", translate "Fork me at GitHub"