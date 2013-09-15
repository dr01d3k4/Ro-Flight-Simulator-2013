while not (_G.menu and _G.menu.page and _G.menu.page.Page and _G.menu.page.ChooseLiveryPage and _G.ScrollingFrame and _G.planeManager and _G.colour)
	wait 0.1

import camera, head from _G
import rgbToColor3 from _G.colour
import setCurrentMenuPage, createTitle, tweenTime, tweenExtra, createBackButton from _G.menu
import getAllPlaneNames from _G.planeManager

class _G.menu.page.ChoosePlanePage extends _G.menu.page.Page
	titleHeight = 0.09
	spacing = 0.02
	scrollingFrameTop = titleHeight + spacing
	scrollingFrameWidth = 0.9
	scrollingFrameHeight = 0.8
	backButtonSize = UDim2.new 0.4, 0, 0.05, 0
	backButtonPosition = UDim2.new 0.55, 0, 0.93, 0

	new: (parent) =>
		super "ChoosePlanePage", parent
		@title, @scrollingFrame, @backButton = nil, nil, nil
		@planePreviewBase = nil
		@baseSize = Vector3.new 3, 0.2, 3

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		@scrollingFrame\cleanUp! if @scrollingFrame
		@backButton\Destroy! if @backButton
		@planePreviewBase\Destroy! if @planePreviewBase

		@planePreviewBase = with Instance.new "Part", camera
			.Anchored = true
			.BrickColor = BrickColor.new "Dark grey"
			.FormFactor = "Custom"
			.Size = @baseSize
			.Name = "PlanePreviewBase"
			.CFrame = CFrame.new 0, 20, 0
			.TopSurface = "Smooth"
			.BottomSurface = "Smooth"
		Instance.new "CylinderMesh", @planePreviewBase

		head.CFrame = @planePreviewBase.CFrame
		camera.CameraType = "Watch"

		@title = createTitle "Choose Plane", @background, UDim2.new(1, 0, titleHeight, 0)

		baseFrame = with Instance.new "Frame", @background
			.Name = "ScrollingFrame"
			.Size = UDim2.new scrollingFrameWidth, 0, scrollingFrameHeight, 0
			.Position = UDim2.new (1 - scrollingFrameWidth) / 2, 0, scrollingFrameTop, 0
			.BackgroundTransparency = 1

		itemList = getAllPlaneNames! 
		table.sort itemList
		newItemList = [" "..item for item in *itemList]

		itemButton = with Instance.new "TextButton"
			.Name = "Button"
			.Size = UDim2.new 1, 0, 0, 20
			.TextScaled = false
			.TextWrapped = true
			.TextXAlignment = "Left"
			.Font = "Arial"
			.FontSize = "Size14"
			.TextColor3 = rgbToColor3 255, 255, 255
			.BackgroundColor3 = rgbToColor3 32, 32, 32
			.BorderColor3 = rgbToColor3 255, 255, 255

		onClickFunction = (index, item, button) ->
			realName = itemList[index]
			return if @childPage and @childPage.planeName and @childPage.planeName == realName
			@setChildPage _G.menu.page.ChooseLiveryPage, @, realName

		@scrollingFrame = _G.ScrollingFrame baseFrame, newItemList, itemButton, onClickFunction

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
				setCurrentMenuPage _G.menu.page.MainMenuPage)
			
		@initialized = true

	tweenIn: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true

		@title.Position = UDim2.new 0, 0, -titleHeight, -tweenExtra
		@scrollingFrame.baseFrame.Visible = false
		@scrollingFrame.baseFrame.Size = UDim2.new scrollingFrameWidth, 0, 0, 0
		@backButton.Position = UDim2.new backButtonPosition.X.Scale, 0, 1 + backButtonSize.Y.Scale, 0

		@title\TweenPosition UDim2.new(0, 0, 0, 0), "In", "Quad", tweenTime, true
		wait tweenTime - 0.1

		@scrollingFrame.baseFrame.Visible = true
		@scrollingFrame.baseFrame\TweenSize UDim2.new(scrollingFrameWidth, 0, scrollingFrameHeight, 0), "In", "Quad", tweenTime, true
		wait tweenTime - 0.2

		@backButton\TweenPosition backButtonPosition, "In", "Quad", tweenTime, true		
		wait tweenTime

		if @childPage
			@childPage\tweenIn!

		@tweening = false

	tweenOut: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true

		if @childPage
			@childPage\tweenOut!

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
		@cleanUpChildPage!
		@title\Destroy! if @title
		@scrollingFrame\cleanUp! if @scrollingFrame
		@backButton\Destroy! if @backButton
		@background\Destroy! if @background
		@cleanedUp = true
