while not (_G.loadedMenu and _G.Page) do
  wait(0.1)
end
local rgbColour, setCurrentMenuPage, createTitle, tweenTime, createButton, tweenExtra = _G.rgbColour, _G.setCurrentMenuPage, _G.createTitle, _G.tweenTime, _G.createButton, _G.tweenExtra
do
  local titleHeight, buttonWidth, buttonLeft
  local _parent_0 = _G.Page
  local _base_0 = {
    initialize = function(self)
      if self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      if self.title then
        self.title:Destroy()
      end
      local _list_0 = self.buttonObjects
      for _index_0 = 1, #_list_0 do
        local button = _list_0[_index_0]
        button:Destroy()
      end
      self.title = createTitle("Ro-Flight Simulator 2013", self.background, UDim2.new(1, 0, titleHeight, 0))
      self.buttonObjects = { }
      local buttonNames = (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_1 = {
          "Free Flight",
          "Missions",
          "ATC",
          "Passenger",
          "Help",
          "Options",
          "About"
        }
        for _index_0 = 1, #_list_1 do
          local name = _list_1[_index_0]
          _accum_0[_len_0] = " - " .. name
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()
      local buttonHeight = 0.05
      local buttonSpacing = 0.03
      local yPos = titleHeight + buttonSpacing
      for i = 1, #buttonNames do
        local currentPos = yPos
        local cleanName = buttonNames[i]:gsub("%W", "")
        self.buttonObjects[#self.buttonObjects + 1] = createButton(cleanName, buttonNames[i], self.background, UDim2.new(buttonWidth, 0, buttonHeight, 0), UDim2.new(buttonLeft, 0, yPos, 0), (function(button)
          if not self.initialized or self.cleanedUp or self.tweening then
            return false
          end
          button.Text = buttonNames[i] .. " >"
          return true
        end), (function(button)
          if not self.initialized or self.cleanedUp or self.tweening then
            return false
          end
          button.Text = buttonNames[i]
          return true
        end), (function()
          if not self.initialized or self.cleanedUp or self.tweening then
            return 
          end
          return self:menuButtonClicked(cleanName)
        end))
        yPos = yPos + (buttonHeight + buttonSpacing)
      end
      self.initialized = true
    end,
    tweenIn = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      self.title.Position = UDim2.new(0, 0, -titleHeight, -tweenExtra)
      local _list_0 = self.buttonObjects
      for _index_0 = 1, #_list_0 do
        local button = _list_0[_index_0]
        button.Position = UDim2.new(-buttonWidth, -tweenExtra, button.Position.Y.Scale, 0)
      end
      self.title:TweenPosition(UDim2.new(0, 0, 0, 0), "In", "Quad", tweenTime, true)
      wait(tweenTime - 0.1)
      local _list_1 = self.buttonObjects
      for _index_0 = 1, #_list_1 do
        local button = _list_1[_index_0]
        button:TweenPosition(UDim2.new(buttonLeft, 0, button.Position.Y.Scale, 0), "In", "Quad", tweenTime, true)
        wait(0.1)
      end
      wait(tweenTime - 0.1)
      self.tweening = false
    end,
    tweenOut = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      for i = #self.buttonObjects, 1, -1 do
        self.buttonObjects[i]:TweenPosition(UDim2.new(-buttonWidth, -tweenExtra, self.buttonObjects[i].Position.Y.Scale, 0), "Out", "Quad", tweenTime, true)
        wait(0.1)
      end
      wait(0.2)
      self.title:TweenPosition(UDim2.new(0, 0, -titleHeight, -tweenExtra), "Out", "Quad", tweenTime, true)
      wait(tweenTime)
      self.tweening = false
    end,
    menuButtonClicked = function(self, button)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self:tweenOut()
      self:cleanUp()
      local pageName = button .. "Page"
      if not _G[pageName] then
        pageName = "MainMenuPage"
      end
      return setCurrentMenuPage(_G[pageName])
    end,
    cleanUp = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      if self.childPage then
        self.childPage:cleanUp()
      end
      if self.title then
        self.title:Destroy()
      end
      local _list_0 = self.buttonObjects
      for _index_0 = 1, #_list_0 do
        local button = _list_0[_index_0]
        button:Destroy()
      end
      if self.background then
        self.background:Destroy()
      end
      self.cleanedUp = true
    end
  }
  _base_0.__index = _base_0
  if _parent_0 then
    setmetatable(_base_0, _parent_0.__base)
  end
  local _class_0 = setmetatable({
    __init = function(self, parent)
      _parent_0.__init(self, "MainMenuPage", parent)
      self.title, self.buttonObjects = nil, { }
    end,
    __base = _base_0,
    __name = "MainMenuPage",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil and _parent_0 then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  titleHeight = 0.275
  buttonWidth = 0.8
  buttonLeft = (1 - buttonWidth) / 2
  if _parent_0 and _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  _G.MainMenuPage = _class_0
  return _class_0
end
