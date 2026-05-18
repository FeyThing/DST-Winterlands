local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local WorldTemperature = require("components/worldtemperature")
local OldWorldTemperature_ctor = WorldTemperature._ctor

local SUMMERBLOOM_FADE_MAX_DIST = 30
local SUMMERBLOOM_FADE_MIN_DIST = 10

-- Removing the flashing sunlight from summer on the Winterlands...

WorldTemperature._ctor = function(self, ...)
	OldWorldTemperature_ctor(self, ...)
	
	local UpdateSummerBloom = PolarUpvalue(self.OnUpdate, "UpdateSummerBloom")
	
	local OldCalculateSummerBloom = PolarUpvalue(UpdateSummerBloom, "CalculateSummerBloom")
	local function UpdateSummerBloom(dt, ...)
		local bloom = OldCalculateSummerBloom and OldCalculateSummerBloom(dt, ...) or 0 -- my_eyes_spongebob.gif
		
		if ThePlayer then
			local x, y, z = ThePlayer.Transform:GetWorldPosition()
			local in_polar, dist = GetClosestPolarTileToPoint(x, y, z, SUMMERBLOOM_FADE_MAX_DIST)
			
			if in_polar then
				local fade = math.clamp((dist - SUMMERBLOOM_FADE_MIN_DIST) / (SUMMERBLOOM_FADE_MAX_DIST - SUMMERBLOOM_FADE_MIN_DIST), 0, 1)
				bloom = bloom * fade
			end
		end
		
		return bloom
	end
	
	PolarUpvalue(self.OnUpdate, "UpdateSummerBloom", UpdateSummerBloom)
end