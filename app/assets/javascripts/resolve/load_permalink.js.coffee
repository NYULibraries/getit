helpTextContent = "Cut and paste the following URL:"
$ ->
	$(".umlaut-container, header").click (event) ->
		$("#umlaut-permalink-container").hide()
	$("*[data-umlaut-toggle-permalink]").click (event) ->
		if $(".umlaut-permalink-container input").is(":visible")
			$(".umlaut-permalink-container input").select()
		permalinkLoaded = setInterval ->
			if $(".umlaut-permalink-container a").is(":visible")
				reformatPermalink(event)
				clearInterval(permalinkLoaded)
		, 0

reformatPermalink = (event) ->
	originalLink   = $(this)
	valueContainer = $("#umlaut-permalink-container")

  #loadedLink = $(".umlaut-permalink-container a")
	url = window.location.href #loadedLink.attr("href")
	input = $("<input />")
	input.attr("value", url)
	input.attr("readonly", "true")
	input.addClass("form-control")
	input.click (event) -> $(this).select()

	helpText = $("<div />").addClass("umlaut-permalink-help pull-left").html(helpTextContent)
	closeButton = $("<button />").addClass("umlaut-permalink-close pull-right btn btn-link glyphicon glyphicon-remove").html("").click (event) -> valueContainer.hide()
	valueContainer.html(helpText)
	valueContainer.append(closeButton)
	valueContainer.append(input)
	input.select()
