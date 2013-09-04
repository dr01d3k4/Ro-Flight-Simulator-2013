wait 2
allPlanes = workspace.Planes

getAllPlaneNames = -> [plane.Name for plane in *allPlanes\GetChildren!]
_G.getAllPlaneNames = getAllPlaneNames

getPlaneFromName = (name) -> allPlanes\findFirstChild name
_G.getPlaneFromName = getPlaneFromName

_G.planeManagerLoaded = true