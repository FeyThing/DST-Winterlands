local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local POLAR_COLOURCUBES = {
	day = "images/colour_cubes/snow_cc.tex",
	dusk = "images/colour_cubes/snowdusk_cc.tex",
	night = "images/colour_cubes/night04_cc.tex",
	full_moon = "images/colour_cubes/purple_moon_cc.tex",
}

local POLAR_COLOURCUBES_CONVERT = {
	["images/colour_cubes/day05_cc.tex"] = "day",
	["images/colour_cubes/dusk03_cc.tex"] = "dusk",
	["images/colour_cubes/night03_cc.tex"] = "night",
	
	["images/colour_cubes/spring_day_cc.tex"] = "day",
	["images/colour_cubes/spring_dusk_cc.tex"] = "dusk",
	["images/colour_cubes/spring_dusk_cc.tex"] = "night",
	
	["images/colour_cubes/summer_day_cc.tex"] = "day",
	["images/colour_cubes/summer_dusk_cc.tex"] = "dusk",
	["images/colour_cubes/summer_night_cc.tex"] = "night",
}

local function OnPolarChanged(inst, data, ...)
	local self = inst.components.playervision
	local in_polar = IsInPolar(inst, 20) -- data and data.tags and table.contains(data.tags, "polararea")
	
	if self and self.polarvision ~= in_polar then
		self.polarvision = in_polar
		inst:PushEvent("setinpolar", in_polar)
	end
end

ENV.AddComponentPostInit("playervision", function(self)
	function self:SetPolarVision(enabled)
		if not self.ghostvision and not self.nightmarevision and not self.nightvision and not self.forcenightvision then
			local cctable = enabled and {
				day = "images/colour_cubes/snow_cc.tex",
				dusk = "images/colour_cubes/snowdusk_cc.tex",
				night = "images/colour_cubes/night04_cc.tex",
				full_moon = "images/colour_cubes/purple_moon_cc.tex"
			} or nil
			
			self.inst:PushEvent("ccoverrides", cctable)
		end
	end
	
	self.inst:ListenForEvent("setinpolar", function(src, enabled) self:SetPolarVision(enabled) end)
	
	self.inst:DoTaskInTime(1, function()
		self.polarvision = nil
		self._polarupdate = self.inst:DoPeriodicTask(1, OnPolarChanged)
	end)
end)

ENV.AddModShadersInit(function()
	local PostProcessor__index = getmetatable(PostProcessor).__index

	local OldSetColourCubeData = PostProcessor__index.SetColourCubeData
	PostProcessor__index.SetColourCubeData = function(pp, index, src, dest, ...)
		
		local polar_convert = POLAR_COLOURCUBES_CONVERT[dest]
		if ThePlayer and IsInPolar(ThePlayer, 20) and polar_convert then
			dest = POLAR_COLOURCUBES[polar_convert] or dest
		end
		
		OldSetColourCubeData(pp, index, src, dest, ...)
	end
end)