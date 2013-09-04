wait(2)
local allPlanes = workspace.Planes
local getAllPlaneNames
getAllPlaneNames = function()
  return (function()
    local _accum_0 = { }
    local _len_0 = 1
    local _list_0 = allPlanes:GetChildren()
    for _index_0 = 1, #_list_0 do
      local plane = _list_0[_index_0]
      _accum_0[_len_0] = plane.Name
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)()
end
_G.getAllPlaneNames = getAllPlaneNames
_G.planeManagerLoaded = true
