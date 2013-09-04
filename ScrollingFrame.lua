local rgbColour
rgbColour = function(r, g, b)
  return Color3.new(r / 255, g / 255, b / 255)
end
do
  local _parent_0 = nil
  local _base_0 = {
    calculateScrolling = function(self)
      self.visibleAmount = self.baseFrame.AbsoluteSize.y
      self.totalHeight = (self.itemCount * self.itemHeight)
      self.scrollHeight = self.totalHeight - self.visibleAmount
      if self.scrollHeight < 0 then
        self.scrollHeight = 0
      end
      if self.visibleAmount < self.totalHeight then
        self.scrollBarHeight = self.visibleAmount / self.totalHeight
      else
        self.scrollBarHeight = 1
      end
      self.scrollSpeed = (1 / self.itemCount) * 4
      return self:updateScrollList()
    end,
    updateScrollList = function(self)
      if not (self.initScrolling) then
        return 
      end
      if self.scrollAmount < 0 then
        self.scrollAmount = 0
      end
      if self.scrollAmount > 1 then
        self.scrollAmount = 1
      end
      if self.totalHeight < self.visibleAmount then
        self.scrollAmount = 0
      end
      for i = 1, self.itemCount do
        local button = self.innerFrame:findFirstChild(tostring(i))
        if button ~= nil then
          button.Position = UDim2.new(0, 0, 0, ((i - 1) * self.itemHeight) - (self.scrollAmount * self.scrollHeight))
        end
      end
      self.scrollBar.Size = UDim2.new(1, 0, self.scrollBarHeight, 0)
      self.scrollBar.Position = UDim2.new(0, 0, (1 - self.scrollBarHeight) * self.scrollAmount, 0)
    end,
    cleanUp = function(self)
      return self.baseFrame:Destroy()
    end
  }
  _base_0.__index = _base_0
  if _parent_0 then
    setmetatable(_base_0, _parent_0.__base)
  end
  local _class_0 = setmetatable({
    __init = function(self, baseFrame, itemList, itemButton, onClickFunction)
      self.baseFrame = baseFrame
      self.itemCount = #itemList
      self.scrollAmount = 0
      self.itemHeight = itemButton.Size.Y.Offset
      self.scrollBarWidth = 0.1
      self.scrollButtonHeight = 0.08
      self:calculateScrolling()
      itemButton.Size = UDim2.new(1, 0, 0, self.itemHeight)
      do
        local _with_0 = Instance.new("Frame", self.baseFrame)
        _with_0.Name = "InnerFrame"
        _with_0.Position = UDim2.new(0, 0, 0, 0)
        _with_0.Size = UDim2.new(1 - self.scrollBarWidth, 0, 1, 0)
        _with_0.BackgroundTransparency = 0
        _with_0.BackgroundColor3 = Color3.new(0, 0, 0)
        _with_0.BorderColor3 = Color3.new(1, 1, 1)
        _with_0.ClipsDescendants = true
        self.innerFrame = _with_0
      end
      do
        local _with_0 = Instance.new("Frame", self.baseFrame)
        _with_0.Name = "ScrollFrame"
        _with_0.Position = UDim2.new(1 - self.scrollBarWidth, 0, 0, 0)
        _with_0.Size = UDim2.new(self.scrollBarWidth, 0, 1, 0)
        _with_0.BackgroundTransparency = 0
        _with_0.BackgroundColor3 = Color3.new(0, 0, 0)
        _with_0.BorderColor3 = Color3.new(1, 1, 1)
        _with_0.ClipsDescendants = true
        self.scrollFrame = _with_0
      end
      for i = 1, #itemList do
        local item = itemList[i]
        local button
        do
          local _with_0 = itemButton:Clone()
          _with_0.Text = item
          _with_0.Name = i
          _with_0.Parent = self.innerFrame
          _with_0.MouseButton1Click:connect(function()
            return onClickFunction(i, itemList[i], button)
          end)
          _with_0.Position = UDim2.new(0, 0, 0, (i - 1) * self.itemHeight)
          button = _with_0
        end
      end
      do
        local _with_0 = Instance.new("TextButton", self.scrollFrame)
        _with_0.Size = UDim2.new(1, 0, self.scrollButtonHeight, 0)
        _with_0.Position = UDim2.new(0, 0, 0, 0)
        _with_0.Text = "/\\"
        _with_0.Name = "ButtonUp"
        _with_0.MouseButton1Click:connect(function()
          if self.totalHeight <= self.visibleAmount then
            return 
          end
          self.scrollAmount = self.scrollAmount - self.scrollSpeed
          return self:updateScrollList()
        end)
        self.buttonUp = _with_0
      end
      do
        local _with_0 = Instance.new("TextButton", self.scrollFrame)
        _with_0.Size = UDim2.new(1, 0, self.scrollButtonHeight, 0)
        _with_0.Position = UDim2.new(0, 0, 1 - self.scrollButtonHeight, 0)
        _with_0.Text = "\\/"
        _with_0.Name = "ButtonDown"
        _with_0.MouseButton1Click:connect(function()
          if self.totalHeight <= self.visibleAmount then
            return 
          end
          self.scrollAmount = self.scrollAmount + self.scrollSpeed
          return self:updateScrollList()
        end)
        self.buttonDown = _with_0
      end
      do
        local _with_0 = Instance.new("Frame", self.scrollFrame)
        _with_0.Name = "ScrollBarFrame"
        _with_0.Size = UDim2.new(1, 0, 1 - (self.scrollButtonHeight * 2), 0)
        _with_0.Position = UDim2.new(0, 0, self.scrollButtonHeight, 0)
        _with_0.BackgroundTransparency = 0
        _with_0.BackgroundColor3 = Color3.new(0, 0, 0)
        _with_0.BorderColor3 = Color3.new(1, 1, 1)
        _with_0.ClipsDescendants = true
        self.scrollBarFrame = _with_0
      end
      local scrollBarDragging = false
      do
        local _with_0 = Instance.new("TextButton", self.scrollBarFrame)
        _with_0.Name = "ScrollBar"
        _with_0.Size = UDim2.new(1, 0, self.scrollBarHeight, 0)
        _with_0.Position = UDim2.new(0, 0, 0, 0)
        _with_0.BorderColor3 = Color3.new(1, 1, 1)
        _with_0.Text = "_\n_\n_"
        _with_0.TextColor3 = rgbColour(128, 128, 128)
        _with_0.TextStrokeTransparency = 0
        _with_0.Font = "ArialBold"
        _with_0.FontSize = "Size12"
        _with_0.TextStrokeColor3 = rgbColour(100, 100, 100)
        local prevY = 0
        _with_0.MouseButton1Down:connect(function(x, y)
          if not (self.totalHeight > self.visibleAmount) then
            return 
          end
          prevY = y
          scrollBarDragging = true
          return self:updateScrollList()
        end)
        _with_0.MouseButton1Up:connect(function()
          if not (self.totalHeight > self.visibleAmount) then
            return 
          end
          scrollBarDragging = false
          return self:updateScrollList()
        end)
        local mouse = game.Players.LocalPlayer:GetMouse()
        mouse.Move:connect(function()
          if not (scrollBarDragging and self.totalHeight > self.visibleAmount) then
            return 
          end
          local deltaY = mouse.Y - prevY
          local scaleDeltaY = deltaY / (self.scrollBarFrame.AbsoluteSize.Y - self.scrollBar.AbsoluteSize.Y)
          self.scrollAmount = self.scrollAmount + scaleDeltaY
          prevY = mouse.Y
          return self:updateScrollList()
        end)
        mouse.Button1Up:connect(function()
          scrollBarDragging = false
          return self:updateScrollList()
        end)
        self.scrollBar = _with_0
      end
      baseFrame.Changed:connect((function()
        local _base_1 = self
        local _fn_0 = _base_1.calculateScrolling
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
      self.initScrolling = true
    end,
    __base = _base_0,
    __name = "ScrollingFrame",
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
  if _parent_0 and _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  _G.ScrollingFrame = _class_0
  return _class_0
end
