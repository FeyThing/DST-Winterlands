local assets = {
	Asset("ANIM", "anim/penguin_guard.zip"),
	Asset("ANIM", "anim/penguin.zip"),
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

local brain = require("brains/emperor_penguin_guardbrain")

--

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 20
local MAX_CHASEAWAY_DIST_SQ = 40 * 40

local function KeepTarget(inst, target)
	if TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated then
		return false
	end
	
	local pos = inst.components.knownlocations and (inst.components.knownlocations:GetLocation("herd") or inst.components.knownlocations:GetLocation("rookery"))
	if pos and target:GetDistanceSqToPoint(pos:Get()) < MAX_CHASEAWAY_DIST_SQ * 2 then
		return true
	elseif TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(target) then
		return true
	elseif inst.components.combat.lastwasattackedbytargettime + 3 >= GetTime() then
		return true
	end
	
	return false
end

local HOSTILE_TAGS = {"hostile", "monster"}
local HOSTILE_NOT_TAGS = {"INLIMBO", "isdead", "player", "penguin_emperor"}

local function RetargetFn(inst)
	local emperor = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.emperor
	local targets = {}
	
	--	First, only protect against castle attackers
	if emperor and emperor:IsValid() and emperor.components.combat and emperor:HasTag("hostile") then
		local pos = inst.components.knownlocations and (inst.components.knownlocations:GetLocation("herd") or inst.components.knownlocations:GetLocation("rookery"))
		local castle_pos = TheWorld.components.emperorpenguinspawner.ice_castle_pos
		
		for i, player in ipairs(AllPlayers) do
			if (castle_pos and player:GetDistanceSqToPoint(castle_pos) < MAX_CHASEAWAY_DIST_SQ * 2)
				or player:GetDistanceSqToPoint(emperor.Transform:GetWorldPosition()) < MAX_CHASEAWAY_DIST_SQ * 2 then
				
				table.insert(targets, player)
			end
		end
		
		local target = emperor.components.combat.target
		if target and not (target.components.health and target.components.health:IsDead()) and not table.contains(targets, target) then
			table.insert(targets, target)
		end
		
		if #targets > 0 then
			return targets[math.random(#targets)]
		end
	end
	
	--	If none, just protect from baddies around
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE, nil, HOSTILE_NOT_TAGS, HOSTILE_TAGS)
	for i, enemy in ipairs(ents) do
		if not (enemy:HasTag("penguin") and not enemy:HasTag("player")) and enemy.components.combat then
			table.insert(targets, enemy)
		end
	end
	
	return #targets > 0 and targets[math.random(#targets)] or nil
end

--

local function ShouldSleep(inst)
	return false
end

local function ShouldWake(inst)
	return true
end

local function OnPolarFreeze(inst, forming)
	if not forming then
		inst:Remove()
	end
end

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

--

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
	
	inst.AnimState:SetBank("penguin_guard")
	inst.AnimState:SetBuild("penguin_guard")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst:AddTag("penguin")
	inst:AddTag("penguin_guard")
	inst:AddTag("animal")
	inst:AddTag("smallcreature")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._soundpath = "polarsounds/emperor_guard/"
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "body"
	inst.components.combat.hurtsound = "polarsounds/emperor_guard/hit_metal"
	inst.components.combat:SetRetargetFunction(1, RetargetFn)
	inst.components.combat:SetDefaultDamage(TUNING.PENGUIN_GUARD_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.PENGUIN_GUARD_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.PENGUIN_GUARD_ATTACK_DIST)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.PENGUIN_GUARD_HEALTH)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 0.75
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("penguin_guard")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(3)
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	inst.components.sleeper:SetWakeTest(ShouldWake)
	inst.components.sleeper.diminishingreturns = true
	
	inst:AddComponent("stuckdetection")
	inst.components.stuckdetection:SetTimeToStuck(2)
	
	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("mutated_penguin")
	
	MakeSmallBurnableCharacter(inst, "body")
	
	MakeMediumFreezableCharacter(inst, "body")
	inst.components.freezable:SetResistance(5)
	inst.components.freezable:SetDefaultWearOffTime(1)
	
	MakeHauntablePanic(inst)
	
	inst.eggsLayed = 0
	inst.eggprefab = "bird_egg"
	inst.spawn_lunar_mutated_tuning = "SPAWN_MOON_PENGULLS" -- TODO: This needs testing
	
	inst.OnPolarFreeze = OnPolarFreeze
	inst.DoExtraEgg = DoExtraEgg
	inst._ondefeated = function(src, data)
		if not inst:IsAsleep() then
			OnDefeated(inst, data)
		end
    end
	
	EquipWeapon(inst)
	
	inst:SetBrain(brain)
	inst:SetStateGraph("SGpenguin")
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("emperorpenguin_defeated", inst._ondefeated, TheWorld)
	inst:ListenForEvent("newstate", OnEnterNewState)
	
	return inst
end

return Prefab("emperor_penguin_guard", fn, assets, prefabs)