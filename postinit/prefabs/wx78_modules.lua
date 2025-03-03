local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local WX78_MODULES_DEF = require("wx78_moduledefs")
local module_definitions = WX78_MODULES_DEF.module_definitions
local polarmodule_definitions = {}

--	New modules

local function naughty_onkill(wx, data)
	local victim = data and data.victim
	
	local naughtiness = victim and NAUGHTY_VALUE[victim.prefab] or 0
	local naughty_val = FunctionOrValue(naughtiness, wx, data)
	
	if victim and victim.prefab == "pigman" and victim.components.werebeast and victim.components.werebeast:IsInWereState() then
		naughty_val = 0
	end
	
	local stackmult = data and data.stackmult
	local israbbit = victim and victim:HasAnyTag("rabbit", "manrabbit")
	local curtime = GetTime()
	
	if (victim == nil or not victim:HasAnyTag(SOULLESS_TARGET_TAGS)) and wx.components.talker and (wx._nextnaughtytaunt == nil or wx._nextnaughtytaunt < curtime) then
		wx._nextnaughtytaunt = curtime + math.random(4, 6)
		wx.components.talker:Say(GetString(wx, israbbit and "ANNOUNCE_WX_NAUGHTYCHIP_RABBIT" or "ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS"))
	end
	
	if TheWorld.components.kramped and naughty_val > 0 then
		local naughty_total = naughty_val * TUNING.WX78_NAUGHTY_CHIPBOOSTS[math.min(wx._naughtychips or 1, #TUNING.WX78_NAUGHTY_CHIPBOOSTS)]
		
		TheWorld.components.kramped:AddFromWX_NaughtyModule(naughty_total * (stackmult or 1), wx)
	end
	
	if TheWorld.components.rabbitkingmanager and naughty_val > 0 and israbbit then
		local naughty_total = naughty_val * TUNING.WX78_NAUGHTY_CHIPBOOSTS[math.min(wx._naughtychips or 1, #TUNING.WX78_NAUGHTY_CHIPBOOSTS)]
		
		TheWorld.components.rabbitkingmanager:AddNaughtinessFromPlayer(wx, naughty_total * (stackmult or 1))
	end
end

local function naughty_activate(inst, wx)
	wx._naughtychips = (wx._naughtychips or 0) + 1
	
	if wx._naughtykill == nil then
		wx._naughtykill = function(owner, data)
			naughty_onkill(owner, data)
		end
		
		wx:ListenForEvent("killed", wx._naughtykill)
	end
end

local function naughty_deactivate(inst, wx)
	wx._naughtychips = math.max(0, wx._naughtychips - 1)
	
	if wx._naughtychips <= 0 and wx._naughtykill then
		wx:RemoveEventCallback("killed", wx._naughtykill)
		
		wx._naughtykill = nil
	end
end

local NAUGHTY_MODULE_DATA = {
	name = "naughty",
	slots = 1,
	activatefn = naughty_activate,
	deactivatefn = naughty_deactivate,
}
table.insert(polarmodule_definitions, NAUGHTY_MODULE_DATA)

--	Heat module melts snow around

local oldheat_activatefn
local function heat_activatefn(inst, wx, ...)
	if oldheat_activatefn then
		oldheat_activatefn(inst, wx, ...)
	end
	
	local _snowblockrange = wx._snowblockrange and wx._snowblockrange:value() or nil
	if not _snowblockrange then
		return
	end
	
	local range = _snowblockrange + TUNING.WX78_HEAT_SNOWBLOCK
	wx._snowblockrange:set(range)
	
	if wx.components.snowwavemelter == nil then
		wx:AddComponent("snowwavemelter")
	end
	wx.components.snowwavemelter.melt_range = range
	wx.components.snowwavemelter:StartMelting()
end

local oldheat_deactivatefn
local function heat_deactivatefn(inst, wx, ...)
	if oldheat_deactivatefn then
		oldheat_deactivatefn(inst, wx, ...)
	end
	
	local _snowblockrange = wx._snowblockrange and wx._snowblockrange:value() or nil
	if not _snowblockrange then
		return
	end
	
	local range = _snowblockrange - TUNING.WX78_HEAT_SNOWBLOCK
	wx._snowblockrange:set(range)
	
	if wx.components.snowwavemelter then
		wx.components.snowwavemelter.melt_range = range
		
		if range <= 0 then
			wx.components.snowwavemelter:StopMelting()
		end
	end
end

for i, data in ipairs(module_definitions) do
	if data.name == "heat" then
		if oldheat_activatefn == nil then
			oldheat_activatefn = data.activatefn
			oldheat_deactivatefn = data.deactivatefn
			
			data.activatefn = heat_activatefn
			data.deactivatefn = heat_deactivatefn
		end
		
		break
	end
end

--	New creatures to scan

local WX78_POLARMOBS_SCAN = {
	krampus = {module = "naughty", amt = 3},
	klaus = {module = "naughty", amt = 6},
	
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

--

for i, definition in ipairs(polarmodule_definitions) do
	local module_def = polarmodule_definitions[i]
	WX78_MODULES_DEF.AddNewModuleDefinition(definition)
	table.insert(WX78_MODULES_DEF.module_definitions, module_def)
	
	ENV.AddPrefabPostInit("wx78module_"..module_def.name, function(inst)
		inst.AnimState:SetBank("polarchips")
		inst.AnimState:SetBuild("wx_polarchips")
		
		if not TheWorld.ismastersim then
			return
		end
	end)
end