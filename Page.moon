while not _G.loadedMenu
	wait 0.1

import menuScreenGui from _G

class _G.Page
	new: (name, parent) =>
		assert menuScreenGui, "Attempt to create #{name} before creating menuScreenGui"
		@background\Destroy! if @background
		@background = with Instance.new "Frame", parent
			.BackgroundTransparency = 1
			.Name = name
			.Size = UDim2.new 1, 0, 1, 0
			.BackgroundTransparency = 1
			if parent == menuBackgroundFrame
				.Position = UDim2.new 0, 0, 0, 0
			else
				.Position = UDim2.new 1, 0, 0, 0
		@initialized = false
		@cleanedUp = false
		@tweening = false
		@childPage = nil

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		print "Initializing page"
		@initialized = true

	tweenIn: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true
		print "Tweening page in"
		@tweening = false

	tweenOut: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true
		print "Tweening page out"
		@tweening = false

	setChildPage: (pageClass) =>
		if @childPage
			@childPage\tweenOut!
			@childPage\cleanUp!
		@childPage = with pageClass @background
			\initialize!
			\tweenIn!

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		if @childPage
			@childPage\cleanUp!
		@background\Destroy! if @background
		@cleanedUp = true