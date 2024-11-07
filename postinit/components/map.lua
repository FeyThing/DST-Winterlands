local ENV = env
GLOBAL.setfenv(1, GLOBAL)

function Map:IsPolarSnowAtPoint(x, y, z, snow_only)
	return self:GetTileAtPoint(x, y, z) == WORLD_TILES.POLAR_SNOW -- TODO: also if in blizzard ?
end

local SNOWBLOCKER_TAGS = {"snowblocker"} -- removing snow with "fire" too could look super cool but torches would make snow slowdown a cake walk :thinking:
local SNOWBLOCKER_DIST = 10

function Map:IsPolarSnowBlocked(x, y, z)
	local ents = TheSim:FindEntities(x, y, z, SNOWBLOCKER_DIST, nil, nil, SNOWBLOCKER_TAGS)
	
	for i, v in ipairs(ents) do
		local range = v._snowblockrange and v._snowblockrange:value() or 2
		local dist = v:GetDistanceSqToPoint(x, y, z)
		
		return dist <= range * range
	end
	
	return false
end

local OldIsOceanIceAtPoint = Map.IsOceanIceAtPoint
function Map:IsOceanIceAtPoint(x, y, z, ...)
	return OldIsOceanIceAtPoint(x, y, z, ...) or self:GetTileAtPoint(x, y, z) == WORLD_TILES.POLAR_ICE
end