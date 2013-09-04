wait(1)
while not game.Players.LocalPlayer do
  wait(0.6)
end
local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
local menuScreenGui
do
  local _with_0 = Instance.new("ScreenGui", playerGui)
  _with_0.Name = "MenuScreenGui"
  menuScreenGui = _with_0
end
_G.menuScreenGui = menuScreenGui
local tweenTime = 0.6
_G.tweenTime = tweenTime
_G.tweenExtra = 20
local rgbColour
rgbColour = function(r, g, b)
  return Color3.new(r / 255, g / 255, b / 255)
end
_G.rgbColour = rgbColour
local backgroundWidth = 0.2
local menuBackgroundFrame
do
  local _with_0 = Instance.new("Frame", menuScreenGui)
  _with_0.Name = "Background"
  _with_0.Size = UDim2.new(0, 0, 1, 0)
  _with_0.BackgroundColor3 = rgbColour(32, 32, 32)
  _with_0.BackgroundTransparency = 0.3
  menuBackgroundFrame = _with_0
end
_G.menuBackgroundFrame = menuBackgroundFrame
local setCurrentMenuPage
do
  local currentPage = nil
  setCurrentMenuPage = function(pageClass)
    if currentPage then
      currentPage:tweenOut()
      currentPage:cleanUp()
    end
    do
      local _with_0 = pageClass(menuBackgroundFrame)
      _with_0:initialize()
      _with_0:tweenIn()
      currentPage = _with_0
    end
  end
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
_G.loadedMenu = true
while not _G.MainMenuPage do
  wait(0.5)
end
menuBackgroundFrame:TweenSize(UDim2.new(backgroundWidth, 0, 1, 0), "In", "Quad", tweenTime, true)
wait(tweenTime)
return setCurrentMenuPage(_G.MainMenuPage)
