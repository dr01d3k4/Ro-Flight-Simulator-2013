wait 1
while not game.Players.LocalPlayer
	wait 0.6
player = game.Players.LocalPlayer
while not player.Character and not player.Character\findFirstChild "Head"
	wait 0.1
character = player.Character
head = character.Head
playerGui = player.PlayerGui
camera = workspace.CurrentCamera
_G.camera = camera
_G.head = head

menuScreenGui = with Instance.new "ScreenGui", playerGui do .Name = "MenuScreenGui"
_G.menuScreenGui = menuScreenGui

tweenTime = 0.4
_G.tweenTime = tweenTime
_G.tweenExtra = 15

rgbColour = (r, g, b) -> Color3.new r / 255, g / 255, b / 255
_G.rgbColour = rgbColour

backgroundWidth = 0.18
menuBackgroundFrame = with Instance.new "Frame", menuScreenGui
	.Name = "Background"
	.Size = UDim2.new 0, 0, 1, 0
	.Position = UDim2.new 0, 0, 0, 0
	.BackgroundColor3 = rgbColour 32, 32, 32
	.BackgroundTransparency = 0.3
_G.menuBackgroundFrame = menuBackgroundFrame
_G.defaultBackgroundFrame = with menuBackgroundFrame\Clone! do .Size = UDim2.new backgroundWidth, 0, 1, 0


-- Current page
local setCurrentMenuPage
do
	currentPage = nil

	waitForPageCleanUp = (page) ->
		return if not page or page.cleanedUp
		while not page.cleanedUp
			page\cleanUp!
			wait 0.1 if not page.cleanedUp

	setCurrentMenuPage = (pageClass) ->
		if currentPage
			currentPage\tweenOut!
			waitForPageCleanUp currentPage

		pcall(-> child\Destroy!) for child in *menuBackgroundFrame\GetChildren!

		currentPage = with pageClass!
			\initialize!
			\tweenIn!

	_G.waitForPageCleanUp = waitForPageCleanUp
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

-- Weld and unanchor model
do
	weldPart = (part, base) ->
		with Instance.new "Weld", base
			.Part0 = base
			.Part1 = part
			.C0 = base.CFrame\inverse! * CFrame.new base.Position
			.C1 = part.CFrame\inverse! * CFrame.new base.Position

	weldModel = (model, base) ->
		for child in *model\GetChildren!
			continue if child == base
			if child\IsA "BasePart"
				weldPart child, base
			elseif child\IsA "Model"
				weldModel child, base
	_G.weldModel = weldModel

	unanchorModel = (model, base) ->
		for child in *model\GetChildren!
			continue if child == base
			if child\IsA "BasePart"
				child.Anchored = false
			elseif child\IsA "Model"
				unanchorModel child, base
	_G.unanchorModel = unanchorModel

_G.loadedMenu = true

loadPlayer = ->
	head.Anchored = true
	camera.CameraSubject = head
	wait!
	camera.CameraType = "Attach"
	wait!
	camera.CameraType = "Track"
	camera.CameraSubject = head
	head.CanCollide = false

	while not character\findFirstChild "Torso"
		wait 0.5

	deleteThings = ->
		for obj in *character\GetChildren! 
			unless obj.Name == "Humanoid" or obj.Name == "Head" or obj.Name == "Torso" 
				obj\Destroy!
		character.Humanoid\Destroy! if character\findFirstChild "Humanoid"
		character.Torso\Destroy! if character\findFirstChild "Torso"
		obj\Destroy for obj in *head\GetChildren!

		playerGui.HealthGUI\Destroy! if playerGui\findFirstChild "HealthGUI"

	deleteThings!

	head.FormFactor = "Custom"
	head.Size = Vector3.new 0.2, 0.2, 0.2
	Instance.new("BlockMesh", head).Scale = Vector3.new 0, 0, 0
	head.BrickColor = BrickColor.new "Bright red"

	player.DescendantAdded\connect deleteThings

loadPlayer!

while not _G.MainMenuPage
	wait 0.5

menuBackgroundFrame\TweenSize UDim2.new(backgroundWidth, 0, 1, 0), "In", "Quad", tweenTime, true
wait tweenTime
setCurrentMenuPage _G.MainMenuPage
