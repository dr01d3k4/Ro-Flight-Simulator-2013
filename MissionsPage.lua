while not (_G.loadedMenu and _G.Page) do
  wait(0.1)
end
local setCurrentMenuPage = _G.setCurrentMenuPage
do
  local _parent_0 = _G.Page
  local _base_0 = {
    initialize = function(self)
      if self.initialized or self.cleanedUp or self.tweening then
        return 
      end
      self.initialized = true
      self:cleanUp()
      return setCurrentMenuPage(_G.MainMenuPage)
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
    __init = function(self, parent)
      return _parent_0.__init(self, "Missions", parent)
    end,
    __base = _base_0,
    __name = "MissionsPage",
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
  _G.MissionsPage = _class_0
  return _class_0
end
