local assets = {
	Asset("ANIM", "anim/polarbear_build.zip"),
	Asset("ANIM", "anim/polarbear_anims.zip"),
	
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
}

local prefabs = {
	"meat",
	"polarbearfur",
}

local sounds = {
	attack = "polarsounds/polarbear/atk",
	bite = "polarsounds/polarbear/bite",
	bite_snap = "polarsounds/polarbear/bite_snap",
	hit = "polarsounds/polarbear/hit",
	death = "polarsounds/polarbear/death",
	growl = "polarsounds/polarbear/growl",
	chew = "polarsounds/polarbear/chew",
	eat = "polarsounds/polarbear/eat",
	talk = "polarsounds/polarbear/sniff",
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
		inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
			return dude:HasTag("bear") and dude.components.health and not dude.components.health:IsDead()
		end, 10)
	end
	
	inst:SetEnraged(true)
end

local function GetStatus(inst)
	return (inst.enraged and "ENRAGED") or (inst.components.follower and inst.components.follower.leader ~= nil and "FOLLOWER") or nil
end

local function CalcSanityAura(inst, observer)
	return (inst.enraged and -TUNING.SANITYAURA_LARGE)
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
			elseif giver.components.leader then
				inst:StopPolarPlowing()
				
				giver:PushEvent("makefriend")
				giver.components.leader:AddFollower(inst)
				
				inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.POLARBEAR_LOYALTY_PER_HUNGER)
				inst.components.follower.maxfollowtime = giver:HasTag("polite")
					and TUNING.POLARBEAR_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS or TUNING.POLARBEAR_LOYALTY_MAXTIME
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
	elseif inst.components.talker and inst.components.combat and not inst.components.combat.target then
		inst.components.talker:Say(STRINGS.POLARBEAR_REFUSE_FOOD[math.random(#STRINGS.POLARBEAR_REFUSE_FOOD)])
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
	
	if inst.components.timer:TimerExists("plowinthemorning") then
		inst.components.timer:PauseTimer("plowinthemorning")
	end
	
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

local function OnEntityWake(inst)
	CancelRunHomeTask(inst)
	
	if inst.components.timer:TimerExists("plowinthemorning") then
		inst.components.timer:ResumeTimer("plowinthemorning")
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
		plower = SpawnPrefab("shovel")
		if plower.components.finiteuses then
			plower.components.finiteuses:SetConsumption(ACTIONS.POLARPLOW, 0)
		end
		if plower.components.inventoryitem then
			plower.components.inventoryitem.keepondeath = true
		end
		plower.persists = false
		
		inst.components.inventory:GiveItem(plower)
	end
	if not plower.components.equippable.isequipped then
		inst.components.inventory:Equip(plower)
	end
	
	if inst.putawayplower then
		inst.putawayplower:Cancel()
		inst.putawayplower = nil
	end
end

local function _putaway(inst)
	local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	
	if item and item.components.polarplower then
		inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
	end
	
	inst.putawayplower = nil
end

local function StopPolarPlowing(inst)
	if inst.putawayplower then
		_putaway(inst)
	else
		inst.putawayplower = inst:DoTaskInTime(1 + math.random(), _putaway)
	end
	
	if inst.components.timer:TimerExists("plowinthemorning") then
		inst.components.timer:StopTimer("plowinthemorning")
	end
end

local function DoGrowl(inst)
	inst.SoundEmitter:PlaySound(inst.sounds.growl, "growl")
	
	if inst.enraged and inst.components.health and not inst.components.health:IsDead() then
		inst._growltask = inst:DoTaskInTime(0.1 + math.random() * 0.5, inst.DoGrowl)
	end
end

local function SetEnraged(inst, enable)
	if enable ~= inst.enraged then
		local colour = inst.body_paint ~= DEFAULT_PAINTING and inst.body_paint or nil
		
		inst.AnimState:OverrideSymbol("pig_head", "polarbear_build", "pig_head"..(colour and "_"..colour or "")..(enable and "_rage" or ""))
		inst.enraged = enable
	end
	
	inst._isenraged:set(enable)
	if inst._growltask then
		inst._growltask:Cancel()
		inst._growltask = nil
	end
	
	inst:AddOrRemoveTag("hostile", enable)
	if inst.enraged then
		inst:StopPolarPlowing()
		
		inst._growltask = inst:DoTaskInTime(0.1, inst.DoGrowl)
		if not inst.components.timer:TimerExists("rageover") then
			inst.components.timer:StartTimer("rageover", TUNING.POLARBEAR_RAGE_TIME)
		else
			inst.components.timer:SetTimeLeft("rageover", TUNING.POLARBEAR_RAGE_TIME)
		end
		
		inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ragespeed", TUNING.POLARBEAR_RAGE_RUN_MULT)
	else
		inst.SoundEmitter:KillSound("growl")
		
		inst.components.timer:StopTimer("rageover")
		inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ragespeed")
	end
end

local function SetPainting(inst, colour)
	if colour ~= DEFAULT_PAINTING then
		inst.AnimState:OverrideSymbol("pig_torso", "polarbear_build", "pig_torso_"..colour)
		inst.AnimState:OverrideSymbol("pig_head", "polarbear_build", "pig_head_"..colour..(inst.enraged and "_rage" or ""))
	else
		inst.AnimState:ClearOverrideSymbol("pig_torso")
		inst.AnimState:OverrideSymbol("pig_head", "polarbear_build", "pig_head"..(inst.enraged and "_rage" or ""))
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

local function OnEquip(inst, data)
	if data.item and data.item.components.equippable and data.item.components.equippable.equipslot == EQUIPSLOTS.HANDS then
		inst.AnimState:Show("ARM_carry_up")
		inst.AnimState:Hide("ARM_carry")
	end
end

local function OnUnequip(inst, data)
	if data.item and data.item.components.equippable and data.item.components.equippable.equipslot == EQUIPSLOTS.HANDS then
		inst.AnimState:Show("ARM_carry")
		inst.AnimState:Hide("ARM_carry_up")
		inst.AnimState:ClearOverrideSymbol("swap_object")
	end
end

local function OnTimerDone(inst, data)
	if data.name == "rageover" then
		inst:SetEnraged(false)
	elseif data.name == "plowinthemorning" then
		inst:StopPolarPlowing()
	end
end

local function OnIsEnraged(inst)
	if inst.components.talker then
		inst.components.talker.colour = inst._isenraged:value() and Vector3(0.7, 0.1, 0.1, 1) or nil
	end
end

local function CLIENT_HostileToPlayerTest(inst, player)
	return false -- So we don't show Attack when befriended bears go psycho mode
end

local function OnTalk(inst, script)
	inst.SoundEmitter:PlaySound(inst.sounds.talk)
end

local function UpdateHead(inst)
	if inst.AnimState:GetCurrentFacing() == FACING_DOWN then
		inst.AnimState:SetMultiSymbolExchange("pig_ear", "pig_head")
	else
		inst.AnimState:ClearSymbolExchanges("pig_ear")
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 200, 0.75)
	
	inst.DynamicShadow:SetSize(2, 1)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("pigman")
	inst.AnimState:SetBuild("polarbear_build")
	inst.AnimState:SetHatOffset(0, 18)
	inst.AnimState:SetScale(1.4, 1.4)
	inst.AnimState:Hide("hat")
	inst.AnimState:Hide("ARM_carry_up")
	
	inst:AddTag("bear")
	inst:AddTag("character")
	inst:AddTag("polarwet")
	inst:AddTag("scarytoprey")
	
	inst.sounds = sounds
	
	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -400, 0)
	inst.components.talker.ontalk = OnTalk
	inst.components.talker.mod_str_fn = function(ret) return PolarifySpeech(ret, inst) end
	inst.components.talker:MakeChatter()
	
	inst._isenraged = net_bool(inst.GUID, "polarbear._isenraged", "isenraged")
	
	inst.HostileToPlayerTest = CLIENT_HostileToPlayerTest
	
	inst.entity:SetPristine()
	
	inst:ListenForEvent("isenraged", OnIsEnraged)
	
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
	inst.components.follower.maxfollowtime = TUNING.POLARBEAR_LOYALTY_MAXTIME
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.POLARBEAR_HEALTH)
	inst.components.health:StartRegen(TUNING.POLARBEAR_HEALTH_REGEN_AMOUNT, TUNING.POLARBEAR_HEALTH_REGEN_PERIOD)
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
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
	
	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddPostUpdateFn(UpdateHead)
	
	MakeMediumFreezableCharacter(inst, "pig_torso")
	inst.components.freezable:SetResistance(8)
	inst.components.freezable:SetDefaultWearOffTime(5)
	
	MakeMediumBurnableCharacter(inst, "pig_torso")
	MakeHauntablePanic(inst)
	
	inst.DoGrowl = DoGrowl
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.SetEnraged = SetEnraged
	inst.SetPainting = SetPainting
	inst.StartPolarPlowing = StartPolarPlowing
	inst.StopPolarPlowing = StopPolarPlowing
	
	inst.inittask = inst:DoTaskInTime(0, OnInit)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("equip", OnEquip)
	inst:ListenForEvent("unequip", OnUnequip)
	inst:ListenForEvent("gainloyalty", OnUnmarkForTeleport)
	inst:ListenForEvent("loseloyalty", OnMarkForTeleport)
	inst:ListenForEvent("startfollowing", OnUnmarkForTeleport)
	inst:ListenForEvent("stopfollowing", OnMarkForTeleport)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:SetStateGraph("SGpolarbear")
	inst:SetBrain(polarbear_brain)
	
	return inst
end

return Prefab("polarbear", fn, assets, prefabs)