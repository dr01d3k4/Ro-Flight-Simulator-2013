rfsScale = 1 / 20

makeMinimap = (model, scale, baseCFrame = CFrame.new 0, 30, 0) ->
	assert model\IsA("Model"), "Minimap needs to be of a model"

	minimapModel = with Instance.new "Model", workspace
		.Name = model.Name

	makeMini = (toMini, miniModel) ->
		for obj in *toMini\GetChildren!
			wait!
			if obj\IsA "BasePart"
				local rep
				if obj\IsA "WedgePart"
					rep = Instance.new "WedgePart"
				elseif obj\IsA "CornerWedgePart"
					print "Can't minimap corner wedges"
					continue
				else
					rep = Instance.new "Part"

				with rep
					.FormFactor = "Custom" unless rep\IsA "CornerWedgePart"
					.Size = obj.Size * scale
					.Transparency = obj.Transparency
					.Reflectance = obj.Reflectance
					.BrickColor = obj.BrickColor
					.Anchored = true
					.CanCollide = false
					.Name = obj.Name
				rep[surface.."Surface"] = obj[surface.."Surface"] for surface in *{"Top", "Bottom", "Left", "Right", "Front", "Back"}

				local objMesh
				for subObj in *obj\GetChildren!
					if subObj\IsA("Decal") or subObj.ClassName\match "Value$"
						subObj\Clone!.Parent = rep
					elseif subObj.ClassName\match "Mesh$"
						objMesh = subObj

				if objMesh
					mesh = objMesh\Clone!
					if objMesh\IsA("SpecialMesh") and objMesh.MeshType == "FileMesh"
						mesh.Scale = objMesh.Scale * scale
					else
						mesh.Scale = objMesh.Scale * obj.Size * scale / rep.Size

					mesh.Offset = objMesh.Offset * scale
					mesh.Parent = rep
				else
					local mesh
					if rep\IsA "Part"
						if rep.Shape == "Ball"
							mesh = with Instance.new "SpecialMesh"
								.MeshType = "Sphere"
						elseif rep.Shape == "Cylinder"
							mesh = Instance.new "CylinderMesh"
						else
							mesh = Instance.new "BlockMesh"

					elseif rep\IsA "WedgePart"
						mesh = with Instance.new "SpecialMesh"
							.MeshType = "Wedge"

					if mesh
						mesh.Scale = obj.Size * scale / rep.Size
						mesh.Parent = rep

				rep.CFrame = baseCFrame\toWorldSpace obj.CFrame + obj.Position * (scale - 1)
				rep.Parent = miniModel

			elseif obj\IsA("Script") or obj.ClassName\match "Value$"
				obj\Clone!.Parent = par

			elseif obj\IsA "Model"
				newModel = with Instance.new "Model", miniModel
					.Name = obj.Name
				makeMini obj, newModel

	makeMini model, minimapModel

makeMinimap workspace.Planes["Robin DR400"], rfsScale