# After the DOM is ready, process the search box
# $ ->
#   # Initialize toggle actions
#   $(".toggle_options").live "click", (event) ->
#      event.preventDefault()
#      $(".toggle_options").toggle()
#      $("#search_advanced").toggle()
#   $("#core_submit").append $('<a style="display: none;" class="toggle_options less_options" href="#">Fewer search options</a>')
#   $("#core_submit").append $('<a style="display: none;" class="toggle_options more_options" href="#">More search options</a>')
#   $(".less_options").show()
#   