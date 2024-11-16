local assets = {
	Asset("ANIM", "anim/polarfox.zip"),
}

local prefabs = {
	"polarfox_tail",
}

local polarfox_brain = require("brains/polarfoxbrain")

local function OnPlayerFar(inst, player)
	if inst.tail and inst._tailalert then
		inst._tailalert = nil
		inst.tail:PlayTailAnim("alert_pst", "idle")
	end
end

local function OnPlayerNear(inst, player)
	if inst.components.follower and inst.components.follower.leader == nil then
		if inst.tail and not inst._tailalert then
			inst._tailalert = true
			inst.tail:PlayTailAnim("alert_pre", "alert_loop")
		end
		
		if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
	end
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
	if inst.components.eater:CanEat(item) and inst.components.follower then
		return inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= TUNING.PIG_FULL_LOYALTY_PERCENT
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.edible then
		if giver.components.leader then
			if inst.tail and inst.tail.tailanim:value() ~= "wiggle" then
				inst.tail:PlayTailAnim(inst._tailalert and "alert_pst" or "wiggle", "wiggle")
				inst._tailalert = nil
			end
			
			giver:PushEvent("makefriend")
			giver.components.leader:AddFollower(inst)
			
			inst.components.follower:AddLoyaltyTime(TUNING.POLARFOX_LOYALTY_PER_FOOD)
			inst.components.follower.maxfollowtime = giver:HasTag("polite")
				and TUNING.POLARFOX_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS or TUNING.POLARFOX_LOYALTY_MAXTIME
		end
		
		if inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
	end
end

local function OnRefuseItem(inst, item)
	inst.sg:GoToState("refuse")
	
	if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end

local function SleepTest(inst)
	local leader = inst.components.follower and inst.components.follower.leader
	
	if inst.components.combat and inst.components.combat.target or (inst.components.playerprox and inst.components.playerprox:IsPlayerClose() and leader == nil) then
		return false
	end
	
	if not inst.sg:HasStateTag("busy") and (not inst.last_wake_time or GetTime() - inst.last_wake_time >= inst.nap_interval) then
		inst.nap_length = math.random(TUNING.MIN_CATNAP_LENGTH, TUNING.MAX_CATNAP_LENGTH)
		inst.last_sleep_time = GetTime()
		
		return true
	end
end

local function WakeTest(inst)
    if not inst.last_sleep_time or GetTime() - inst.last_sleep_time >= inst.nap_length then
        inst.nap_interval = math.random(TUNING.MIN_CATNAP_INTERVAL, TUNING.MAX_CATNAP_INTERVAL)
        inst.last_wake_time = GetTime()
		
        return true
    end
end

local function OnTimerDone(inst, data)
	
end

local function TailTask(inst)
	if inst.tail == nil then
		inst.tail = SpawnPrefab("polarfox_tail")
		inst.tail:AttachToOwner(inst)
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
	
	inst.Transform:SetFourFaced()
	
	inst.DynamicShadow:SetSize(2, 0.75)
	
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("polarfox")
	inst.AnimState:SetBuild("polarfox")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetScale(1.25, 1.25)
	inst.AnimState:SetSymbolMultColour("tail", 0, 0, 0, 0)
	
	inst:AddTag("animal")
	inst:AddTag("fox")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "body"
	inst.components.combat:SetDefaultDamage(TUNING.POLARFOX_DAMAGE)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({FOODTYPE.MEAT}, {FOODTYPE.MEAT})
	inst.components.eater:SetCanEatRaw()
	
	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = TUNING.POLARFOX_LOYALTY_MAXTIME
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.POLARFOX_HEALTH)
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.POLARFOX_RUN_SPEED
	inst.components.locomotor.walkspeed = TUNING.POLARFOX_WALK_SPEED
	inst.components.locomotor:SetAllowPlatformHopping(true)
	
	inst:AddComponent("embarker")
	
	inst:AddComponent("drownable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("smallmeat", 3)
	inst.components.lootdropper:AddRandomLoot("manrabbit_tail", 1)
	inst.components.lootdropper.numrandomloot = 1
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(5, 7)
	inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
	inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)
	
	local t = GetTime()
	inst.last_wake_time = t
	inst.last_sleep_time = t
	inst.nap_interval = math.random(TUNING.MIN_CATNAP_INTERVAL, TUNING.MAX_CATNAP_INTERVAL)
	inst.nap_length = math.random(TUNING.MIN_CATNAP_LENGTH, TUNING.MAX_CATNAP_LENGTH)
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetWakeTest(WakeTest)
	inst.components.sleeper:SetSleepTest(SleepTest)
	
	inst:AddComponent("timer")
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader:SetAbleToAcceptTest(IsAbleToAccept)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = false
	
	MakeHauntablePanic(inst)
	
	MakeSmallBurnableCharacter(inst, "body", Vector3(1, 0, 1))
	
	MakeSmallFreezableCharacter(inst, "body")
	
	inst:DoTaskInTime(0, TailTask)
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:SetStateGraph("SGpolarfox")
	inst:SetBrain(polarfox_brain)
	
	return inst
end

--

local fx_swap_ids = {9, false, false, 10, false, false, 6, 7, 8} -- {9, 9, 9, 10, 10, 10, 6, 7, 8}

local function TailOnUpdate(inst)
	local owner = inst.components.highlightchild and inst.components.highlightchild.owner
	
	if owner and owner:IsValid() then
		local r, g, b, a = owner.AnimState:GetMultColour()
		inst.AnimState:SetMultColour(r, g, b, a)
		
		r, g, b, a = owner.AnimState:GetAddColour()
		inst.AnimState:SetAddColour(r, g, b, a)
	end
end

local function CreateFxFollowFrame()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("polarfox_tail")
	inst.AnimState:SetBuild("polarfox")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetFinalOffset(-3)
	
	inst:AddComponent("highlightchild")
	
	inst.TailOnUpdate = TailOnUpdate
	
	inst._tailupdate = inst:DoPeriodicTask(FRAMES, inst.TailOnUpdate)
	
	inst.persists = false
	
	return inst
end

local function SetTailAnim(inst, anim, push, loop)
	for i, v in ipairs(inst.fx or {}) do
		v.AnimState:PlayAnimation(anim, loop)
		if not loop and push then
			v.AnimState:PushAnimation(push, true)
		end
	end
end

local function OnTailAnimDirty(inst)
	local anim = inst.tailanim:value() or "idle"
	local push = inst.tailpush:value() or "idle"
	
	SetTailAnim(inst, anim, push, inst.tailloop:value())
end

local function PlayTailAnim(inst, anim, push, loop)
	if anim then
		inst.tailpush:set(push or "idle")
		inst.tailloop:set(loop or false)
		if anim then
			inst.tailanim:set(anim)
		end
		if not TheNet:IsDedicated() then
			SetTailAnim(inst, anim, push, loop)
		end
	end
end

local function fx_OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx or {}) do
		v:Remove()
	end
end

local function fx_SpawnFxForOwner(inst, owner)
	inst.owner = owner
	inst.fx = {}
	
	local fx = CreateFxFollowFrame()
	fx.entity:SetParent(owner.entity)
	fx.Follower:FollowSymbol(owner.GUID, "tail", 0, 0, 0, true)
	fx.components.highlightchild:SetOwner(owner)
	table.insert(inst.fx, fx)
	
	inst.OnRemoveEntity = fx_OnRemoveEntity
end

local function fx_OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	
	if owner then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function fx_AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	
	if not TheNet:IsDedicated() then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function tail()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	inst.tailanim = net_string(inst.GUID, "polarfox_tail.tailanim", "tailanimdirty")
	inst.tailpush = net_string(inst.GUID, "polarfox_tail.tailpush")
	inst.tailloop = net_bool(inst.GUID, "polarfox_tail.tailloop")
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = fx_OnEntityReplicated
		inst:ListenForEvent("tailanimdirty", OnTailAnimDirty)
		
		return inst
	end
	
	inst.persists = false
	
	inst.AttachToOwner = fx_AttachToOwner
	inst.PlayTailAnim = PlayTailAnim
	
	return inst
end

return Prefab("polarfox", fn, assets, prefabs),
	Prefab("polarfox_tail", tail, assets)