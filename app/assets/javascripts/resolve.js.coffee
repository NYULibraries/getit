#  Umlaut javascript required for proper functionality. The 'umlaut' file
#  also forces require of jquery and jquery-ui, dependencies.
# = require 'umlaut'
# = require "nyulibraries"
# = require_tree ./resolve

# Fit modal body to the screen size
window.fit_modal_body = (modal) ->
  header = $(".modal-header", modal)
  body = $(".modal-body", modal)
  footer = $(".modal-footer", modal)
  windowheight = parseInt($(window).height())
  headerheight = parseInt(header.css("height")) + parseInt(header.css("padding-top")) + parseInt(header.css("padding-bottom"))
  bodypaddings = parseInt(body.css("padding-top")) + parseInt(body.css("padding-bottom"))
  footerheight = parseInt(footer.css("height")) + parseInt(footer.css("padding-top")) + parseInt(footer.css("padding-bottom"))
  height = windowheight - headerheight - bodypaddings - footerheight - parseInt(modal.css("top")) - 40 # Top and bottom spacings
  body.css("max-height", "#{height}px")

$ ->
  # Bind resize event with the modal resize
  $(window).resize ->
    fit_modal_body($("#modal"))

  # Bind show event with the modal resize
  $(document).on 'shown', '#modal', ->
    fit_modal_body($("#modal"))
