local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Weather = require("components/weather")

local SNOWLEVEL_FADE_MAX_DIST = 60
local SNOWLEVEL_FADE_MIN_DIST = 40

local OldWeather_ctor = Weather._ctor
Weather._ctor = function(self, ...)
	OldWeather_ctor(self, ...)
	
	local function GetPolarSnowSoundMult()
		if ThePlayer and ThePlayer.player_classified then
			local x, y, z = ThePlayer.Transform:GetWorldPosition()
			local snow_level = ThePlayer.player_classified.polarsnowlevel:value() or 0
			
			local mult = 1 - (snow_level / 0.5)
			mult = math.clamp(mult, 0, 1)
			
			return mult, IsUnderIceCaveAtXZ(x, z)
		end
		
		return 1, false
	end
	
	-- Rain fades when approching the Winterlands, but slowly comes back when melting over
	
	local StopAmbientRainSound = PolarUpvalue(self.OnUpdate, "StopAmbientRainSound")
	
	local OldStartAmbientRainSound = PolarUpvalue(self.OnUpdate, "StartAmbientRainSound")
	local function StartAmbientRainSound(intensity, ...)
		local mult, icecave = GetPolarSnowSoundMult()
		
		if mult <= 0 and StopAmbientRainSound then
			StopAmbientRainSound()
			return
		elseif mult < 1 or icecave then
			intensity = intensity * mult * (icecave and 0.2 or 1)
		end
		
		return OldStartAmbientRainSound and OldStartAmbientRainSound(intensity, ...)
	end
	
	local StopTreeRainSound = PolarUpvalue(self.OnUpdate, "StopTreeRainSound")
	
	local OldStartTreeRainSound = PolarUpvalue(self.OnUpdate, "StartTreeRainSound")
	local function StartTreeRainSound(intensity, ...)
		local mult, icecave = GetPolarSnowSoundMult()
		
		if mult <= 0 and StopTreeRainSound then
			StopTreeRainSound()
			return
		elseif mult < 1 or icecave then
			intensity = intensity * mult * (icecave and 0.2 or 1)
		end
		
		return OldStartTreeRainSound and OldStartTreeRainSound(intensity, ...)
	end
	
	PolarUpvalue(self.OnUpdate, "StartAmbientRainSound", StartAmbientRainSound)
	PolarUpvalue(self.OnUpdate, "StartTreeRainSound", StartTreeRainSound)
	
	if TheNet:IsDedicated() then
		return
	end
	
	--	Snow overlay is hidden in Winterlands
	
	local OldSetGroundOverlay = PolarUpvalue(self.OnUpdate, "SetGroundOverlay")
	local function SetGroundOverlay(overlay, level, ...)
		if ThePlayer then
			local x, y, z = ThePlayer.Transform:GetWorldPosition()
			local in_polar, dist = GetClosestPolarTileToPoint(x, y, z, SNOWLEVEL_FADE_MAX_DIST)
			
			if in_polar and overlay then
				if overlay.texture == "levels/textures/snow.tex" then
					-- Should overlay return when melting over ? Could look nice...
					
					local fade = math.clamp((dist - SNOWLEVEL_FADE_MIN_DIST) / (SNOWLEVEL_FADE_MAX_DIST - SNOWLEVEL_FADE_MIN_DIST), 0, 1)
					level = level * fade
				end
			end
		end
		
		return OldSetGroundOverlay and OldSetGroundOverlay(overlay, level, ...)
	end
	
	PolarUpvalue(self.OnUpdate, "SetGroundOverlay", SetGroundOverlay)
end