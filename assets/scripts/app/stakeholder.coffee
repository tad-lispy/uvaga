jQuery ($) ->
  ($ "#groups").selectize
    delimiter: ";"
    create: (input) -> text: input, value: input

  # Supercool syndiacte inspired logo generator
  ($ "select#shape, select#color, select#background").each (i, select) ->
    $select = $(select).hide().change ->
      # On value change get new image
      # TODO: omg Angular!
      src = "/avatars/" +
        $("#shape").val() +
        "/" + $("#color").val() +
        "/" + $("#background").val() +
        "/" + $("#avatar").width()
      ($ "#avatar").attr "src", src
    
    $select.before $("""
      <a class='btn next'>
        <i class='icon-chevron-left'> </i>
      </a>
    """).click ->
      next = $select.find("option:selected").next()
      if not next.length then next = $select.find("option:eq(0)")
      next.prop "selected", true
      do $select.change
    
    $select.after $("""
      <a class='btn prev'>
        <i class='icon-chevron-right'> </i>
      </a>
    """).click ->
      next = $select.find("option:selected").prev()
      if not next.length then next = $select.find("option:eq(-1)")
      next.prop "selected", true
      do $select.change

    do $select.change    


