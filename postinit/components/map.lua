local ENV = env
GLOBAL.setfenv(1, GLOBAL)

function Map:IsPolarSnowAtPoint(x, y, z, snow_only)
	return self:GetTileAtPoint(x, y, z) == WORLD_TILES.POLAR_SNOW
end

local SNOWBLOCKER_TAGS = {"snowblocker", "fire", "HASHEATER"}
local SNOWBLOCKER_NOT_TAGS = {"INLIMBO"} -- Don't include inventory fires like torch cause that would make walking trough snow too trivial
local SNOWBLOCKER_DIST = 10

function Map:IsPolarSnowBlocked(x, y, z)
	local ents = TheSim:FindEntities(x, y, z, SNOWBLOCKER_DIST, nil, SNOWBLOCKER_NOT_TAGS, SNOWBLOCKER_TAGS)
	
	for i, v in ipairs(ents) do
		local ent_range = (v:HasTag("fire") and 6)
			or (v._heated and 10) -- Winona heated spotlights...
			or 0
		
		local range = math.max(v._snowblockrange and v._snowblockrange:value() or 2, ent_range)
		local dist = v:GetDistanceSqToPoint(x, y, z)
		
		if dist <= range * range then
			return true
		end
	end
	
	return false
end

local OldIsOceanIceAtPoint = Map.IsOceanIceAtPoint
function Map:IsOceanIceAtPoint(x, y, z, ...)
	return OldIsOceanIceAtPoint(x, y, z, ...) or self:GetTileAtPoint(x, y, z) == WORLD_TILES.POLAR_ICE
end