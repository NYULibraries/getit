$ ->
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

	loadedLink = $(".umlaut-permalink-container a")
	url = loadedLink.attr("href")
	input = $("<input />")
	input.attr("value", url)
	input.attr("readonly", "true")
	input.addClass("form-control")
	valueContainer.html("Cut and paste the following URL:")
	valueContainer.append(input)
	input.select()
