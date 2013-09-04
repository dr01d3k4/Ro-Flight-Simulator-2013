wait 1
while not game.Players.LocalPlayer
	wait 0.6
player = game.Players.LocalPlayer
playerGui = player.PlayerGui

menuScreenGui = with Instance.new "ScreenGui", playerGui do .Name = "MenuScreenGui"
_G.menuScreenGui = menuScreenGui

tweenTime = 0.6
_G.tweenTime = tweenTime
_G.tweenExtra = 20

rgbColour = (r, g, b) -> Color3.new r / 255, g / 255, b / 255
_G.rgbColour = rgbColour

backgroundWidth = 0.2
menuBackgroundFrame = with Instance.new "Frame", menuScreenGui
	.Name = "Background"
	.Size = UDim2.new 0, 0, 1, 0
	.BackgroundColor3 = rgbColour 32, 32, 32
	.BackgroundTransparency = 0.3
_G.menuBackgroundFrame = menuBackgroundFrame

-- Current page
local setCurrentMenuPage
do
	currentPage = nil
	setCurrentMenuPage = (pageClass) ->
		if currentPage
			currentPage\tweenOut!
			currentPage\cleanUp!
		currentPage = with pageClass menuBackgroundFrame
			\initialize!
			\tweenIn!
	_G.setCurrentMenuPage = setCurrentMenuPage

-- Create title
do
	_G.createTitle = (text, parent, size, position = UDim2.new(0, 0, 0, 0)) ->
		with Instance.new "TextLabel", parent
			.Name = "Title"
			.Size = size
			.Position = position
			.BackgroundTransparency = 1
			.Font = "SourceSansBold"
			.Text = text
			.TextScaled = true
			.TextWrapped = true
			.TextColor3 = rgbColour 255, 255, 255
			.TextYAlignment = "Top"

-- Create button
local createButton
do
	buttonBorder = rgbColour 170, 0, 0
	buttonHoverBorder = rgbColour 120, 0, 0
	buttonHoverOffset = 2

	createButton = (name, text, parent, size, position, enter, leave, click) ->
		button = Instance.new "TextButton", parent
		with button
			.Name = name
			.Size = size
			.Position = position
			.BackgroundColor3 = rgbColour 0, 0, 0
			.BackgroundTransparency = 0
			.BorderColor3 = buttonBorder
			.BorderSizePixel = 1
			.Font = "SourceSans"
			.Text = text
			.TextColor3 = rgbColour 255, 255, 255
			.TextScaled = true
			.TextWrapped = true
			.TextXAlignment = "Left"

			.MouseEnter\connect ->
				if enter button
					.BorderColor3 = buttonHoverBorder
					.BorderSizePixel = 2
					.Position = UDim2.new position.X.Scale, position.X.Offset + buttonHoverOffset, position.Y.Scale, position.Y.Offset + buttonHoverOffset

			.MouseLeave\connect ->
				if leave button
					.BorderColor3 = buttonBorder
					.BorderSizePixel = 1
					.Position = position

			.MouseButton1Click\connect ->
				click button
	_G.createButton = createButton

-- Create back buttion
do
	_G.createBackButton = (name, text, parent, size, position, enter, leave, click) ->
		enterFunc = (button)->
			if enter button
				button.Text = "< "..text
				return true
			else
				return false
		leaveFunc = (button) ->
			if leave button
				button.Text = text
				return true
			else
				return false
		with createButton name, text, parent, size, position, enterFunc, leaveFunc, click
			.TextXAlignment = "Right"

_G.loadedMenu = true

while not _G.MainMenuPage
	wait 0.5

menuBackgroundFrame\TweenSize UDim2.new(backgroundWidth, 0, 1, 0), "In", "Quad", tweenTime, true
wait tweenTime
setCurrentMenuPage _G.MainMenuPage
