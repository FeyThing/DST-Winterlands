local assets = {
	Asset("ANIM", "anim/pillar_icecave.zip"),
	Asset("SCRIPT", "scripts/prefabs/polarcaveshadow.lua"),
}

local assets_small = {
	Asset("ANIM", "anim/pillar_ice_med.zip"),
}

local function GetPolarMistRange(inst)
	return math.random(4, 8)
end

local function OnSave(inst, data)
	data.spawned_icicles = inst.spawned_icicles
end

local function OnLoad(inst, data)
	if data then
		inst.spawned_icicles = data.spawned_icicles
	end
end

local ICICLE_AVOID_TAGS = {"bigicicle", "birdblocker", "HAMMER_workable", "structure", "wall"}

local function NoIcicleInRange(pt)
	return not TheWorld.Map:IsPointNearHole(pt) and #TheSim:FindEntities(pt.x, pt.y, pt.z, 9, nil, nil, ICICLE_AVOID_TAGS) == 0
end

local function GetSpawnPoint(inst)
	local pt = inst:GetPosition()
	local offset
	local range = 4
	
	while offset == nil and range < TUNING.SHADE_POLAR_RANGE do
		offset = FindWalkableOffset(pt, math.random() * TWOPI, range, 6, true, false, NoIcicleInRange)
		range = range + 2
	end
	
	if offset then
		return pt + offset
	end
end

local function OnInit(inst)
	if not inst.spawned_icicles then
		for i = 1, TUNING.POLAR_MAX_ICICLES do
			local spawnpoint = inst.components.periodicspawner and inst.components.periodicspawner.getspawnpointfn(inst)
			
			if spawnpoint then
				local icicle = SpawnPrefab("polar_icicle")
				icicle.Transform:SetPosition(spawnpoint:Get())
				icicle.stage = math.random(3)
				
			end
		end
		
		inst.spawned_icicles = true
	end
end

local RAINPROTECT_TAGS = {"inspectable"}
local RAINPROTECT_NOT_TAGS = {"INLIMBO"}

local function DoRainProtection(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, inst.rainprotect_rad, RAINPROTECT_TAGS, RAINPROTECT_NOT_TAGS)

	local oldtargets = inst.rainprotected
	local newtargets = {}
	
	for i, target in ipairs(ents) do
		if oldtargets[target] then
			oldtargets[target] = nil
		else
			if not target.components.rainimmunity then
				target:AddComponent("rainimmunity")
			end
			target.components.rainimmunity:AddSource(inst)
		end
		
		newtargets[target] = true
	end
	
	for target in pairs(oldtargets) do
		if target:IsValid() and target.components.rainimmunity then
			target.components.rainimmunity:RemoveSource(inst)
		end
	end
	
	inst.rainprotected = newtargets
end

local function commonfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2.5)
	
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	local scale = math.random() > 0.5 and 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	return inst
end

local function shadefn()
	local inst = commonfn()
	
	inst.AnimState:SetBank("pillar_icecave")
	inst.AnimState:SetBuild("pillar_icecave")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("icecaveshelter")
	
	inst.MiniMapEntity:SetIcon("pillar_polarcave.png")
	
	inst.rainprotect_rad = TUNING.SHADE_POLAR_RANGE
	
	if not TheNet:IsDedicated() then
		inst:AddComponent("distancefade")
		inst.components.distancefade:Setup(TUNING.SHADE_POLAR_RANGE, TUNING.SHADE_POLAR_RANGE * 2)
		
		inst:AddComponent("polarcaveshade")
	end
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.rainprotected = {}
	
	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetRandomTimes(TUNING.POLAR_ICICLE_SPAWNTIME, 0)
	inst.components.periodicspawner:SetPrefab("polar_icicle")
	inst.components.periodicspawner:SetDensityInRange(TUNING.POLAR_MAX_ICICLES, TUNING.SHADE_POLAR_RANGE)
	inst.components.periodicspawner:SetGetSpawnPointFn(GetSpawnPoint)
	inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
	inst.components.periodicspawner:Start()
	
	inst:AddComponent("polarmistemitter")
	inst.components.polarmistemitter:StartMisting()
	inst.components.polarmistemitter.rate = 0.1
	inst.components.polarmistemitter.radius = GetPolarMistRange
	inst.components.polarmistemitter.scale = 5
	inst.components.polarmistemitter.speed = 0.6
	inst.components.polarmistemitter.maxmist = 15
	inst.components.polarmistemitter.maxmist_range = 8
	
	inst.DoRainProtection = DoRainProtection
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:DoTaskInTime(0, OnInit)
	
	inst._rainprottask = inst:DoPeriodicTask(0.25, inst.DoRainProtection)
	
	return inst
end

local function smallfn()
	local inst = commonfn()
	
	inst.AnimState:SetBank("pillar_ice_med")
	inst.AnimState:SetBuild("pillar_ice_med")
	inst.AnimState:PlayAnimation("idle")
	
	inst.MiniMapEntity:SetIcon("pillar_polar.png")
	
	return inst
end

return Prefab("pillar_polarcave", shadefn, assets),
	Prefab("pillar_polar", smallfn, assets_small)