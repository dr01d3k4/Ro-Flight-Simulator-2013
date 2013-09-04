while not (_G.loadedMenu and _G.Page and _G.ScrollingFrame and _G.planeManagerLoaded) do
  wait(0.1)
end
local tweenTime = _G.tweenTime
do
  local _parent_0 = _G.Page
  local _base_0 = {
    initialize = function(self)
      if self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.initialized = true
    end,
    tweenIn = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      self.background.Size = UDim2.new(0, 0, 1, 0)
      self.background:TweenSize(UDim2.new(1, 0, 1, 0), "In", "Quad", tweenTime, true)
      wait(tweenTime)
      self.tweening = false
    end,
    tweenOut = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.tweening = true
      self.background:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", tweenTime, true)
      wait(tweenTime)
      self.tweening = false
    end,
    cleanUp = function(self)
      if not self.initialized or self.cleanedUp or self.tweening then
        return 
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
      self.background.Name = planeName
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
  if _parent_0 and _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  _G.LiverySelectPage = _class_0
  return _class_0
end
