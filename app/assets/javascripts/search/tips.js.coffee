$ ->
  class Settings
    base_url = 'https://webapps.library.nyu.edu/common/retrieve_file_contents_as_json.php'
    @_callback: () ->
      element = $(this)
      $(this).attr content if $(this).attr("data-content")?
      $.getJSON base_url + "?the_url=" + $(this).attr("href") + "&full_html=true&callback=?", 
        (data)->
          element.attr "data-content", data.theHtml
          element.popover('show')
      "Loading..."      

    options:
      trigger: 'hover'
      delay: { show: 500, hide: 100 }
      placement: () ->
        element = arguments[1]
        if ($(element).offset().left > $(document).width() * .75) then 'left' else 'right'
      content: @_callback

    html: (html) ->
      @options.html = html
      @
    content: (content) ->
      @options.conent = content
      @

  $(".tip").popover new Settings().options
  $(".html-tip").popover new Settings().html(true).options
  $(".remote-tip").popover new Settings().html(true).options
