while not _G.loadedMenu do
  wait(0.1)
end
local menuScreenGui = _G.menuScreenGui
do
  local _parent_0 = nil
  local _base_0 = {
    initialize = function(self)
      if self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      print("Initializing page")
      self.initialized = true
    end,
    tweenIn = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      print("Tweening page in")
      self.tweening = false
    end,
    tweenOut = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      print("Tweening page out")
      self.tweening = false
    end,
    setChildPage = function(self, pageClass)
      if self.childPage then
        self.childPage:tweenOut()
        self.childPage:cleanUp()
      end
      do
        local _with_0 = pageClass(self.background)
        _with_0:initialize()
        _with_0:tweenIn()
        self.childPage = _with_0
      end
    end,
    cleanUp = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      if self.childPage then
        self.childPage:cleanUp()
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
    __init = function(self, name, parent)
      assert(menuScreenGui, "Attempt to create " .. tostring(name) .. " before creating menuScreenGui")
      if self.background then
        self.background:Destroy()
      end
      do
        local _with_0 = Instance.new("Frame", parent)
        _with_0.BackgroundTransparency = 1
        _with_0.Name = name
        _with_0.Size = UDim2.new(1, 0, 1, 0)
        _with_0.BackgroundTransparency = 1
        if parent == menuBackgroundFrame then
          _with_0.Position = UDim2.new(0, 0, 0, 0)
        else
          _with_0.Position = UDim2.new(1, 0, 0, 0)
        end
        self.background = _with_0
      end
      self.initialized = false
      self.cleanedUp = false
      self.tweening = false
      self.childPage = nil
    end,
    __base = _base_0,
    __name = "Page",
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
  _G.Page = _class_0
  return _class_0
end
