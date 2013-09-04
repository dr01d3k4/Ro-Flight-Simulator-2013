while not (_G.loadedMenu and _G.Page and _G.ScrollingFrame and _G.planeManagerLoaded)
	wait 0.1

import tweenTime from _G


class _G.LiverySelectPage extends _G.Page
	new: (parent, planeName) =>
		super "LiverySelect", parent
		@background.Name = planeName

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		@initialized = true

	tweenIn: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true
		@background.Size = UDim2.new 0, 0, 1, 0
		@background\TweenSize UDim2.new(1, 0, 1, 0), "In", "Quad", tweenTime, true
		wait tweenTime
		@tweening = false

	tweenOut: =>
		return if not @initialized or @cleanedUp or @tweening
		@tweening = true
		@background\TweenSize UDim2.new(0, 0, 1, 0), "Out", "Quad", tweenTime, true
		wait tweenTime
		@tweening = false

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		@background\Destroy! if @background
		@cleanedUp = true