while not (_G.menu and _G.menu.page and _G.menu.page.Page)
	wait 0.1

import setCurrentMenuPage from _G.menu

class _G.menu.page.MissionsPage extends _G.menu.page.Page
	new: (parent) =>
		super "MissionsPage", parent

	initialize: =>
		return if @initialized or @cleanedUp or @tweening
		@initialized = true
		setCurrentMenuPage _G.menu.page.MainMenuPage

	cleanUp: =>
		return if not @initialized or @cleanedUp or @tweening
		@background\Destroy! if @background
		@cleanedUp = true