wait(1)
while not game.Players.LocalPlayer do
  wait(0.6)
end
local player = game.Players.LocalPlayer
while not player.Character and not player.Character:findFirstChild("Head") do
  wait(0.1)
end
local character = player.Character
local head = character.Head
local playerGui = player.PlayerGui
local camera = workspace.CurrentCamera
_G.camera = camera
_G.head = head
local menuScreenGui
do
  local _with_0 = Instance.new("ScreenGui", playerGui)
  _with_0.Name = "MenuScreenGui"
  menuScreenGui = _with_0
end
_G.menuScreenGui = menuScreenGui
local tweenTime = 0.4
_G.tweenTime = tweenTime
_G.tweenExtra = 15
local rgbColour
rgbColour = function(r, g, b)
  return Color3.new(r / 255, g / 255, b / 255)
end
_G.rgbColour = rgbColour
local backgroundWidth = 0.18
local menuBackgroundFrame
do
  local _with_0 = Instance.new("Frame", menuScreenGui)
  _with_0.Name = "Background"
  _with_0.Size = UDim2.new(0, 0, 1, 0)
  _with_0.Position = UDim2.new(0, 0, 0, 0)
  _with_0.BackgroundColor3 = rgbColour(32, 32, 32)
  _with_0.BackgroundTransparency = 0.3
  menuBackgroundFrame = _with_0
end
_G.menuBackgroundFrame = menuBackgroundFrame
do
  local _with_0 = menuBackgroundFrame:Clone()
  _with_0.Size = UDim2.new(backgroundWidth, 0, 1, 0)
  _G.defaultBackgroundFrame = _with_0
end
local setCurrentMenuPage
do
  local currentPage = nil
  local waitForPageCleanUp
  waitForPageCleanUp = function(page)
    if not page or page.cleanedUp then
      return 
    end
    while not page.cleanedUp do
      page:cleanUp()
      if not page.cleanedUp then
        wait(0.1)
      end
    end
  end
  setCurrentMenuPage = function(pageClass)
    if currentPage then
      currentPage:tweenOut()
      waitForPageCleanUp(currentPage)
    end
    local _list_0 = menuBackgroundFrame:GetChildren()
    for _index_0 = 1, #_list_0 do
      local child = _list_0[_index_0]
      pcall(function()
        return child:Destroy()
      end)
    end
    do
      local _with_0 = pageClass()
      _with_0:initialize()
      _with_0:tweenIn()
      currentPage = _with_0
    end
  end
  _G.waitForPageCleanUp = waitForPageCleanUp
  _G.setCurrentMenuPage = setCurrentMenuPage
end
do
  _G.createTitle = function(text, parent, size, position)
    if position == nil then
      position = UDim2.new(0, 0, 0, 0)
    end
    do
      local _with_0 = Instance.new("TextLabel", parent)
      _with_0.Name = "Title"
      _with_0.Size = size
      _with_0.Position = position
      _with_0.BackgroundTransparency = 1
      _with_0.Font = "SourceSansBold"
      _with_0.Text = text
      _with_0.TextScaled = true
      _with_0.TextWrapped = true
      _with_0.TextColor3 = rgbColour(255, 255, 255)
      _with_0.TextYAlignment = "Top"
      return _with_0
    end
  end
end
local createButton
do
  local buttonBorder = rgbColour(170, 0, 0)
  local buttonHoverBorder = rgbColour(120, 0, 0)
  local buttonHoverOffset = 2
  createButton = function(name, text, parent, size, position, enter, leave, click)
    local button = Instance.new("TextButton", parent)
    do
      local _with_0 = button
      _with_0.Name = name
      _with_0.Size = size
      _with_0.Position = position
      _with_0.BackgroundColor3 = rgbColour(0, 0, 0)
      _with_0.BackgroundTransparency = 0
      _with_0.BorderColor3 = buttonBorder
      _with_0.BorderSizePixel = 1
      _with_0.Font = "SourceSans"
      _with_0.Text = text
      _with_0.TextColor3 = rgbColour(255, 255, 255)
      _with_0.TextScaled = true
      _with_0.TextWrapped = true
      _with_0.TextXAlignment = "Left"
      _with_0.MouseEnter:connect(function()
        if enter(button) then
          _with_0.BorderColor3 = buttonHoverBorder
          _with_0.BorderSizePixel = 2
          _with_0.Position = UDim2.new(position.X.Scale, position.X.Offset + buttonHoverOffset, position.Y.Scale, position.Y.Offset + buttonHoverOffset)
        end
      end)
      _with_0.MouseLeave:connect(function()
        if leave(button) then
          _with_0.BorderColor3 = buttonBorder
          _with_0.BorderSizePixel = 1
          _with_0.Position = position
        end
      end)
      _with_0.MouseButton1Click:connect(function()
        return click(button)
      end)
      return _with_0
    end
  end
  _G.createButton = createButton
end
do
  _G.createBackButton = function(name, text, parent, size, position, enter, leave, click)
    local enterFunc
    enterFunc = function(button)
      if enter(button) then
        button.Text = "< " .. text
        return true
      else
        return false
      end
    end
    local leaveFunc
    leaveFunc = function(button)
      if leave(button) then
        button.Text = text
        return true
      else
        return false
      end
    end
    do
      local _with_0 = createButton(name, text, parent, size, position, enterFunc, leaveFunc, click)
      _with_0.TextXAlignment = "Right"
      return _with_0
    end
  end
end
do
  local weldPart
  weldPart = function(part, base)
    do
      local _with_0 = Instance.new("Weld", base)
      _with_0.Part0 = base
      _with_0.Part1 = part
      _with_0.C0 = base.CFrame:inverse() * CFrame.new(base.Position)
      _with_0.C1 = part.CFrame:inverse() * CFrame.new(base.Position)
      return _with_0
    end
  end
  local weldModel
  weldModel = function(model, base)
    local _list_0 = model:GetChildren()
    for _index_0 = 1, #_list_0 do
      local _continue_0 = false
      repeat
        local child = _list_0[_index_0]
        if child == base then
          _continue_0 = true
          break
        end
        if child:IsA("BasePart") then
          weldPart(child, base)
        elseif child:IsA("Model") then
          weldModel(child, base)
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
  end
  _G.weldModel = weldModel
  local unanchorModel
  unanchorModel = function(model, base)
    local _list_0 = model:GetChildren()
    for _index_0 = 1, #_list_0 do
      local _continue_0 = false
      repeat
        local child = _list_0[_index_0]
        if child == base then
          _continue_0 = true
          break
        end
        if child:IsA("BasePart") then
          child.Anchored = false
        elseif child:IsA("Model") then
          unanchorModel(child, base)
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
  end
  _G.unanchorModel = unanchorModel
end
_G.loadedMenu = true
local loadPlayer
loadPlayer = function()
  head.Anchored = true
  camera.CameraSubject = head
  wait()
  camera.CameraType = "Attach"
  wait()
  camera.CameraType = "Track"
  camera.CameraSubject = head
  head.CanCollide = false
  while not character:findFirstChild("Torso") do
    wait(0.5)
  end
  local deleteThings
  deleteThings = function()
    local _list_0 = character:GetChildren()
    for _index_0 = 1, #_list_0 do
      local obj = _list_0[_index_0]
      if not (obj.Name == "Humanoid" or obj.Name == "Head" or obj.Name == "Torso") then
        obj:Destroy()
      end
    end
    if character:findFirstChild("Humanoid") then
      character.Humanoid:Destroy()
    end
    if character:findFirstChild("Torso") then
      character.Torso:Destroy()
    end
    local _list_1 = head:GetChildren()
    for _index_0 = 1, #_list_1 do
      local obj = _list_1[_index_0]
      local _ = (function()
        local _base_0 = obj
        local _fn_0 = _base_0.Destroy
        return function(...)
          return _fn_0(_base_0, ...)
        end
      end)()
    end
    if playerGui:findFirstChild("HealthGUI") then
      return playerGui.HealthGUI:Destroy()
    end
  end
  deleteThings()
  head.FormFactor = "Custom"
  head.Size = Vector3.new(0.2, 0.2, 0.2)
  Instance.new("BlockMesh", head).Scale = Vector3.new(0, 0, 0)
  head.BrickColor = BrickColor.new("Bright red")
  return player.DescendantAdded:connect(deleteThings)
end
loadPlayer()
while not _G.MainMenuPage do
  wait(0.5)
end
menuBackgroundFrame:TweenSize(UDim2.new(backgroundWidth, 0, 1, 0), "In", "Quad", tweenTime, true)
wait(tweenTime)
return setCurrentMenuPage(_G.MainMenuPage)
