wait 2
allPlanes = workspace.Planes

getAllPlaneNames = -> [plane.Name for plane in *allPlanes\GetChildren!]
_G.getAllPlaneNames = getAllPlaneNames

_G.planeManagerLoaded = true