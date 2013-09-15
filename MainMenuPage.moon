while not (_G.menu and _G.menu.page and _G.menu.page.Page)
	wait 0.1

import setCurrentMenuPage, createTitle, tweenTime, createButton, tweenExtra from _G.menu

pageButtonMapping = {
	{"Free Flight", "ChoosePlanePage"},
	{"Missions", "MissionsPage"},
	{"ATC", "ATCPage"},
	{"Passenger", "PassengerPage"},
	{"Help", "HelpPage"},
	{"Options", "OptionsPage"},
	{"About", "AboutPage"}
}

class _G.menu.page.MainMenuPage extends _G.menu.page.Page
	titleHeight = 0.275
	buttonWidth = 0.8
	buttonLeft = (1 - buttonWidth) / 2

	new: (parent) =>
		super "MainMenuPage", parent
		@title, @buttonObjects = nil, { }

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		button\Destroy! for button in *@buttonObjects

		@title = createTitle "Ro-Flight Simulator 2013", @background, UDim2.new(1, 0, titleHeight, 0)

		@buttonObjects = { }
		-- buttonNames = [" - "..page[1] for page in *pageButtonMapping]
		buttonHeight = 0.05
		buttonSpacing = 0.03

		yPos = titleHeight + buttonSpacing
		for i = 1, #pageButtonMapping
			currentPos = yPos
			pageName = pageButtonMapping[i][1]
			buttonName = " - "..pageName
			cleanName = pageName\gsub "%W", ""

			@buttonObjects[#@buttonObjects + 1] = createButton cleanName, buttonName, @background, 
				UDim2.new(buttonWidth, 0, buttonHeight, 0), UDim2.new(buttonLeft, 0, yPos, 0),
				((button) ->
					return false if not @initialized or @cleanedUp or @tweening
					button.Text = buttonName.." >"
					return true),
				((button) ->
					return false if not @initialized or @cleanedUp or @tweening
					button.Text = buttonName
					return true),
				(->
					return if not @initialized or @cleanedUp or @tweening
					@menuButtonClicked pageName)

			yPos += buttonHeight + buttonSpacing

		@initialized = true

	tweenIn: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true
		@title.Position = UDim2.new 0, 0, -titleHeight, -tweenExtra
		for button in *@buttonObjects
			button.Position = UDim2.new -buttonWidth, -tweenExtra, button.Position.Y.Scale, 0

		@title\TweenPosition UDim2.new(0, 0, 0, 0), "In", "Quad", tweenTime, true
		wait tweenTime - 0.1
		for button in *@buttonObjects
			button\TweenPosition UDim2.new(buttonLeft, 0, button.Position.Y.Scale, 0), "In", "Quad", tweenTime, true
			wait 0.1
		wait tweenTime - 0.1
		@tweening = false

	tweenOut: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true
		for i = #@buttonObjects, 1, -1
			@buttonObjects[i]\TweenPosition UDim2.new(-buttonWidth, -tweenExtra, @buttonObjects[i].Position.Y.Scale, 0), "Out", "Quad", tweenTime, true
			wait 0.1
		wait 0.2
		@title\TweenPosition UDim2.new(0, 0, -titleHeight, -tweenExtra), "Out", "Quad", tweenTime, true
		wait tweenTime
		@tweening = false

	menuButtonClicked: (button) =>
		return if not @initialized or @cleanedUp or @tweening

		pageName = "MainMenuPage"

		for page in *pageButtonMapping
			if page[1] == button and _G.menu.page[page[2]]
				pageName = page[2]

		if not _G.menu.page[pageName]
			pageName = "MainMenuPage"
			
		setCurrentMenuPage _G.menu.page[pageName]

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		button\Destroy! for button in *@buttonObjects
		@background\Destroy! if @background
		@cleanedUp = true