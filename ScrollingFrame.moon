rgbColour = (r, g, b) -> Color3.new r / 255, g / 255, b / 255

class _G.ScrollingFrame
	new: (baseFrame, itemList, itemButton, onClickFunction) =>
		@baseFrame = baseFrame
		@itemCount = #itemList
		@scrollAmount = 0
		@itemHeight = itemButton.Size.Y.Offset
		@scrollBarWidth = 0.1
		@scrollButtonHeight = 0.08

		@calculateScrolling!

		itemButton.Size = UDim2.new(1, 0, 0, @itemHeight)

		@innerFrame = with Instance.new "Frame", @baseFrame
			.Name = "InnerFrame"
			.Position = UDim2.new(0, 0, 0, 0)
			.Size = UDim2.new(1 - @scrollBarWidth, 0, 1, 0)
			.BackgroundTransparency = 0
			.BackgroundColor3 = Color3.new 0, 0, 0
			.BorderColor3 = Color3.new 1, 1, 1
			.ClipsDescendants = true

		@scrollFrame = with Instance.new "Frame", @baseFrame
			.Name = "ScrollFrame"
			.Position = UDim2.new(1 - @scrollBarWidth, 0, 0, 0)
			.Size = UDim2.new(@scrollBarWidth, 0, 1, 0)
			.BackgroundTransparency = 0
			.BackgroundColor3 = Color3.new 0, 0, 0
			.BorderColor3 = Color3.new 1, 1, 1
			.ClipsDescendants = true

		for i = 1, #itemList
			item = itemList[i]
			button = with itemButton\Clone!
				.Text = item
				.Name = i
				.Parent = @innerFrame
				.MouseButton1Click\connect ->
					onClickFunction i, itemList[i], button
				.Position = UDim2.new 0, 0, 0, (i - 1) * @itemHeight

		@buttonUp = with Instance.new "TextButton", @scrollFrame
			.Size = UDim2.new 1, 0, @scrollButtonHeight, 0
			.Position = UDim2.new 0, 0, 0, 0
			.Text = "/\\"
			.Name = "ButtonUp"
			.MouseButton1Click\connect ->
				return if @totalHeight <= @visibleAmount
				@scrollAmount -= @scrollSpeed

				@updateScrollList!

		@buttonDown = with Instance.new "TextButton", @scrollFrame
			.Size = UDim2.new 1, 0, @scrollButtonHeight, 0
			.Position = UDim2.new 0, 0, 1 - @scrollButtonHeight, 0
			.Text = "\\/"
			.Name = "ButtonDown"
			.MouseButton1Click\connect ->
				return if @totalHeight <= @visibleAmount
				@scrollAmount += @scrollSpeed
				@updateScrollList!

		@scrollBarFrame = with Instance.new "Frame", @scrollFrame
			.Name = "ScrollBarFrame"
			.Size = UDim2.new 1, 0, 1 - (@scrollButtonHeight * 2), 0
			.Position = UDim2.new 0, 0, @scrollButtonHeight, 0
			.BackgroundTransparency = 0
			.BackgroundColor3 = Color3.new 0, 0, 0
			.BorderColor3 = Color3.new 1, 1, 1
			.ClipsDescendants = true

		scrollBarDragging = false

		@scrollBar = with Instance.new "TextButton", @scrollBarFrame
			.Name = "ScrollBar"
			.Size = UDim2.new 1, 0, @scrollBarHeight, 0
			.Position = UDim2.new 0, 0, 0, 0
			.BorderColor3 = Color3.new 1, 1, 1
			.Text = "_\n_\n_"
			.TextColor3 = rgbColour 128, 128, 128
			.TextStrokeTransparency = 0
			.Font = "ArialBold"
			.FontSize = "Size12"
			.TextStrokeColor3 = rgbColour 100, 100, 100

			prevY = 0

			.MouseButton1Down\connect (x, y) ->
				return unless @totalHeight > @visibleAmount
				prevY = y
				scrollBarDragging = true
				@updateScrollList!

			.MouseButton1Up\connect ->
				return unless @totalHeight > @visibleAmount
				scrollBarDragging = false
				@updateScrollList!


			mouse = game.Players.LocalPlayer\GetMouse!

			mouse.Move\connect ->
				return unless scrollBarDragging and @totalHeight > @visibleAmount
				deltaY = mouse.Y - prevY

				scaleDeltaY = deltaY / (@scrollBarFrame.AbsoluteSize.Y - @scrollBar.AbsoluteSize.Y)
				@scrollAmount += scaleDeltaY

				prevY = mouse.Y
				@updateScrollList!

			mouse.Button1Up\connect ->
				scrollBarDragging = false
				@updateScrollList!

		baseFrame.Changed\connect @\calculateScrolling

		@initScrolling = true

	calculateScrolling: =>
		@visibleAmount = @baseFrame.AbsoluteSize.y
		@totalHeight = (@itemCount * @itemHeight)
		@scrollHeight = @totalHeight - @visibleAmount
		if @scrollHeight < 0
			@scrollHeight = 0

		if @visibleAmount < @totalHeight
			@scrollBarHeight = @visibleAmount / @totalHeight
		else
			@scrollBarHeight = 1

		@scrollSpeed = (1 / @itemCount) * 4

		@updateScrollList!

	updateScrollList: =>
		return unless @initScrolling

		if @scrollAmount < 0
			@scrollAmount = 0
		if @scrollAmount > 1
			@scrollAmount = 1

		if @totalHeight < @visibleAmount
			@scrollAmount = 0

		for i = 1, @itemCount
			button = @innerFrame\findFirstChild "#{i}"
			if button != nil
				button.Position = UDim2.new 0, 0, 0, ((i - 1) * @itemHeight) - (@scrollAmount * @scrollHeight)

		@scrollBar.Size = UDim2.new 1, 0, @scrollBarHeight, 0
		@scrollBar.Position = UDim2.new 0, 0, (1 - @scrollBarHeight) * @scrollAmount, 0

	cleanUp: =>
		@baseFrame\Destroy!