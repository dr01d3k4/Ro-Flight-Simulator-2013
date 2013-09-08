while not (_G.loadedMenu and _G.Page and _G.ScrollingFrame and _G.planeManagerLoaded)
	wait 0.1

import tweenTime, createTitle, getPlaneFromName, rgbColour, weldModel, unanchorModel, camera, head from _G
import max from math

ignoredSections = {"NoColour", "GlassWindow"}

isIgnoredSection = (section) ->
	for ignored in *ignoredSections
		if section == ignored
			return true
	return false

class _G.LiverySelectPage extends _G.Page
	titleHeight = 0.09
	planeNameHeight = 0.05
	colourSelectorLeft = 0.05

	new: (parent, planeName) =>
		super "LiverySelect", parent
		@planeName = planeName
		@title, @planeNameLabel, @sectionColourTexts = nil, nil, { }

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		@planeNameLabel\Destroy! if @planeNameLabel
		section\Destroy! for section in *@sectionColourTexts

		@title = createTitle "Choose Livery", @background, UDim2.new(1, 0, titleHeight, 0)
		@planeNameLabel = createTitle @planeName, @background, UDim2.new(1, 0, planeNameHeight, 0), UDim2.new(0, 0, titleHeight, 0)
		@planeNameLabel.Name = "PlaneNameTitle"

		@planeModel = getPlaneFromName(@planeName)\Clone!

		@planeModel.Parent = camera

		engine = @planeModel.Engine
		engine.Anchored = true
		planePreviewBase = @parentPage.planePreviewBase

		baseSize = max(engine.Size.x, engine.Size.z) * 2
		if baseSize < @parentPage.baseSize.x
			baseSize = @parentPage.baseSize.x
		planePreviewBase.Size = Vector3.new baseSize, planePreviewBase.Size.y, baseSize

		weldModel @planeModel, engine
		unanchorModel @planeModel, engine

		engine.Anchored = false
		engine.Transparency = 1
		engine.CFrame = CFrame.new planePreviewBase.Position + Vector3.new 0, @planeModel.Engine.Size.y * 2, 0
		head.CFrame = engine.CFrame
		camera.CameraType = "Watch"

		sectionNames = [section.Name for section in *@planeModel\GetChildren! when section\IsA("Model") and not isIgnoredSection(section.Name)]
		table.sort sectionNames
		
		colourSelectorHeight = 0.03
		colourSelectorSpacing = 0.015
		colourSelectorLeftWidth = 0.4
		yPos = titleHeight + planeNameHeight + colourSelectorSpacing

		@sectionColourTexts = { }

		for sectionName in *sectionNames
			section = @planeModel[sectionName]
			colour = nil
			for part in *section\GetChildren!
				if part\IsA "BasePart"
					colour = part.BrickColor unless colour
					part.BrickColor = colour
			continue unless colour

			colourSelectorFrame = with Instance.new "Frame", @background
				.Name = yPos
				.Position = UDim2.new colourSelectorLeft, 0, yPos, 0
				.Size = UDim2.new 1 - (colourSelectorLeft * 2), 0, colourSelectorHeight, 0
				.BackgroundTransparency = 1

			with Instance.new "TextLabel", colourSelectorFrame
				.Name = sectionName
				.Text = sectionName..": "
				.Position = UDim2.new 0, 0, 0, 0
				.Size = UDim2.new colourSelectorLeftWidth, 0, 1, 0
				.TextColor3 = rgbColour 255, 255, 255
				.BackgroundTransparency = 1
				.Font = "SourceSansBold"
				.FontSize = "Size18"
				.TextXAlignment = "Right"

			with Instance.new "TextBox", colourSelectorFrame
				.Name = sectionName.."Pick"
				.Position = UDim2.new colourSelectorLeftWidth, 0, 0, 0
				.Size = UDim2.new 1 - colourSelectorLeftWidth, 0, 1, 0
				.TextColor3 = colour.Color
				.BackgroundTransparency = 1
				.Font = "SourceSansBold"
				.FontSize = "Size18"
				.TextXAlignment = "Left"

				setTextFromColour = ->
					.Text = "(%i, %i, %i)"\format colour.r * 255, colour.g * 255, colour.b * 255
					.TextColor3 = colour.Color

				setTextFromColour!

				.FocusLost\connect ->
					textMatch = "^%(?(%d+)[%p%s]+(%d+)[%p%s]+(%d+)%)?$"
					if .Text\match textMatch
						r, g, b = .Text\match textMatch
						r, g, b = tonumber(r), tonumber(g), tonumber(b)

						if not r or not g or not b
							setTextFromColour!

						for part in *section\GetChildren!
							if part\IsA "BasePart"
								part.BrickColor = BrickColor.new r / 255, g / 255, b / 255
								colour = part.BrickColor
								for obj in *part\GetChildren!
									if obj.ClassName\match "Mesh$"
										obj.VertexColor = Vector3.new colour.r, colour.g, colour.b

						setTextFromColour!
					else
						setTextFromColour!

			@sectionColourTexts[#@sectionColourTexts + 1] = colourSelectorFrame
			yPos +=  colourSelectorHeight + colourSelectorSpacing

		@initialized = true

	tweenIn: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true


		@title.Visible = false
		@title.Position = UDim2.new 0, 0, -titleHeight, 0
		@planeNameLabel.Visible = false
		@planeNameLabel.Position = UDim2.new 0, 0, -planeNameHeight, 0
		for section in *@sectionColourTexts
			section.Visible = false
			section.Position = UDim2.new colourSelectorLeft, 0, -section.Size.Y.Scale, 0

		@background.Size = UDim2.new 0, 0, 1, 0
		@background\TweenSize UDim2.new(1, 0, 1, 0), "In", "Quad", tweenTime / 2, true
		wait tweenTime / 2

		@title.Visible = true
		@title\TweenPosition UDim2.new(0, 0, 0, 0), "In", "Quad", tweenTime / 2, true
		wait tweenTime / 4

		@planeNameLabel.Visible = true
		@planeNameLabel\TweenPosition UDim2.new(0, 0, titleHeight, 0), "In", "Quad", tweenTime / 2, true
		wait tweenTime / 4

		for i = 1, #@sectionColourTexts
			section = @sectionColourTexts[i]
			section.Visible = true
			section\TweenPosition UDim2.new(colourSelectorLeft, 0, tonumber(section.Name), 0), "In", "Quad", tweenTime / 2, true
			wait tweenTime / 4
		wait tweenTime / 4

		@tweening = false

	tweenOut: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true

		for i = #@sectionColourTexts, 1, -1
			section = @sectionColourTexts[i]
			section\TweenPosition UDim2.new(colourSelectorLeft, 0, -section.Size.Y.Scale, 0), "Out", "Quad", tweenTime / 2, true
			wait tweenTime / 4

		@planeNameLabel\TweenPosition UDim2.new(0, 0, -planeNameHeight, 0), "Out", "Quad", tweenTime / 2, true
		wait tweenTime / 4

		@title\TweenPosition UDim2.new(0, 0, -titleHeight, 0), "Out", "Quad", tweenTime / 2, true
		wait tweenTime / 2

		@planeNameLabel.Visible = false
		@title.Visible = false

		@background\TweenSize UDim2.new(0, 0, 1, 0), "Out", "Quad", tweenTime / 2, true
		wait tweenTime / 2

		@tweening = false

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		@title\Destroy! if @title
		@planeNameLabel\Destroy! if @planeNameLabel
		section\Destroy! for section in *@sectionColourTexts
		@planeModel\Destroy! if @planeModel
		@background\Destroy! if @background
		@cleanedUp = true