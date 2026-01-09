local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local PlantRegrowth = require("components/plantregrowth")

local TimeMultipliers = PlantRegrowth.TimeMultipliers

if TimeMultipliers then
	TimeMultipliers["deciduoustree_polar"] = function()
		return TUNING.DECIDIOUS_REGROWTH_TIME_MULT * ((not TheWorld.state.iswinter and 0) or 1)
	end
end