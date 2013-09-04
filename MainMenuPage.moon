while not (_G.loadedMenu and _G.Page)
	wait 0.1

import rgbColour, setCurrentMenuPage, createTitle, tweenTime, createButton, tweenExtra from _G

class _G.MainMenuPage extends _G.Page
	titleHeight = 0.275 -- 150
	buttonWidth = 0.8
	buttonLeft = (1 - buttonWidth) / 2

	new: =>
		super "MainMenuPage"
		@title, @buttonObjects = nil, { }

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		button\Destroy! for button in *@buttonObjects

		@title = createTitle "Ro-Flight Simulator 2013", @background, UDim2.new(1, 0, titleHeight, 0)

		@buttonObjects = { }
		buttonNames = [" - "..name for name in *{"Free Flight", "Missions", "ATC", "Passenger", "Help", "Options", "About"}]
		buttonHeight = 0.05 -- 30
		buttonSpacing = 0.03 -- 20

		yPos = titleHeight + buttonSpacing
		for i = 1, #buttonNames
			currentPos = yPos
			cleanName = buttonNames[i]\gsub "%W", ""

			@buttonObjects[#@buttonObjects + 1] = createButton cleanName, buttonNames[i], @background, 
				UDim2.new(buttonWidth, 0, buttonHeight, 0), UDim2.new(buttonLeft, 0, yPos, 0),
				((button) ->
					return false if not @initialized or @cleanedUp or @tweening
					button.Text = buttonNames[i].." >"
					return true),
				((button) ->
					return false if not @initialized or @cleanedUp or @tweening
					button.Text = buttonNames[i]
					return true),
				(->
					return if not @initialized or @cleanedUp or @tweening
					@menuButtonClicked cleanName)

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
		@tweenOut!
		@cleanUp!
		
		pageName = button.."Page"
		if not _G[pageName]
			pageName = "MainMenuPage"
		setCurrentMenuPage _G[pageName]

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		button\Destroy! for button in *@buttonObjects
		@background\Destroy! if @background
		@cleanedUp = true