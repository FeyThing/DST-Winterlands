local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local SHOVELS = {
	shovel = 4,
	goldenshovel = 5,
	shovel_lunarplant = 6,
}

for shovel, range in pairs(SHOVELS) do
	ENV.AddPrefabPostInit(shovel, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		if inst.components.polarplower == nil then
			inst:AddComponent("polarplower")
			inst.components.polarplower.plow_range = range
		end
	end)
end