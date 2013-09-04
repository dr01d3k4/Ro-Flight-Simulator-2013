while not (_G.loadedMenu and _G.Page and _G.ScrollingFrame and _G.planeManagerLoaded) do
  wait(0.1)
end
local rgbColour, setCurrentMenuPage, createTitle, tweenTime, tweenExtra, createBackButton, getAllPlaneNames = _G.rgbColour, _G.setCurrentMenuPage, _G.createTitle, _G.tweenTime, _G.tweenExtra, _G.createBackButton, _G.getAllPlaneNames
do
  local titleHeight, spacing, scrollingFrameTop, scrollingFrameWidth, backButtonSize, backButtonPosition
  local _parent_0 = _G.Page
  local _base_0 = {
    initialize = function(self)
      if self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      if self.title then
        self.title:Destroy()
      end
      if self.scrollingFrame then
        self.scrollingFrame:cleanUp()
      end
      if self.backButton then
        self.backButton:Destroy()
      end
      self.title = createTitle("Free Flight", self.background, UDim2.new(1, 0, titleHeight, 0))
      local baseFrame
      do
        local _with_0 = Instance.new("Frame", self.background)
        _with_0.Name = "ScrollingFrame"
        _with_0.Size = UDim2.new(scrollingFrameWidth, 0, 0, 250)
        _with_0.Position = UDim2.new((1 - scrollingFrameWidth) / 2, 0, scrollingFrameTop, 0)
        _with_0.BackgroundTransparency = 1
        baseFrame = _with_0
      end
      local itemList = getAllPlaneNames()
      table.sort(itemList)
      local newItemList = (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = itemList
        for _index_0 = 1, #_list_0 do
          local item = _list_0[_index_0]
          _accum_0[_len_0] = " " .. item
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()
      local itemButton
      do
        local _with_0 = Instance.new("TextButton")
        _with_0.Name = "Button"
        _with_0.Size = UDim2.new(1, 0, 0, 20)
        _with_0.TextScaled = false
        _with_0.TextWrapped = true
        _with_0.TextXAlignment = "Left"
        _with_0.Font = "Arial"
        _with_0.FontSize = "Size14"
        _with_0.TextColor3 = rgbColour(255, 255, 255)
        _with_0.BackgroundColor3 = rgbColour(32, 32, 32)
        _with_0.BorderColor3 = rgbColour(255, 255, 255)
        itemButton = _with_0
      end
      local onClickFunction
      onClickFunction = function(index, item, button)
        local realName = itemList[index]
        return self:setChildPage(_G.LiverySelectPage, self.background, realName)
      end
      self.scrollingFrame = _G.ScrollingFrame(baseFrame, newItemList, itemButton, onClickFunction)
      local _list_0 = self.scrollingFrame.innerFrame:GetChildren()
      for _index_0 = 1, #_list_0 do
        local item = _list_0[_index_0]
        local text = item.Text
        item.MouseEnter:connect(function()
          item.Text = text .. " >"
        end)
        item.MouseLeave:connect(function()
          item.Text = text
        end)
      end
      self.backButton = createBackButton("BackButton", "Back ", self.background, backButtonSize, backButtonPosition, (function()
        if not self.initialized or self.cleanedUp or self.tweening then
          return false
        else
          return true
        end
      end), (function()
        if not self.initialized or self.cleanedUp or self.tweening then
          return false
        else
          return true
        end
      end), (function()
        if not self.initialized or self.cleanedUp or self.tweening then
          return false
        end
        return setCurrentMenuPage(_G.MainMenuPage)
      end))
      local setScrollFrameSize
      setScrollFrameSize = function()
        if self.tweening then
          return 
        end
        self.scrollingFrame.baseFrame.Size = UDim2.new(scrollingFrameWidth, 0, (self.backButton.AbsolutePosition.Y / self.background.AbsoluteSize.Y) - spacing - (titleHeight + spacing), 0)
      end
      setScrollFrameSize()
      self.background.Changed:connect(setScrollFrameSize)
      self.initialized = true
    end,
    tweenIn = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      self.title.Position = UDim2.new(0, 0, -titleHeight, -tweenExtra)
      self.scrollingFrame.baseFrame.Visible = false
      local scrollingFrameHeight = self.scrollingFrame.baseFrame.Size.Y.Scale
      self.scrollingFrame.baseFrame.Size = UDim2.new(scrollingFrameWidth, 0, 0, 0)
      self.backButton.Position = UDim2.new(backButtonPosition.X.Scale, backButtonPosition.X.Offset, 1, self.backButton.AbsoluteSize.Y + tweenExtra)
      self.title:TweenPosition(UDim2.new(0, 0, 0, 0), "In", "Quad", tweenTime, true)
      wait(tweenTime - 0.1)
      self.scrollingFrame.baseFrame.Visible = true
      self.scrollingFrame.baseFrame:TweenSize(UDim2.new(scrollingFrameWidth, 0, scrollingFrameHeight, 0), "In", "Quad", tweenTime, true)
      wait(tweenTime - 0.2)
      self.backButton:TweenPosition(backButtonPosition, "In", "Quad", tweenTime, true)
      wait(tweenTime)
      if self.childPage then
        self.childPage:tweenIn()
      end
      self.tweening = false
    end,
    tweenOut = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      if self.childPage then
        self.childPage:tweenOut()
      end
      self.backButton:TweenPosition(UDim2.new(backButtonPosition.X.Scale, backButtonPosition.X.Offset, 1, self.backButton.AbsoluteSize.Y + tweenExtra), "Out", "Quad", tweenTime, true)
      wait(tweenTime - 0.2)
      self.scrollingFrame.baseFrame:TweenSize(UDim2.new(scrollingFrameWidth, 0, 0, 0), "Out", "Quad", tweenTime, true)
      wait(tweenTime - 0.1)
      self.scrollingFrame.baseFrame.Visible = false
      self.title:TweenPosition(UDim2.new(0, 0, -titleHeight, -tweenExtra), "Out", "Quad", tweenTime, true)
      wait(tweenTime)
      self.tweening = false
    end,
    cleanUp = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self:cleanUpChildPage()
      if self.title then
        self.title:Destroy()
      end
      if self.scrollingFrame then
        self.scrollingFrame:cleanUp()
      end
      if self.backButton then
        self.backButton:Destroy()
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
      _parent_0.__init(self, "FreeFlightPage", parent)
      self.title, self.scrollingFrame, self.backButton = nil, nil, nil
      self.liveryBackground = nil
    end,
    __base = _base_0,
    __name = "FreeFlightPage",
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
  titleHeight = 0.09
  spacing = 0.02
  scrollingFrameTop = titleHeight + spacing
  scrollingFrameWidth = 0.9
  backButtonSize = UDim2.new(0, 66, 0, 30)
  backButtonPosition = UDim2.new(0.95, -66, 1, -40)
  if _parent_0 and _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  _G.FreeFlightPage = _class_0
  return _class_0
end
