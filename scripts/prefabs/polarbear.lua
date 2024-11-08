local assets = {
	Asset("ANIM", "anim/polarbear_build.zip"),
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
}

local prefabs = {
	"meat",
	"polarbearfur",
}

local sounds = {
	attack = "dontstarve/creatures/merm/attack",
	hit = "dontstarve/creatures/merm/hurt",
	death = "dontstarve/creatures/merm/death",
	talk = "dontstarve/characters/wurt/merm/warrior/talk",
	buff = "dontstarve/characters/wurt/merm/warrior/yell",
}

local polarbear_brain = require("brains/polarbearbrain")

local DEFAULT_PAINTING = "blue"
local BODY_PAINTINGS = {
	"blue",
	"red",
}

local RETARGET_MUST_TAGS = {"_combat", "_health"}
local RETARGET_ONEOF_TAGS = {"hound", "merm", "pirate", "walrus"}

local function RetargetFn(inst)
	return not inst:IsInLimbo() and FindEntity(inst, TUNING.PIG_TARGET_DIST, function(guy)
		return inst.components.combat:CanTarget(guy)
	end, RETARGET_MUST_TAGS, nil, RETARGET_ONEOF_TAGS) or nil
end

local function KeepTargetFn(inst, target)
	return not (target.sg and target.sg:HasStateTag("hiding")) and inst.components.combat:CanTarget(target)
end

local function OnAttacked(inst, data)
	if data and data.attacker then
		inst.components.combat:SetTarget(data.attacker)  
	end
end

local function CalcSanityAura(inst, observer)
	return (inst.components.combat and inst.components.combat.target ~= nil and -TUNING.SANITYAURA_LARGE)
		or (inst.components.follower and inst.components.follower.leader == observer and TUNING.SANITYAURA_SMALL)
		or 0
end

local function IsAbleToAccept(inst, item, giver)
	if inst.components.health and inst.components.health:IsDead() then
		return false, "DEAD"
	elseif inst.sg ~= nil and inst.sg:HasStateTag("busy") then
		if inst.sg:HasStateTag("sleeping") then
			return true
		else
			return false, "BUSY"
		end
	else
		return true
	end
end

local function ShouldAcceptItem(inst, item, giver)
	if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
		return true
	elseif inst.components.eater:CanEat(item) then
		local foodtype = item.components.edible.foodtype
		
		if foodtype == FOODTYPE.MEAT or foodtype == FOODTYPE.HORRIBLE then
			return inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= TUNING.PIG_FULL_LOYALTY_PERCENT
		elseif foodtype == FOODTYPE.VEGGIE or foodtype == FOODTYPE.RAW then
			local last_eat_time = inst.components.eater:TimeSinceLastEating()
			
			return (last_eat_time == nil or last_eat_time >= TUNING.PIG_MIN_POOP_PERIOD) and (inst.components.inventory == nil or not inst.components.inventory:Has(item.prefab, 1))
		end
		
		return true
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.edible then
		if (item.components.edible.foodtype == FOODTYPE.MEAT or item.components.edible.foodtype == FOODTYPE.HORRIBLE) and item.components.inventoryitem and
			(item.components.inventoryitem:GetGrandOwner() == inst or not item:IsValid() and inst.components.inventory:FindItem(function(obj)
				return obj.prefab == item.prefab and obj.components.stackable and obj.components.stackable:IsStack()
			end)) then
			
			if inst.components.combat:TargetIs(giver) then
				inst.components.combat:SetTarget(nil)
			elseif giver.components.leader and not giver:HasTag("monster") then
				if giver.components.minigame_participator == nil then
					giver:PushEvent("makefriend")
					giver.components.leader:AddFollower(inst)
				end
				
				inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PIG_LOYALTY_PER_HUNGER)
				inst.components.follower.maxfollowtime = giver:HasTag("polite")
					and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS or TUNING.PIG_LOYALTY_MAXTIME
			end
		end
		
		if inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
	end
	
	if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
		local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		if current then
			inst.components.inventory:DropItem(current)
		end
		
		inst.components.inventory:Equip(item)
		inst.AnimState:Show("hat")
	end
end

local function OnRefuseItem(inst, item)
	inst.sg:GoToState("refuse")
	
	if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end

local function OnRanHome(inst)
	if inst:IsValid() then
		inst.runhometask = nil
		inst.wantstoteleport = nil

		local home = inst.components.homeseeker and inst.components.homeseeker:GetHome() or nil
		if home and home.components.childspawner then
			local invcmp = inst.components.inventory
			
			if invcmp then
				local x, y, z = home.Transform:GetWorldPosition()
				local homeradius = home:GetPhysicsRadius(1) + 1
				
				for _, equipped_item in pairs(invcmp.equipslots) do
					local angle = math.random() * TWOPI
					local pos = Vector3(x + math.cos(angle) * homeradius, 0, z - math.sin(angle) * homeradius)
					invcmp:DropItem(equipped_item, true, true, pos)
				end
			end
			home.components.childspawner:GoHome(inst)
		end
	end
end

local function CancelRunHomeTask(inst)
	if inst.runhometask then
		inst.runhometask:Cancel()
		inst.runhometask = nil
	end
end

local function OnEntitySleep(inst)
	CancelRunHomeTask(inst)
	
	if not inst.wantstoteleport then
		return
	end
	if inst.components.follower and inst.components.follower.leader then
		return
	end
	
	local hometraveltime = inst.components.homeseeker and inst.components.homeseeker:GetHomeDirectTravelTime() or nil
	if hometraveltime then
		inst.runhometask = inst:DoTaskInTime(hometraveltime, OnRanHome)
	end
end

local function OnMarkForTeleport(inst, data)
	if data and data.leader then
		inst.wantstoteleport = true
	end
end

local function OnUnmarkForTeleport(inst, data)
	if data and data.leader then
		inst.wantstoteleport = nil
	end
end

local function StartPolarPlowing(inst)
	local equipped = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local plower = inst.components.inventory:FindItem(function(item) return item.components.polarplower end) or (equipped and equipped.components.polarplower and equipped)
	
	if not plower then
		plower = SpawnPrefab("shovel") -- TODO: custom ? (also don't drop them on death!!)
		plower.components.polarplower.plow_use = 0
		
		inst.components.inventory:GiveItem(plower)
	end
	if not plower.components.equippable.isequipped then
		inst.components.inventory:Equip(plower)
	end
	
	if inst.putawayplower then
		inst.putawayplower:Cancel()
		inst.putawayplower = nil
	end
	inst._plowingtimer = function(inst, data)
		if data.name == "polarplowingtime" then
			inst.StopPolarPlowing(inst)
		end
	end
	inst:ListenForEvent("timerdone", inst._plowingtimer)
end

local function StopPolarPlowing(inst)
	if inst._plowingtimer then
		inst:RemoveEventCallback("timerdone", inst._plowingtimer)
		inst._plowingtimer = nil
	end
	if inst.components.timer:TimerExists("polarplowingtime") then
		inst.components.timer:StopTimer("polarplowingtime")
	end
	
	inst.putawayplower = inst:DoTaskInTime(2, function()
		local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if item and item.components.polarplower then
			inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
		end
	end)
end

local function SetPainting(inst, colour)
	if colour ~= DEFAULT_PAINTING then
		inst.AnimState:OverrideSymbol("pig_torso", "polarbear_build", "pig_torso_"..colour)
		inst.AnimState:OverrideSymbol("pig_head", "polarbear_build", "pig_head_"..colour)
	else
		inst.AnimState:ClearOverrideSymbol("pig_torso")
		inst.AnimState:ClearOverrideSymbol("pig_head")
	end
	
	inst.body_paint = colour
end

local function OnSave(inst, data)
	if inst.wantstoteleport then
		data.wantstoteleport = true
	end
	data.colour = inst.body_paint
end

local function OnLoad(inst, data)
	if data then
		inst.wantstoteleport = data.wantstoteleport or inst.wantstoteleport
		if data.colour then
			inst:SetPainting(data.colour)
		end
	end
end

local function OnInit(inst)
	if inst.body_paint == nil then
		inst:SetPainting(BODY_PAINTINGS[math.random(#BODY_PAINTINGS)])
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 100, 0.5)
	inst:SetPhysicsRadiusOverride(0.5)
	
	inst.DynamicShadow:SetSize(1.5, 0.75)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("pigman")
	inst.AnimState:SetBuild("polarbear_build")
	inst.AnimState:SetHatOffset(0, 18)
	inst.AnimState:SetScale(1.4, 1.4)
	inst.AnimState:Hide("hat")
	inst.AnimState:Hide("ARM_carry_up")
	inst.AnimState:Hide("ARM_carry")
	
	inst:AddTag("character")
	inst:AddTag("bear")
	inst:AddTag("polarwet")
	
	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -400, 0)
	inst.components.talker.mod_str_fn = function(ret) return PolarifySpeech(ret, inst) end
	inst.components.talker:MakeChatter()
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "pig_torso"
	inst.components.combat:SetDefaultDamage(TUNING.POLARBEAR_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.POLARBEAR_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(1, RetargetFn)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({FOODGROUP.BEARGER}, {FOODGROUP.BEARGER})
	inst.components.eater:SetCanEatHorrible()
	inst.components.eater:SetCanEatRaw()
	inst.components.eater:SetStrongStomach(true)
	
	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.POLARBEAR_HEALTH)
	inst.components.health:StartRegen(TUNING.POLARBEAR_HEALTH_REGEN_AMOUNT, TUNING.POLARBEAR_HEALTH_REGEN_PERIOD)
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.POLARBEAR_RUN_SPEED
	inst.components.locomotor.walkspeed = TUNING.POLARBEAR_WALK_SPEED
	inst.components.locomotor:SetAllowPlatformHopping(true)
	
	inst:AddComponent("embarker")
	
	inst:AddComponent("drownable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("meat", 3)
	inst.components.lootdropper:AddRandomLoot("polarbearfur", 1)
	inst.components.lootdropper.numrandomloot = 1
	
	inst:AddComponent("named")
	inst.components.named.possiblenames = STRINGS.POLARBEARNAMES
	inst.components.named:PickNewName()
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = CalcSanityAura
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(3)
	
	inst:AddComponent("timer")
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader:SetAbleToAcceptTest(IsAbleToAccept)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = false
	
	MakeMediumFreezableCharacter(inst, "pig_torso")
	inst.components.freezable:SetResistance(8)
	
	MakeMediumBurnableCharacter(inst, "pig_torso")
	MakeHauntablePanic(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.SetPainting = SetPainting
	inst.StartPolarPlowing = StartPolarPlowing
	inst.StopPolarPlowing = StopPolarPlowing
	
	inst.sounds = sounds
	
	inst.inittask = inst:DoTaskInTime(0, OnInit)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("entitysleep", OnEntitySleep)
	inst:ListenForEvent("entitywake", CancelRunHomeTask)
	inst:ListenForEvent("loseloyalty", OnMarkForTeleport)
	inst:ListenForEvent("stopfollowing", OnMarkForTeleport)
	inst:ListenForEvent("gainloyalty", OnUnmarkForTeleport)
	inst:ListenForEvent("startfollowing", OnUnmarkForTeleport)
	
	inst:SetStateGraph("SGpolarbear")
	inst:SetBrain(polarbear_brain)
	
	return inst
end

return Prefab("polarbear", fn, assets, prefabs)