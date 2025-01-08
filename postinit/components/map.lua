local ENV = env
GLOBAL.setfenv(1, GLOBAL)

function Map:IsPolarSnowAtPoint(x, y, z, snow_only)
	return self:GetTileAtPoint(x, y, z) == WORLD_TILES.POLAR_SNOW
end

local SNOWBLOCKER_TAGS = {"snowblocker", "fire", "HASHEATER"}
local SNOWBLOCKER_NOT_TAGS = {"INLIMBO", "blueflame", "fx"} -- Don't include inventory fires like torch cause that would make walking trough snow too trivial
local SNOWBLOCKER_DIST = 10

function Map:IsPolarSnowBlocked(x, y, z, range_mod)
	local ents = TheSim:FindEntities(x, y, z, SNOWBLOCKER_DIST, nil, SNOWBLOCKER_NOT_TAGS, SNOWBLOCKER_TAGS)
	
	for i, v in ipairs(ents) do
		local ent_range = (v:HasTag("fire") and 8)
			or (v._heated and 10) -- Winona heated spotlights...
			or 0
		
		-- Mostly use range_mod for forgiveness, snowwaves might not display due to the grid pattern while there can be microscopic gaps between blockers
		local range = math.max(v._snowblockrange and v._snowblockrange:value() or 0, ent_range) + (range_mod or 0)
		local dist = v:GetDistanceSqToPoint(x, y, z)
		
		if range > 0 and dist <= range * range then
			return true
		end
	end
	
	return false
end

--

require("components/map")

local OldIsOceanIceAtPoint = Map.IsOceanIceAtPoint
function Map:IsOceanIceAtPoint(x, y, z, ...)
	return OldIsOceanIceAtPoint(self, x, y, z, ...) or self:GetTileAtPoint(x, y, z) == WORLD_TILES.POLAR_ICE
end