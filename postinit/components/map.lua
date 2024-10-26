local ENV = env
GLOBAL.setfenv(1, GLOBAL)

function Map:IsPolarSnowAtPoint(x, y, z)
	return self:GetTileAtPoint(x, y, z) == WORLD_TILES.POLAR_SNOW -- TODO: also if in blizzard ?
end

local OldIsOceanIceAtPoint = Map.IsOceanIceAtPoint
function Map:IsOceanIceAtPoint(x, y, z, ...)
	return OldIsOceanIceAtPoint(x, y, z, ...) or self:GetTileAtPoint(x, y, z) == WORLD_TILES.POLAR_ICE
end