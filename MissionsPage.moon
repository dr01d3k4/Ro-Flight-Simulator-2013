while not (_G.loadedMenu and _G.Page)
	wait 0.1

import setCurrentMenuPage from _G

class _G.MissionsPage extends _G.Page
	new: (parent) =>
		super "Missions", parent

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		@initialized = true
		setCurrentMenuPage _G.MainMenuPage

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		@background\Destroy! if @background
		@cleanedUp = true