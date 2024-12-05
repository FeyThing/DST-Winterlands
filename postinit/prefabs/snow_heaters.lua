local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local SNOW_HEATERS = {
	emberlight = 7,
	dragonflyfurnace = 6,
	lava_pond = 6,
	lavae_pet = 6,
	saladfurnace = 6,
	stafflight = 10,
}

for heater, range in pairs(SNOW_HEATERS) do
	ENV.AddPrefabPostInit(heater, function(inst)
		if inst._snowblockrange == nil then
			inst._snowblockrange = net_tinybyte(inst.GUID, heater.."._snowblockrange")
			inst._snowblockrange:set(range)
		end
	end)
end

--	Spotlight...

local EnableTargetSearch

local OldOnIsDarkOrCold
local function OnIsDarkOrCold(inst, ...)
	if OldOnIsDarkOrCold then
		OldOnIsDarkOrCold(inst, ...)
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	if inst._heated and inst._heated:value() and GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil and inst._turnofftask then
		if EnableTargetSearch then
			EnableTargetSearch(inst, true)
		end
	end
end

ENV.AddPrefabPostInit("winona_spotlight", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.AddBatteryPower and OldOnIsDarkOrCold == nil then
		local SetPowered = PolarUpvalue(inst.AddBatteryPower, "SetPowered")
		
		if SetPowered then
			OldOnIsDarkOrCold = PolarUpvalue(SetPowered, "OnIsDarkOrCold")
			
			if OldOnIsDarkOrCold then
				EnableTargetSearch = PolarUpvalue(OldOnIsDarkOrCold, "EnableTargetSearch")
				
				PolarUpvalue(SetPowered, "OnIsDarkOrCold", OnIsDarkOrCold)
			end
		end
	end
end)