local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local POLAR_AMBIENT_SOUND = { -- TODO: new ambiences 
	[WORLD_TILES.POLAR_ICE] = {sound = "turnoftides/together_amb/moon_island/winter"},
	[WORLD_TILES.POLAR_SNOW] = {sound = "dontstarve/AMB/grassland_winter"},
	[WORLD_TILES.POLAR_CAVES] = {sound = "dontstarve/AMB/caves/main"},
	[WORLD_TILES.POLAR_DRYICE] = {sound = "dontstarve/AMB/rocky_winter"},
	
	[WORLD_TILES.OCEAN_POLAR] = {sound = "turnoftides/together_amb/ocean/shallow", rainsound = "turnoftides/together_amb/ocean/shallow_rain"}
}

ENV.AddComponentPostInit("ambientsound", function(self)
	local AMBIENT_SOUNDS, SOUND = PolarUpvalue(self.OnUpdate, "AMBIENT_SOUNDS")
	
	if SOUND then
		for k, v in pairs(POLAR_AMBIENT_SOUND) do
			AMBIENT_SOUNDS[k] = POLAR_AMBIENT_SOUND[k]
		end
	end
end)