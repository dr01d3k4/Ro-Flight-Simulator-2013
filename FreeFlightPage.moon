while not (_G.loadedMenu and _G.Page and _G.ScrollingFrame)
	wait 0.1

import rgbColour, setCurrentMenuPage, createTitle, tweenTime, tweenExtra, createBackButton from _G

class _G.FreeFlightPage extends _G.Page
	titleHeight = 0.09
	spacing = 0.02
	scrollingFrameTop = titleHeight + spacing
	scrollingFrameWidth = 0.9
	backButtonSize = UDim2.new(0, 66, 0, 30)
	backButtonPosition = UDim2.new(0.95, -66, 1, -40)

	new: =>
		super "FreeFlightPage"
		@title, @scrollingFrame, @backButton = nil, nil, nil

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		@scrollingFrame\cleanUp! if @scrollingFrame
		@backButton\Destroy! if @backButton

		@title = createTitle "Free Flight", @background, UDim2.new(1, 0, titleHeight, 0)

		baseFrame = with Instance.new "Frame", @background
			.Name = "ScrollingFrame"
			.Size = UDim2.new scrollingFrameWidth, 0, 0, 250
			.Position = UDim2.new (1 - scrollingFrameWidth) / 2, 0, scrollingFrameTop, 0
			.BackgroundTransparency = 1

		itemList = {"Plane 1", "Cessna 172", "Boeing 737-800", "Robin Something", "Boeing 747-400", "Airbus A350-900", "Boeing 757", "Lockheed Tristar", "DC11", "Concorde", "Airbus A380", "Boeing 727", "Other plane", "I need ideas", "To test", "The scrolling"}
		table.sort itemList
		itemList = [" "..item for item in *itemList]

		itemButton = with Instance.new "TextButton"
			.Name = "Button"
			.Size = UDim2.new 1, 0, 0, 20
			.TextScaled = false
			.TextWrapped = true
			.TextXAlignment = "Left"
			.Font = "Arial"
			.FontSize = "Size14"
			.TextColor3 = rgbColour 255, 255, 255
			.BackgroundColor3 = rgbColour 32, 32, 32
			.BorderColor3 = rgbColour 255, 255, 255

		onClickFunction = (index, item, button) ->
			print "\"#{item}\" was clicked"

		@scrollingFrame = _G.ScrollingFrame baseFrame, itemList, itemButton, onClickFunction

		for item in *@scrollingFrame.innerFrame\GetChildren!
			text = item.Text
			item.MouseEnter\connect ->
				item.Text = text.." >"
			item.MouseLeave\connect ->
				item.Text = text

		@backButton = createBackButton "BackButton", "Back ", @background,
			backButtonSize, backButtonPosition,
			(-> return false if not @initialized or @cleanedUp or @tweening else true),
			(-> return false if not @initialized or @cleanedUp or @tweening else true),
			(->
				return false if not @initialized or @cleanedUp or @tweening
				setCurrentMenuPage _G.MainMenuPage)

		setScrollFrameSize = ->
			return if @tweening
			@scrollingFrame.baseFrame.Size = UDim2.new scrollingFrameWidth, 0, (@backButton.AbsolutePosition.Y / @background.AbsoluteSize.Y) - spacing - (titleHeight + spacing), 0
		setScrollFrameSize!
		@background.Changed\connect setScrollFrameSize

		@initialized = true

	tweenIn: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true

		@title.Position = UDim2.new 0, 0, -titleHeight, -tweenExtra
		@scrollingFrame.baseFrame.Visible = false
		scrollingFrameHeight = @scrollingFrame.baseFrame.Size.Y.Scale
		@scrollingFrame.baseFrame.Size = UDim2.new scrollingFrameWidth, 0, 0, 0
		@backButton.Position = UDim2.new backButtonPosition.X.Scale, backButtonPosition.X.Offset, 1, @backButton.AbsoluteSize.Y + tweenExtra

		@title\TweenPosition UDim2.new(0, 0, 0, 0), "In", "Quad", tweenTime, true
		wait tweenTime - 0.1

		@scrollingFrame.baseFrame.Visible = true
		@scrollingFrame.baseFrame\TweenSize UDim2.new(scrollingFrameWidth, 0, scrollingFrameHeight, 0), "In", "Quad", tweenTime, true
		wait tweenTime - 0.2

		@backButton\TweenPosition backButtonPosition, "In", "Quad", tweenTime, true

		wait tweenTime
		@tweening = false

	tweenOut: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true

		@backButton\TweenPosition UDim2.new(backButtonPosition.X.Scale, backButtonPosition.X.Offset, 1, @backButton.AbsoluteSize.Y + tweenExtra), "Out", "Quad", tweenTime, true
		wait tweenTime - 0.2

		@scrollingFrame.baseFrame\TweenSize UDim2.new(scrollingFrameWidth, 0, 0, 0), "Out", "Quad", tweenTime, true
		wait tweenTime - 0.1
		@scrollingFrame.baseFrame.Visible = false

		@title\TweenPosition UDim2.new(0, 0, -titleHeight, -tweenExtra), "Out", "Quad", tweenTime, true

		wait tweenTime
		@tweening = false

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		@scrollingFrame\cleanUp! if @scrollingFrame
		@backButton\Destroy! if @backButton
		@background\Destroy! if @background
		@cleanedUp = true
