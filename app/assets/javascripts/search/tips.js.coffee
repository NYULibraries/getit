$ ->
  class Tooltip
    # Basic tooltip/popover options
    options:
      html: true
      trigger: 'hover'
      delay: { show: 500, hide: 100 }
      placement: () ->
        element = arguments[1]
        if ($(element).offset().left > $(document).width() * .75) then 'left' else 'right'

    # HTML option setter, allows chaining
    html: (html) ->
      @options.html = html
      @

    # Trigger option setter, allows chaining
    trigger: (trigger) ->
      @options.trigger = trigger
      @

    # Class option setter, allows chaining
    klass: (klass) ->
      @options.klass = klass
      @

  class Popover extends Tooltip
    @_JSON_URL = 'https://webapps.library.nyu.edu/common/retrieve_file_contents_as_json.php'
    # Callback method for content, returns a function
    @_CONTENT_CALLBACK: (self) ->
      ()->
        element = $(this)
        console.log element
        return element.attr "data-content" if element.attr("data-content")?
        $.getJSON Popover._JSON_URL + "?the_url=" + element.attr("href") + "&full_html=true&callback=?", 
          (data)->
            element.attr "data-content", self.wrap_html(data.theHtml, element.attr("data-class"))
            element.popover('show')
        "Loading..."

    # Content options setter, allows chaining
    content: (content) ->
      @options.content = content
      @

    # Contructor (obviously)
    constructor: () ->
      this.content(Popover._CONTENT_CALLBACK(@))

    # Crappy hack to append an extra class
    wrap_html: (html, klass) ->
      if klass? then $("<p>").append($("<div>").addClass(klass).append(html)).html() else html

  # Tabs Tips
  $(".nav-tabs li a").popover new Popover().options
  # All Tips
  $('[class*="tip"]').popover new Popover().options
