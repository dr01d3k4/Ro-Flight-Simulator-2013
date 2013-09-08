while not _G.loadedMenu
	wait 0.1

import menuScreenGui, menuBackgroundFrame, defaultBackgroundFrame, waitForPageCleanUp from _G

class _G.Page
	new: (name, parentPage) =>
		assert menuScreenGui, "Attempt to create #{name} before creating menuScreenGui"
		@parentPage = parentPage if parentPage
		@background\Destroy! if @background
		@background = with defaultBackgroundFrame\Clone!
			.Name = name
			if parentPage and parentPage.background
				.Parent = parentPage.background
				.Position = UDim2.new 1, 0, 0, 0
				.BackgroundTransparency = menuBackgroundFrame.BackgroundTransparency
			else
				.Parent = menuBackgroundFrame
				.Position = UDim2.new 0, 0, 0, 0
				.BackgroundTransparency = 1
			.Size = UDim2.new 1, 0, 1, 0
		@initialized = false
		@cleanedUp = false
		@tweening = false
		@childPage = nil
		@settingChildPage = false

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

	setChildPage: (pageClass, ...) =>
		return if @settingChildPage
		@settingChildPage = true
		if @childPage
			@childPage\tweenOut!
			@cleanUpChildPage!
		@childPage = with pageClass ...
			\initialize!
			\tweenIn!
		@settingChildPage = false

	cleanUpChildPage: =>
		waitForPageCleanUp @childPage

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		@cleanUpChildPage!
		@background\Destroy! if @background
		@cleanedUp = true