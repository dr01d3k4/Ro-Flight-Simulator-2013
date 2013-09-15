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

menu = { }

menu.menuScreenGui = with Instance.new "ScreenGui", playerGui do .Name = "MenuScreenGui"

menu.tweenTime = 0.4
menu.tweenExtra = 15

colour = { }
colour.rgbToColor3 = (r, g, b) -> Color3.new r / 255, g / 255, b / 255

menu.backgroundWidth = 0.18
menu.menuBackgroundFrame = with Instance.new "Frame", menu.menuScreenGui
	.Name = "Background"
	.Size = UDim2.new 0, 0, 1, 0
	.Position = UDim2.new 0, 0, 0, 0
	.BackgroundColor3 = colour.rgbToColor3 32, 32, 32
	.BackgroundTransparency = 0.3
menu.defaultBackgroundFrame = with menu.menuBackgroundFrame\Clone! do .Size = UDim2.new menu.backgroundWidth, 0, 1, 0


-- Current page
do
	currentPage = nil

	menu.waitForPageCleanUp = (page) ->
		return if not page or page.cleanedUp
		while not page.cleanedUp
			page\cleanUp!
			wait 0.1 if not page.cleanedUp

	menu.setCurrentMenuPage = (pageClass) ->
		if currentPage
			currentPage\tweenOut!
			menu.waitForPageCleanUp currentPage

		pcall(-> child\Destroy!) for child in *menu.menuBackgroundFrame\GetChildren!

		currentPage = with pageClass!
			\initialize!
			\tweenIn!

-- Create title
do
	menu.createTitle = (text, parent, size, position = UDim2.new(0, 0, 0, 0)) ->
		with Instance.new "TextLabel", parent
			.Name = "Title"
			.Size = size
			.Position = position
			.BackgroundTransparency = 1
			.Font = "SourceSansBold"
			.Text = text
			.TextScaled = true
			.TextWrapped = true
			.TextColor3 = colour.rgbToColor3 255, 255, 255
			.TextYAlignment = "Top"

-- Create button
do
	colour.buttonBorder = colour.rgbToColor3 170, 0, 0
	colour.buttonHoverBorder = colour.rgbToColor3 120, 0, 0
	buttonHoverOffset = 2

	menu.createButton = (name, text, parent, size, position, enter, leave, click) ->
		button = Instance.new "TextButton", parent
		with button
			.Name = name
			.Size = size
			.Position = position
			.BackgroundColor3 = colour.rgbToColor3 0, 0, 0
			.BackgroundTransparency = 0
			.BorderColor3 = colour.buttonBorder
			.BorderSizePixel = 1
			.Font = "SourceSans"
			.Text = text
			.TextColor3 = colour.rgbToColor3 255, 255, 255
			.TextScaled = true
			.TextWrapped = true
			.TextXAlignment = "Left"

			.MouseEnter\connect ->
				if enter button
					.BorderColor3 = colour.buttonHoverBorder
					.BorderSizePixel = 2
					.Position = UDim2.new position.X.Scale, position.X.Offset + buttonHoverOffset, position.Y.Scale, position.Y.Offset + buttonHoverOffset

			.MouseLeave\connect ->
				if leave button
					.BorderColor3 = colour.buttonBorder
					.BorderSizePixel = 1
					.Position = position

			.MouseButton1Click\connect ->
				click button

-- Create back buttion
do
	menu.createBackButton = (name, text, parent, size, position, enter, leave, click) ->
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
		with menu.createButton name, text, parent, size, position, enterFunc, leaveFunc, click
			.TextXAlignment = "Right"


_G.colour = colour
_G.menu = menu

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

while not _G.menu.page and not _G.menu.page.MainMenuPage
	wait 0.5

menu.menuBackgroundFrame\TweenSize UDim2.new(menu.backgroundWidth, 0, 1, 0), "In", "Quad", menu.tweenTime, true
wait menu.tweenTime
menu.setCurrentMenuPage _G.menu.page.MainMenuPage
