local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local WX78_MODULES_DEF = require("wx78_moduledefs")
local module_definitions = WX78_MODULES_DEF.module_definitions

--	New creatures to scan

local WX78_POLARMOBS_SCAN = {
	moose_polar = {module = "movespeed2", amt = 5},
	moose_specter = {module = "movespeed2", amt = 6},
	polarbear = {module = "maxhunger1", amt = 4},
	polarfox = {module = "nightvision", amt = 2},
	polarwarg = {module = "cold", amt = 6},
	shadow_icicler = {module = "maxsanity", amt = 3},
}

for mob, data in pairs(WX78_POLARMOBS_SCAN) do
	WX78_MODULES_DEF.AddCreatureScanDataDefinition(mob, data.module, data.amt)
end

--	Heat module melts snow around

local oldheat_activatefn
local function heat_activatefn(inst, wx, ...)
	if oldheat_activatefn then
		oldheat_activatefn(inst, wx, ...)
	end
	
	local _snowblockrange = wx._snowblockrange and wx._snowblockrange:value() or nil
	if _snowblockrange then
		wx._snowblockrange:set(_snowblockrange + TUNING.WX78_HEAT_SNOWBLOCK)
	end
end

local oldheat_deactivatefn
local function heat_deactivatefn(inst, wx, ...)
	if oldheat_deactivatefn then
		oldheat_deactivatefn(inst, wx, ...)
	end
	
	local _snowblockrange = wx._snowblockrange and wx._snowblockrange:value() or nil
	if _snowblockrange then
		wx._snowblockrange:set(_snowblockrange - TUNING.WX78_HEAT_SNOWBLOCK)
	end
end

for i, data in ipairs(module_definitions) do
	if data.name == "heat" then
		if oldheat_activatefn == nil then
			oldheat_activatefn = data.activatefn
			heat_deactivatefn = data.deactivatefn
			
			data.activatefn = heat_activatefn
			data.deactivatefn = heat_deactivatefn
		end
		
		break
	end
end