local assets = {
	Asset("ANIM", "anim/penguin.zip"),
	Asset("ANIM", "anim/penguin_build.zip"),
	Asset("SOUND", "sound/pengull.fsb"),
}

local prefabs = {
	"smallmeat",
	"drumstick",
	"feather_crow",
	"bird_egg",
	"teamleader",
}

local brain = require("brains/polar_penguinbrain")

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40
local MAX_CHASEAWAY_DIST_SQ = 40 * 40

local function KeepTarget(inst, target)
	local pos = inst.components.knownlocations and inst.components.knownlocations:GetLocation("herd")
	
	if pos and target:GetDistanceSqToPoint(pos:Get()) < MAX_CHASEAWAY_DIST_SQ then
		return true
	elseif inst.components.combat.lastwasattackedbytargettime + 3 >= GetTime() then
		return true
	end
	
	return false
end

local function CanShareTarget(dude)
	return dude:HasTag("penguin")
end

local function OnAttacked(inst, data)
	local attacker = data and data.attacker
	
	if attacker then
		inst.components.combat:SetTarget(attacker)
		inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, CanShareTarget, MAX_TARGET_SHARES)
	end
end

local function CheckAutoRemove(inst)
	if not inst:IsOnValidGround() or TheWorld.state.iswinter or inst.components.herdmember and inst.components.herdmember:GetHerd() == nil then
		inst:Remove()
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 50, 0.5)
	
	inst.DynamicShadow:SetSize(1.5, 0.75)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("penguin")
	inst.AnimState:SetBuild("penguin_build")
	
	inst:AddTag("penguin")
	inst:AddTag("polar_penguin")
	inst:AddTag("animal")
	inst:AddTag("smallcreature")
	inst:AddTag("herdmember")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._soundpath = "dontstarve/creatures/pengull/"
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "body"
	inst.components.combat:SetDefaultDamage(TUNING.PENGUIN_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.PENGUIN_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.PENGUIN_ATTACK_DIST)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({FOODGROUP.OMNI}, {FOODGROUP.OMNI})
	inst.components.eater:SetCanEatHorrible()
	inst.components.eater:SetStrongStomach(true)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.PENGUIN_HEALTH)
	
	inst:AddComponent("herdmember")
	inst.components.herdmember.herdprefab = "polar_penguinherd"
	
	inst:AddComponent("inspectable")
	inst.components.inspectable:SetNameOverride("penguin")
	
	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 1
	inst.components.inventory.acceptsstacks = false
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 0.75
	inst.components.locomotor.pathcaps = {allowocean = true}
	inst.components.locomotor.directdrive = false
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("penguin")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(3)
	
	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("mutated_penguin")
	
	MakeSmallBurnableCharacter(inst, "body")
	
	MakeMediumFreezableCharacter(inst, "body")
	inst.components.freezable:SetResistance(5)
	inst.components.freezable:SetDefaultWearOffTime(1)
	
	MakeHauntablePanic(inst)
	
	inst.eggsLayed = 0
	inst.eggprefab = "bird_egg"
	inst.OnEntityWake = CheckAutoRemove
	inst.OnEntitySleep = CheckAutoRemove
	
	inst:SetStateGraph("SGpenguin")
	inst:SetBrain(brain)
	
	inst:ListenForEvent("attacked", OnAttacked)
	
	return inst
end

--

local function HerdFindWater(pt)
	return FindValidPositionByFan(math.random() * TWOPI, 2, 12, function(offset) 
		return not TheWorld.Map:IsVisualGroundAtPoint(pt.x + offset.x, 0, pt.z + offset.z)
	end)
end

local function GetSpawnPoint(inst)
	local pt = inst:GetPosition()
	local offset
	local range = 2
	
	while offset == nil and range < TUNING.POLAR_PENGUIN_SHORE_DIST + 2 do
		offset = FindWalkableOffset(pt, math.random() * TWOPI, range, 6, false, false, HerdFindWater)
		range = range + 2
	end
	
	if offset then
		return pt + offset
	end
end

local function CanSpawn(inst)
	return inst.components.herd and not inst.components.herd:IsFull()
end

local function OnSpawned(inst, pengu)
	if inst.components.herd then
		inst.components.herd:AddMember(pengu)
		
		local angle = pengu:GetAngleToPoint(inst.Transform:GetWorldPosition())
		pengu.Transform:SetRotation(angle)
		
		if pengu.sg then
			pengu.sg:GoToState("appear")
		end
	end
end

local function DoClubPenguin(inst)
	if inst.components.periodicspawner then
		local min_members = TUNING.POLAR_PENGUIN_MAX_IN_RANGE / 3
		local num_members = math.floor(min_members + (TUNING.POLAR_PENGUIN_MAX_IN_RANGE - min_members) * math.random() * math.random() + 0.5)
		
		for i = 1, num_members do
			local spawn_time = i > 1 and math.random() * 3 or 0
			
			inst:DoTaskInTime(spawn_time, function()
				inst.components.periodicspawner:TrySpawn("polar_penguin")
			end)
		end
	end
end

local function herd()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.MiniMapEntity:SetIcon("penguin.png")
	
	inst:AddTag("herd")
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	
	inst:AddComponent("herd")
	inst.components.herd:SetMemberTag("polar_penguin")
	--inst.components.herd:SetGatherRange(40)
	--inst.components.herd:SetUpdateRange(20)
	inst.components.herd.updatepos = false
	inst.components.herd:SetMaxSize(TUNING.POLAR_PENGUIN_MAX_IN_RANGE)
	inst.components.herd:SetOnEmptyFn(inst.Remove)
	
	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetRandomTimes(TUNING.POLAR_PENGUIN_MATING_SEASON_BABYDELAY, TUNING.POLAR_PENGUIN_MATING_SEASON_BABYDELAY_VARIANCE)
	inst.components.periodicspawner:SetPrefab("polar_penguin")
	inst.components.periodicspawner:SetGetSpawnPointFn(GetSpawnPoint)
	inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
	inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
	inst.components.periodicspawner:SetDensityInRange(TUNING.POLAR_PENGUIN_MAX_IN_RANGE, 20)
	inst.components.periodicspawner:SafeStart()
	
	inst.DoClubPenguin = DoClubPenguin
	
	TheWorld:PushEvent("ms_registerpolarpenguinherd", inst)
	
	return inst
end

return Prefab("polar_penguin", fn, assets, prefabs),
	Prefab("polar_penguinherd", herd)