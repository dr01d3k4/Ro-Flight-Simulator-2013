while not _G.loadedMenu
	wait 0.1

import menuScreenGui, menuBackgroundFrame from _G

class _G.Page
	new: (name) =>
		assert menuScreenGui, "Attempt to create #{name} before creating menuScreenGui"
		@background\Destroy! if @background
		@background = with Instance.new "Frame", menuBackgroundFrame
			.BackgroundTransparency = 1
			.Name = name
			.Size = UDim2.new 1, 0, 1, 0
			.BackgroundTransparency = 1
		@initialized = false
		@cleanedUp = false
		@tweening = false

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

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		print "Cleaning up page"
		@background\Destroy! if @background
		@cleanedUp = true