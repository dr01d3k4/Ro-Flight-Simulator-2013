while not (_G.loadedMenu and _G.Page and _G.ScrollingFrame and _G.planeManagerLoaded) do
  wait(0.1)
end
local tweenTime, createTitle, getPlaneFromName, rgbColour, weldModel, unanchorModel, camera, head = _G.tweenTime, _G.createTitle, _G.getPlaneFromName, _G.rgbColour, _G.weldModel, _G.unanchorModel, _G.camera, _G.head
local max = math.max
local ignoredSections = {
  "NoColour",
  "GlassWindow"
}
local isIgnoredSection
isIgnoredSection = function(section)
  local _list_0 = ignoredSections
  for _index_0 = 1, #_list_0 do
    local ignored = _list_0[_index_0]
    if section == ignored then
      return true
    end
  end
  return false
end
do
  local titleHeight, planeNameHeight, colourSelectorLeft
  local _parent_0 = _G.Page
  local _base_0 = {
    initialize = function(self)
      if self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      if self.title then
        self.title:Destroy()
      end
      if self.planeNameLabel then
        self.planeNameLabel:Destroy()
      end
      local _list_0 = self.sectionColourTexts
      for _index_0 = 1, #_list_0 do
        local section = _list_0[_index_0]
        section:Destroy()
      end
      self.title = createTitle("Choose Livery", self.background, UDim2.new(1, 0, titleHeight, 0))
      self.planeNameLabel = createTitle(self.planeName, self.background, UDim2.new(1, 0, planeNameHeight, 0), UDim2.new(0, 0, titleHeight, 0))
      self.planeNameLabel.Name = "PlaneNameTitle"
      self.planeModel = getPlaneFromName(self.planeName):Clone()
      self.planeModel.Parent = camera
      local engine = self.planeModel.Engine
      engine.Anchored = true
      local planePreviewBase = self.parentPage.planePreviewBase
      local baseSize = max(engine.Size.x, engine.Size.z) * 2
      if baseSize < self.parentPage.baseSize.x then
        baseSize = self.parentPage.baseSize.x
      end
      planePreviewBase.Size = Vector3.new(baseSize, planePreviewBase.Size.y, baseSize)
      weldModel(self.planeModel, engine)
      unanchorModel(self.planeModel, engine)
      engine.Anchored = false
      engine.Transparency = 1
      engine.CFrame = CFrame.new(planePreviewBase.Position + Vector3.new(0, self.planeModel.Engine.Size.y * 2, 0))
      head.CFrame = engine.CFrame
      camera.CameraType = "Watch"
      local sectionNames = (function()
        local _accum_0 = { }
        local _len_0 = 1
        local _list_1 = self.planeModel:GetChildren()
        for _index_0 = 1, #_list_1 do
          local section = _list_1[_index_0]
          if section:IsA("Model") and not isIgnoredSection(section.Name) then
            _accum_0[_len_0] = section.Name
            _len_0 = _len_0 + 1
          end
        end
        return _accum_0
      end)()
      table.sort(sectionNames)
      local colourSelectorHeight = 0.03
      local colourSelectorSpacing = 0.015
      local colourSelectorLeftWidth = 0.4
      local yPos = titleHeight + planeNameHeight + colourSelectorSpacing
      self.sectionColourTexts = { }
      local _list_1 = sectionNames
      for _index_0 = 1, #_list_1 do
        local _continue_0 = false
        repeat
          local sectionName = _list_1[_index_0]
          local section = self.planeModel[sectionName]
          local colour = nil
          local _list_2 = section:GetChildren()
          for _index_1 = 1, #_list_2 do
            local part = _list_2[_index_1]
            if part:IsA("BasePart") then
              if not (colour) then
                colour = part.BrickColor
              end
              part.BrickColor = colour
            end
          end
          if not (colour) then
            _continue_0 = true
            break
          end
          local colourSelectorFrame
          do
            local _with_0 = Instance.new("Frame", self.background)
            _with_0.Name = yPos
            _with_0.Position = UDim2.new(colourSelectorLeft, 0, yPos, 0)
            _with_0.Size = UDim2.new(1 - (colourSelectorLeft * 2), 0, colourSelectorHeight, 0)
            _with_0.BackgroundTransparency = 1
            colourSelectorFrame = _with_0
          end
          do
            local _with_0 = Instance.new("TextLabel", colourSelectorFrame)
            _with_0.Name = sectionName
            _with_0.Text = sectionName .. ": "
            _with_0.Position = UDim2.new(0, 0, 0, 0)
            _with_0.Size = UDim2.new(colourSelectorLeftWidth, 0, 1, 0)
            _with_0.TextColor3 = rgbColour(255, 255, 255)
            _with_0.BackgroundTransparency = 1
            _with_0.Font = "SourceSansBold"
            _with_0.FontSize = "Size18"
            _with_0.TextXAlignment = "Right"
          end
          do
            local _with_0 = Instance.new("TextBox", colourSelectorFrame)
            _with_0.Name = sectionName .. "Pick"
            _with_0.Position = UDim2.new(colourSelectorLeftWidth, 0, 0, 0)
            _with_0.Size = UDim2.new(1 - colourSelectorLeftWidth, 0, 1, 0)
            _with_0.TextColor3 = colour.Color
            _with_0.BackgroundTransparency = 1
            _with_0.Font = "SourceSansBold"
            _with_0.FontSize = "Size18"
            _with_0.TextXAlignment = "Left"
            local setTextFromColour
            setTextFromColour = function()
              _with_0.Text = ("(%i, %i, %i)"):format(colour.r * 255, colour.g * 255, colour.b * 255)
              _with_0.TextColor3 = colour.Color
            end
            setTextFromColour()
            _with_0.FocusLost:connect(function()
              local textMatch = "^%(?(%d+)[%p%s]+(%d+)[%p%s]+(%d+)%)?$"
              if _with_0.Text:match(textMatch) then
                local r, g, b = _with_0.Text:match(textMatch)
                r, g, b = tonumber(r), tonumber(g), tonumber(b)
                if not r or not g or not b then
                  setTextFromColour()
                end
                local _list_3 = section:GetChildren()
                for _index_1 = 1, #_list_3 do
                  local part = _list_3[_index_1]
                  if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new(r / 255, g / 255, b / 255)
                    colour = part.BrickColor
                    local _list_4 = part:GetChildren()
                    for _index_2 = 1, #_list_4 do
                      local obj = _list_4[_index_2]
                      if obj.ClassName:match("Mesh$") then
                        obj.VertexColor = Vector3.new(colour.r, colour.g, colour.b)
                      end
                    end
                  end
                end
                return setTextFromColour()
              else
                return setTextFromColour()
              end
            end)
          end
          self.sectionColourTexts[#self.sectionColourTexts + 1] = colourSelectorFrame
          yPos = yPos + (colourSelectorHeight + colourSelectorSpacing)
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      self.initialized = true
    end,
    tweenIn = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      self.title.Visible = false
      self.title.Position = UDim2.new(0, 0, -titleHeight, 0)
      self.planeNameLabel.Visible = false
      self.planeNameLabel.Position = UDim2.new(0, 0, -planeNameHeight, 0)
      local _list_0 = self.sectionColourTexts
      for _index_0 = 1, #_list_0 do
        local section = _list_0[_index_0]
        section.Visible = false
        section.Position = UDim2.new(colourSelectorLeft, 0, -section.Size.Y.Scale, 0)
      end
      self.background.Size = UDim2.new(0, 0, 1, 0)
      self.background:TweenSize(UDim2.new(1, 0, 1, 0), "In", "Quad", tweenTime / 2, true)
      wait(tweenTime / 2)
      self.title.Visible = true
      self.title:TweenPosition(UDim2.new(0, 0, 0, 0), "In", "Quad", tweenTime / 2, true)
      wait(tweenTime / 4)
      self.planeNameLabel.Visible = true
      self.planeNameLabel:TweenPosition(UDim2.new(0, 0, titleHeight, 0), "In", "Quad", tweenTime / 2, true)
      wait(tweenTime / 4)
      for i = 1, #self.sectionColourTexts do
        local section = self.sectionColourTexts[i]
        section.Visible = true
        section:TweenPosition(UDim2.new(colourSelectorLeft, 0, tonumber(section.Name), 0), "In", "Quad", tweenTime / 2, true)
        wait(tweenTime / 4)
      end
      wait(tweenTime / 4)
      self.tweening = false
    end,
    tweenOut = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      for i = #self.sectionColourTexts, 1, -1 do
        local section = self.sectionColourTexts[i]
        section:TweenPosition(UDim2.new(colourSelectorLeft, 0, -section.Size.Y.Scale, 0), "Out", "Quad", tweenTime / 2, true)
        wait(tweenTime / 4)
      end
      self.planeNameLabel:TweenPosition(UDim2.new(0, 0, -planeNameHeight, 0), "Out", "Quad", tweenTime / 2, true)
      wait(tweenTime / 4)
      self.title:TweenPosition(UDim2.new(0, 0, -titleHeight, 0), "Out", "Quad", tweenTime / 2, true)
      wait(tweenTime / 2)
      self.planeNameLabel.Visible = false
      self.title.Visible = false
      self.background:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", tweenTime / 2, true)
      wait(tweenTime / 2)
      self.tweening = false
    end,
    cleanUp = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      if self.title then
        self.title:Destroy()
      end
      if self.planeNameLabel then
        self.planeNameLabel:Destroy()
      end
      local _list_0 = self.sectionColourTexts
      for _index_0 = 1, #_list_0 do
        local section = _list_0[_index_0]
        section:Destroy()
      end
      if self.planeModel then
        self.planeModel:Destroy()
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
    __init = function(self, parent, planeName)
      _parent_0.__init(self, "LiverySelect", parent)
      self.planeName = planeName
      self.title, self.planeNameLabel, self.sectionColourTexts = nil, nil, { }
    end,
    __base = _base_0,
    __name = "LiverySelectPage",
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
  planeNameHeight = 0.05
  colourSelectorLeft = 0.05
  if _parent_0 and _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  _G.LiverySelectPage = _class_0
  return _class_0
end
