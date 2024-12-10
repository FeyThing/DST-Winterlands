local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local WX78_MODULES_DEF = require("wx78_moduledefs")
local module_definitions = WX78_MODULES_DEF.module_definitions

---------------------------------------------------------------

local WX78_POLARMOBS_SCAN = {
	moose_polar = {module = "movespeed2", amt = 2},
	polarfox = {module = "nightvision", amt = 4},
	polarwarg = {module = "cold", amt = 6},
	shadow_icicler = {module = "maxsanity", amt = 3},
}

for mob, data in pairs(WX78_POLARMOBS_SCAN) do
	WX78_MODULES_DEF.AddCreatureScanDataDefinition(mob, data.module, data.amt)
end
