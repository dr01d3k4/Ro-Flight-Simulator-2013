wait 2

planeManager = { }

planeManager.allPlanes = workspace.Planes

planeManager.getAllPlaneNames = -> [plane.Name for plane in *planeManager.allPlanes\GetChildren!]

planeManager.getPlaneFromName = (name) -> planeManager.allPlanes\findFirstChild name

-- Weld and unanchor model
do
	weldPart = (part, base) ->
		with Instance.new "Weld", base
			.Part0 = base
			.Part1 = part
			.C0 = base.CFrame\inverse! * CFrame.new base.Position
			.C1 = part.CFrame\inverse! * CFrame.new base.Position

	planeManager.weldPlane = (plane, base = plane\findFirstChild "Engine") ->
		for child in *plane\GetChildren!
			continue if child == base
			if child\IsA "BasePart"
				weldPart child, base
			elseif child\IsA "Model"
				planeManager.weldPlane child, base

	planeManager.unanchorPlane = (plane, base = plane\findFirstChild "Engine") ->
		for child in *plane\GetChildren!
			continue if child == base
			if child\IsA "BasePart"
				child.Anchored = false
			elseif child\IsA "Model"
				planeManager.unanchorPlane child, base

_G.planeManager = planeManager