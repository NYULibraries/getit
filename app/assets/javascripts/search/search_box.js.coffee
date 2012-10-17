# After the DOM is ready, process the search box
$ ->
  # Handle default text in search boxes
  # On focus remove default text
  $(".defaultText").live "focus", (event) ->  
        if $(this).val() == $(this).attr("title")
          $(this).removeClass("defaultTextActive")
          $(this).val("")
    # On blur add default text if it's empty
  $(".defaultText").live "blur", (event) ->
        if $(this).val() == ""
          $(this).addClass("defaultTextActive")
          $(this).val($(this).attr("title"))
    # Handle search for default text
  $("form").live "submit", (event) ->
        if $(this).find(".defaultText").length == 1 and $(this).find(".defaultText").val() == $(this).find(".defaultText").attr("title")
          event.preventDefault()
    # Initialize default text
    $(".defaultText").blur()
    # Initialize toggle actions
    $(".toggle_options").live "click", (event) ->
       event.preventDefault()
       $(".toggle_options").toggle()
       $("#search_advanced").toggle()
  $("#core_submit").append $('<a style="display: none;" class="toggle_options less_options" href="#">Fewer search options</a>')
  $("#core_submit").append $('<a style="display: none;" class="toggle_options more_options" href="#">More search options</a>')
  $(".less_options").show()
  