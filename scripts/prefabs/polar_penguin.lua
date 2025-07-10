local assets = {
	Asset("ANIM", "anim/penguin_guard.zip"),
	Asset("ANIM", "anim/penguin_build.zip"),
	Asset("ANIM", "anim/penguin.zip"),
	
	Asset("SOUND", "sound/pengull.fsb"),
}

local prefabs = {
	"bird_egg",
	"drumstick",
	"flint",
	"feather_crow",
	"featherpencil",
	"smallmeat",
}

SetSharedLootTable("penguin_guard", {
	{"feather_crow", 			0.2},
	{"featherpencil", 			0.2},
	{"flint", 					0.1},
	{"drumstick", 				0.1},
	{"smallmeat", 				0.1},
	{"polar_spear_blueprint", 	0.01},
})

local brain = require("brains/polar_penguinbrain")
local guard_brain = require("brains/emperor_penguin_guardbrain")

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 20
local MAX_CHASEAWAY_DIST_SQ = 40 * 40

local function KeepTarget(inst, target)
	local isguard = inst:HasTag("penguin_guard")
	if isguard and TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated then
		return false
	end
	
	local pos = inst.components.knownlocations and (inst.components.knownlocations:GetLocation("herd") or inst.components.knownlocations:GetLocation("rookery"))
	if pos and target:GetDistanceSqToPoint(pos:Get()) < MAX_CHASEAWAY_DIST_SQ * (isguard and 2 or 1) then
		return true
	elseif isguard and TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(target) then
		return true
	elseif inst.components.combat.lastwasattackedbytargettime + 3 >= GetTime() then
		return true
	end
	
	return false
end

local function RetargetFn(inst)
	local emperor = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.emperor
	
	if emperor and emperor:IsValid() and emperor.components.combat and emperor:HasTag("hostile") then
		local targets = {}
		local pos = inst.components.knownlocations and (inst.components.knownlocations:GetLocation("herd") or inst.components.knownlocations:GetLocation("rookery"))
		for i, player in ipairs(AllPlayers) do
			if player:GetDistanceSqToPoint(emperor.Transform:GetWorldPosition()) < MAX_CHASEAWAY_DIST_SQ * 2 then
				table.insert(targets, player)
			end
		end
		
		local target = emperor.components.combat.target
		if target and not (target.components.health and target.components.health:IsDead()) and not table.contains(targets, target) then
			table.insert(targets, target)
		end
		
		return #targets > 0 and targets[math.random(#targets)] or nil
	end
end

local function OnPolarFreeze(inst, forming)
	if not forming then
		inst:Remove()
	end
end

local function CanShareTarget(dude)
	return dude:HasTag("penguin")
end

local function OnAttacked(inst, data)
	local attacker = data and data.attacker
	
	if attacker then
		inst.components.combat:SetTarget(attacker)
		inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, CanShareTarget, MAX_TARGET_SHARES)
		
		if TheWorld.components.emperorpenguinspawner then 
			TheWorld.components.emperorpenguinspawner:ProvokeCastle(inst, attacker)
		end
	end
end

local function common(bank, build, soundpath)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 50, 0.5)
	
	inst.DynamicShadow:SetSize(1.5, 0.75)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build or bank)
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst:AddTag("penguin")
	inst:AddTag("animal")
	inst:AddTag("smallcreature")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._soundpath = soundpath or "dontstarve/creatures/pengull/"
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "body"
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
	inst:AddComponent("health")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 0.75
	
	inst:AddComponent("lootdropper")
	
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
	inst.OnPolarFreeze = OnPolarFreeze
	
	inst:SetStateGraph("SGpenguin")
	
	inst:ListenForEvent("attacked", OnAttacked)
	
	return inst
end

--	Emperor guards

local function IsSpear(item)
	return item:HasTag("pointy")
end

local function EquipWeapon(inst)
	if inst.components.inventory and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
		local spear = inst.components.inventory:FindItem(IsSpear) or SpawnPrefab("polar_spear")
		
		if math.random() >= TUNING.PENGUIN_GUARD_SPEAR_DROPRATE then
			spear.persists = false
			spear.components.inventoryitem:SetOnDroppedFn(spear.Remove) -- TODO: Small fade away instead
		end
		
		inst.components.inventory:GiveItem(spear)
		inst.components.inventory:Equip(spear)
	end
end

local function ShouldSleep(inst)
	return false
end

local function ShouldWake(inst)
	return true
end

local function DoExtraEgg(inst)
	local egg = inst.eggprefab and inst.components.lootdropper and inst.components.lootdropper:SpawnLootPrefab(inst.eggprefab)
	inst._extraegg = nil
	
	return egg
end

local function OnDefeated(inst, data)
	if inst._extraegg == nil then
		inst._extraegg = inst:DoTaskInTime(2 + math.random() * 6, inst.DoExtraEgg)
	end
end

local function OnEnterNewState(inst, data)
	if inst.components.combat then
		local short_range = inst.sg and (inst.sg:HasStateTag("running") or inst.sg:HasStateTag("runningattack"))
		
		inst.components.combat:SetRange(short_range and TUNING.PENGUIN_GUARD_ATTACK_DIST_SHORT or TUNING.PENGUIN_GUARD_ATTACK_DIST)
		inst.components.combat.battlecryenabled = not short_range
	end
end

local function guard()
	local inst = common("penguin_guard", nil, "polarsounds/emperor_guard/")
	
	inst:AddTag("penguin_guard")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.combat.hurtsound = "polarsounds/emperor_guard/hit_metal"
	inst.components.combat:SetRetargetFunction(1, RetargetFn)
	inst.components.combat:SetDefaultDamage(TUNING.PENGUIN_GUARD_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.PENGUIN_GUARD_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.PENGUIN_GUARD_ATTACK_DIST)
	
	inst.components.health:SetMaxHealth(TUNING.PENGUIN_GUARD_HEALTH)
	
	inst.components.lootdropper:SetChanceLootTable("penguin_guard")
	
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	inst.components.sleeper:SetWakeTest(ShouldWake)
	inst.components.sleeper.diminishingreturns = true
	
	inst:AddComponent("stuckdetection")
	inst.components.stuckdetection:SetTimeToStuck(2)
	
	inst.DoExtraEgg = DoExtraEgg
	inst._ondefeated = function(src, data)
		if not inst:IsAsleep() then
			OnDefeated(inst, data)
		end
    end
	
	EquipWeapon(inst)
	
	inst:SetBrain(guard_brain)
	
	inst:ListenForEvent("emperorpenguin_defeated", inst._ondefeated, TheWorld)
	inst:ListenForEvent("newstate", OnEnterNewState)
	
	return inst
end

--	Basic penguins + herd, but with flipped season despawn mechanism

local function CheckAutoRemove(inst)
	local curseason = POLARRIFY_MOD_SEASONS[TheWorld.state.season] or "autumn"
	
	if curseason == "winter" then
		inst:Remove()
	end
end

local function polar()
	local inst = common("penguin", "penguin_build")
	
	inst:AddTag("polar_penguin")
	inst:AddTag("herdmember")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.combat:SetDefaultDamage(TUNING.PENGUIN_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.PENGUIN_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.PENGUIN_ATTACK_DIST)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({FOODGROUP.OMNI}, {FOODGROUP.OMNI})
	inst.components.eater:SetCanEatHorrible()
	inst.components.eater:SetStrongStomach(true)
	
	inst.components.health:SetMaxHealth(TUNING.PENGUIN_HEALTH)
	
	inst:AddComponent("herdmember")
	inst.components.herdmember.herdprefab = "polar_penguinherd"
	
	inst.components.inspectable:SetNameOverride("penguin")
	
	inst.components.inventory.maxslots = 1
	inst.components.inventory.acceptsstacks = false
	
	inst.components.locomotor.pathcaps = {allowocean = true}
	inst.components.locomotor.directdrive = false
	
	inst.components.lootdropper:SetChanceLootTable("penguin")
	
	inst.OnEntityWake = CheckAutoRemove
	inst.OnEntitySleep = CheckAutoRemove
	
	inst:SetBrain(brain)
	
	return inst
end

--

local function HerdFindWater(pt)
	local pos
	local range = 1
	
	while pos == nil and range < 8 do
		pos = FindValidPositionByFan(math.random() * TWOPI, range, 12, function(offset) 
			return not TheWorld.Map:IsVisualGroundAtPoint(pt.x + offset.x, 0, pt.z + offset.z)
		end)
		range = range + 1
	end
	
	return pos ~= nil
end

local function GetSpawnPoint(inst)
	local pt = inst:GetPosition()
	
	if not TheWorld.Map:IsPassableAtPoint(pt:Get()) then -- Everyone go home, herd sunk !
		for pengu in pairs(inst.components.herd.members) do
			if pengu:IsValid() then
				if pengu:IsAsleep() then
					pengu:Remove()
				else
					if pengu.components.herdmember then
						pengu.components.herdmember.enabled = false
					end
					
					pengu.persists = false
				end
			end
		end
		
		inst:Remove()
		
		return
	end
	
	local offset
	local range = 2
	
	while offset == nil and range < TUNING.POLAR_PENGUIN_SHORE_DIST + 2 do
		offset = FindWalkableOffset(pt, math.random() * TWOPI, range, 6, false, false, function(_pt) return inst:IsAsleep() or HerdFindWater(_pt) end)
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

return Prefab("emperor_penguin_guard", guard, assets, prefabs),
	Prefab("polar_penguin", polar, assets, prefabs),
	Prefab("polar_penguinherd", herd)