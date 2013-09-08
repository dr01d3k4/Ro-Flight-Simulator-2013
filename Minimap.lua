local rfsScale = 1 / 20
local makeMinimap
makeMinimap = function(model, scale, baseCFrame)
  if baseCFrame == nil then
    baseCFrame = CFrame.new(0, 30, 0)
  end
  assert(model:IsA("Model"), "Minimap needs to be of a model")
  local minimapModel
  do
    local _with_0 = Instance.new("Model", workspace)
    _with_0.Name = model.Name
    minimapModel = _with_0
  end
  local makeMini
  makeMini = function(toMini, miniModel)
    local _list_0 = toMini:GetChildren()
    for _index_0 = 1, #_list_0 do
      local _continue_0 = false
      repeat
        local obj = _list_0[_index_0]
        wait()
        if obj:IsA("BasePart") then
          local rep
          if obj:IsA("WedgePart") then
            rep = Instance.new("WedgePart")
          elseif obj:IsA("CornerWedgePart") then
            print("Can't minimap corner wedges")
            _continue_0 = true
            break
          else
            rep = Instance.new("Part")
          end
          do
            local _with_0 = rep
            if not (rep:IsA("CornerWedgePart")) then
              _with_0.FormFactor = "Custom"
            end
            _with_0.Size = obj.Size * scale
            _with_0.Transparency = obj.Transparency
            _with_0.Reflectance = obj.Reflectance
            _with_0.BrickColor = obj.BrickColor
            _with_0.Anchored = true
            _with_0.CanCollide = false
            _with_0.Name = obj.Name
          end
          local _list_1 = {
            "Top",
            "Bottom",
            "Left",
            "Right",
            "Front",
            "Back"
          }
          for _index_1 = 1, #_list_1 do
            local surface = _list_1[_index_1]
            rep[surface .. "Surface"] = obj[surface .. "Surface"]
          end
          local objMesh
          local _list_2 = obj:GetChildren()
          for _index_1 = 1, #_list_2 do
            local subObj = _list_2[_index_1]
            if subObj:IsA("Decal") or subObj.ClassName:match("Value$") then
              subObj:Clone().Parent = rep
            elseif subObj.ClassName:match("Mesh$") then
              objMesh = subObj
            end
          end
          if objMesh then
            local mesh = objMesh:Clone()
            if objMesh:IsA("SpecialMesh") and objMesh.MeshType == "FileMesh" then
              mesh.Scale = objMesh.Scale * scale
            else
              mesh.Scale = objMesh.Scale * obj.Size * scale / rep.Size
            end
            mesh.Offset = objMesh.Offset * scale
            mesh.Parent = rep
          else
            local mesh
            if rep:IsA("Part") then
              if rep.Shape == "Ball" then
                do
                  local _with_0 = Instance.new("SpecialMesh")
                  _with_0.MeshType = "Sphere"
                  mesh = _with_0
                end
              elseif rep.Shape == "Cylinder" then
                mesh = Instance.new("CylinderMesh")
              else
                mesh = Instance.new("BlockMesh")
              end
            elseif rep:IsA("WedgePart") then
              do
                local _with_0 = Instance.new("SpecialMesh")
                _with_0.MeshType = "Wedge"
                mesh = _with_0
              end
            end
            if mesh then
              mesh.Scale = obj.Size * scale / rep.Size
              mesh.Parent = rep
            end
          end
          rep.CFrame = baseCFrame:toWorldSpace(obj.CFrame + obj.Position * (scale - 1))
          rep.Parent = miniModel
        elseif obj:IsA("Script") or obj.ClassName:match("Value$") then
          obj:Clone().Parent = par
        elseif obj:IsA("Model") then
          local newModel
          do
            local _with_0 = Instance.new("Model", miniModel)
            _with_0.Name = obj.Name
            newModel = _with_0
          end
          makeMini(obj, newModel)
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
  end
  return makeMini(model, minimapModel)
end
return makeMinimap(workspace.Planes["Robin DR400"], rfsScale)
