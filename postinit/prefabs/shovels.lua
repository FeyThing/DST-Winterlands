local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local RANGES = TUNING.SNOW_PLOW_RANGES

local SHOVELS = {
	shovel = RANGES.SHOVEL,
	goldenshovel = RANGES.GOLDENSHOVEL,
	shovel_lunarplant = RANGES.SHOVEL_LUNARPLANT,
}

for shovel, range in pairs(SHOVELS) do
	ENV.AddPrefabPostInit(shovel, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		if inst.components.finiteuses then
			local dig_use = inst.components.finiteuses.consumption[ACTIONS.DIG] or 1
			
			inst.components.finiteuses:SetConsumption(ACTIONS.POLARPLOW, dig_use * TUNING.POLARPLOW_USE)
		end
		
		if inst.components.polarplower == nil then
			inst:AddComponent("polarplower")
			inst.components.polarplower.plow_range = range
		end
	end)
end