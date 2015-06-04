$ ->
	$("*[data-umlaut-toggle-permalink]").click (event) ->
		originalLink   = $(this)
		valueContainer = $("#umlaut-permalink-container")
		loadedLink = $(".umlaut-permalink-content a")
		url = loadedLink.attr("href")
		if url == undefined
			loadedLink = $("#umlaut-permalink-content")
			url = loadedLink.attr("href")
		input = $("<input />")
		input.attr("value", url)
		input.addClass("form-control")
		valueContainer.html("Cut and paste the following URL:")
		valueContainer.append(input)
		valueContainer.append(loadedLink.attr("id","umlaut-permalink-content"))
		loadedLink.hide()
		input.select()
