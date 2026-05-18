local assets = {}

local prefabs = {
	"oceanfish_medium_polar1",
}

local spawner_prefabs = {
	"polarfish_shoalspawner",
}

local function OnSpawnFish(inst, child)
	if child and child.sg then
		child.sg:GoToState("arrive")
	end
end

local function ReleaseAllFish(inst)
	inst.components.childspawner:ReleaseAllChildren()
end

local function OnEntitySleep(inst)
	if inst.releasefishtask then
		inst.releasefishtask:Cancel()
		inst.releasefishtask = nil
	end
end

local function OnEntityWake(inst)
	inst.releasefishtask = inst:DoTaskInTime(0.1, ReleaseAllFish)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.MiniMapEntity:SetIcon("oceanfish_shoalspawner.png")
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("oceanshoalspawner")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("childspawner")
	inst.components.childspawner:SetRegenPeriod(TUNING.OCEANFISH_SHOAL.POLAR_CHILD_REGENPERIOD)
	inst.components.childspawner:SetSpawnPeriod(TUNING.OCEANFISH_SHOAL.CHILD_SPAWNPERIOD)
	inst.components.childspawner:SetMaxChildren(TUNING.OCEANFISH_SHOAL.POLAR_MAX_CHILDREN)
	inst.components.childspawner:SetSpawnedFn(OnSpawnFish)
	inst.components.childspawner:StartRegen()
	inst.components.childspawner.spawnradius = TUNING.OCEANFISH_SHOAL.SPAWNRADIUS
	inst.components.childspawner.childname = "oceanfish_medium_polar1"
	inst.components.childspawner.wateronly = true
	inst.components.childspawner:StartSpawning()
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	
	return inst
end

local function spawner_fn() -- Bunch spawner for ice floes biome
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	
	inst:AddTag("CLASSIFIED")
	
	return inst
end

return Prefab("polarfish_shoalspawner", fn, assets, prefabs),
	Prefab("polarfish_shoalspawner_spawner_ice", spawner_fn, assets, spawner_prefabs)