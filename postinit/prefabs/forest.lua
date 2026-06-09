local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddPrefabPostInit = ENV.AddPrefabPostInit

---------------------------------

local forest_shards = {"forest", "shipwrecked", "porkland"}
local cave_shards = {"cave", "volcano"}

local function Init_PolarCaveEntrance(inst)
	local candidates = {}
	
	for k, ent in pairs(Ents) do
		if ent.prefab == "rock_polar" then
			if ent.components.worldmigrator then
				print("Polar Cave Entrance State: found worldmigrator for", ent)
				
				return
			elseif ent.MakeCaveEntrance then
				local x, y, z = ent.Transform:GetWorldPosition()
				local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
				
				if IsLandTile(tile) and not TileGroupManager:IsTemporaryTile(tile) then
					table.insert(candidates, ent)
				end
			end
		end
	end
	
	if #candidates > 0 then
		local ent = candidates[math.random(#candidates)]
		ent:MakeCaveEntrance()
		
		print("Polar Cave Entrance State: added worldmigrator for", ent)
	else
		print("Polar Cave Entrance State: no Ice Protuberances found, couldn't be added!")
	end
end

for i, v in ipairs(forest_shards) do
	AddPrefabPostInit(v, function(inst)
		if not TheNet:IsDedicated() then
			inst:AddComponent("snowwaver")
		end
		
		inst:AddComponent("winterlands_manager")
		
		inst:AddComponent("polartemperature_manager")
		
		if not inst.ismastersim then
			return
		end
		
		inst:AddComponent("arcticfoolfishsavedata")
		
		inst:AddComponent("emperorpenguinspawner")
		
		inst:AddComponent("icefishingsurprise")
		
		inst:AddComponent("oceanfish_in_ice_spawner")
		
		inst:AddComponent("polarbearkingspawner")
		
		inst:AddComponent("polarfleamotherspawner")
		
		inst:AddComponent("polarflowerspawner")
		
		inst:AddComponent("polarfoxrespawner")
		
		inst:AddComponent("polarice_manager")
		
		inst:AddComponent("polarpenguinspawner")
		
		inst:AddComponent("polarsnow_manager")
		
		if TUNING.POLAR_BLIZZARDS_CONFIG ~= -2 then
			inst:AddComponent("polarstorm") -- TODO: always add this, but can be disabled
		end
		
		inst:AddComponent("polarwormholes")
		
		inst:AddComponent("retrofitforestmap_polar")
		
		inst:DoTaskInTime(1, Init_PolarCaveEntrance)
	end)
end

for i, v in ipairs(cave_shards) do
	ENV.AddPrefabPostInit(v, function(inst)
		if not TheNet:IsDedicated() then
			inst:AddComponent("snowwaver")
		end
		
		if not inst.ismastersim then
			return inst
		end
		
		inst:AddComponent("arcticfoolfishsavedata")
		
		inst:AddComponent("polarflowerspawner")
	end)
end

---------------------------------

local function DisableParticlesInWinterlands(inst)
	local mt = deepcopy(getmetatable(inst))
	
	if inst.particles_per_tick then
		mt.__index["particles_per_tick"] = 0
	end
	
	if inst.splashes_per_tick then
		mt.__index["splashes_per_tick"] = 0
	end
	
	mt.__newindex = function(t, key, val)
		if key == "particles_per_tick" or key == "splashes_per_tick" then
			if ThePlayer and ThePlayer.player_classified and TheWorld then
				local x, y, z = ThePlayer.Transform:GetWorldPosition()
				local snow_level = ThePlayer.player_classified.polarsnowlevel:value() or 0
				
				if inst.prefab == "pollen" and TheWorld.components.polartemperature_manager then
					snow_level = TheWorld.components.polartemperature_manager:GetDataAtPoint(x, y, z) > 0 and 1 or 0
				end
				
				local mult = 1 - (snow_level / 0.5)
				mult = math.clamp(mult, 0, 1)
				
				mt.__index[key] = val * mult
			else
				mt.__index[key] = val
			end
		else
			rawset(t, key, val)
		end
	end
	
	inst.particles_per_tick = nil
	inst.splashes_per_tick = nil
	setmetatable(inst, mt)
end

AddPrefabPostInit("rain", DisableParticlesInWinterlands)
AddPrefabPostInit("snow", DisableParticlesInWinterlands)
AddPrefabPostInit("pollen", DisableParticlesInWinterlands)

local OldSpawnRaindropAtXZ
local function SpawnRaindropAtXZ(inst, x, z, ...)
	if IsUnderIceCaveAtXZ(x, z) then
		return
	end
	
	return OldSpawnRaindropAtXZ and OldSpawnRaindropAtXZ(inst, x, z, ...)
end

---------------------------------

local postinits = {
	"shadeeffects",
}

ENV.AddSimPostInit(function()
	OldSpawnRaindropAtXZ = PolarUpvalue(Prefabs["rain"].fn, "SpawnRaindropAtXZ")
	PolarUpvalue(Prefabs["rain"].fn, "SpawnRaindropAtXZ", SpawnRaindropAtXZ)
	
	for _, v in pairs(postinits) do
		ENV.modimport("postinit/"..v)
	end
	
	if TheWorld.components.winterlands_manager then
		TheWorld.components.winterlands_manager:Initialize()
	end
end)