local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddPrefabPostInit = ENV.AddPrefabPostInit

AddPrefabPostInit("forest", function(inst)
	inst:AddComponent("winterlands_manager")
	
	if not inst.ismastersim then
		return
	end
	
	inst:AddComponent("polarstorm")
	
	inst:AddComponent("polarice_manager")
	
	inst:AddComponent("polarpenguinspawner")
	
	inst:AddComponent("polarsnow_manager")
end)

--

ENV.AddSimPostInit(function()
	ENV.modimport("postinit/shadeeffects")
	
	if TheWorld.components.winterlands_manager then
		TheWorld.components.winterlands_manager:Initialize()
	end
end)

local function DisableParticlesInWinterlands(inst)
	local mt = deepcopy(getmetatable(inst))
	if inst.particles_per_tick then
		mt.__index["particles_per_tick"] = 0
	end
	
	if inst.splashes_per_tick then
		mt.__index["splashes_per_tick"] = 0
	end
	
	mt.__newindex = function(t, key, val) -- Don't actually assign splashes and particles, __index runs only if the value is nil
		if key == "particles_per_tick" then
			local mt2 = deepcopy(getmetatable(inst))
			if ThePlayer and ThePlayer.player_classified.polarsnowlevel:value() ~= 0 then
				mt2.__index["particles_per_tick"] = 0
			else
				mt2.__index["particles_per_tick"] = val
			end
			
			setmetatable(inst, mt2)
		elseif key == "splashes_per_tick" then
			local mt2 = deepcopy(getmetatable(inst))
			if ThePlayer and ThePlayer.player_classified.polarsnowlevel:value() ~= 0 then
				mt2.__index["splashes_per_tick"] = 0
			else
				mt2.__index["splashes_per_tick"] = val
			end
			
			setmetatable(inst, mt2)
		else
			rawset(t, key, val)
		end
	end
	
	inst.particles_per_tick = nil
	inst.splashes_per_tick = nil
	setmetatable(inst, mt)
end

AddPrefabPostInit("snow", DisableParticlesInWinterlands)
AddPrefabPostInit("rain", DisableParticlesInWinterlands)
AddPrefabPostInit("pollen", DisableParticlesInWinterlands)