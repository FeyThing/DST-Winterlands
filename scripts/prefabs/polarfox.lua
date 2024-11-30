local assets = {
	Asset("ANIM", "anim/polarfox.zip"),
}

local prefabs = {
	"polarfox_tail",
}

local snowhuntPrefabs = {
	rabbit = 7,
	mole = 1,
}

local polarfox_brain = require("brains/polarfoxbrain")

local function KeepTargetFn(inst, target)
	return target and inst:IsNear(target, 30)
end

local function OnChangedLeader(inst, new, old)
	if new then
		if inst._trusted_survivors == nil then
			inst._trusted_survivors = {}
		end
		inst._trusted_survivors[new.prefab] = true
	end
	
	if inst.tail and inst.tail.tailanim:value() ~= "wiggle" then
		local anim = new and "wiggle" or "idle"
		inst.tail:PlayTailAnim(inst.wantstoalert and "alert_pst" or anim, anim)
		inst.wantstoalert = nil
	end
end

local function GetStatus(inst, viewer)
	return (inst.components.follower and inst.components.follower.leader ~= nil and "FOLLOWER")
		or (inst._trusted_survivors and inst._trusted_survivors[viewer.prefab] and "FRIEND")
		or nil
end

local function OnPlayerDrop(inst, player, data)
	local item = data and data.item
	
	if item and item:IsValid() and item.components.edible and inst.components.eater and inst.components.eater:CanEat(item) then
		if inst._trusted_foods == nil then
			inst._trusted_foods = {}
		end
		
		inst._trusted_foods[item] = player
	end
end

local function ListenForPlayerDrops(inst, disable)
	if inst._listened_surivors == nil then
		inst._listened_surivors = {}
	end
	
	if disable then
		for i, v in pairs(inst._listened_surivors) do
			inst:RemoveEventCallback("dropitem", inst.OnPlayerDrop, v)
		end
		inst._listened_surivors = {}
	else
		local x, y, z = inst.Transform:GetWorldPosition()
		local players = FindPlayersInRange(x, y, z, 20, true)
		
		for i, v in ipairs(players) do
			if not table.contains(inst._listened_surivors, v) then
				inst:ListenForEvent("dropitem", inst.OnPlayerDrop, v)
				table.insert(inst._listened_surivors, v)
			end
		end
	end
end

local function OnPlayerNear(inst, player)
	if inst.components.follower and inst.components.follower.leader == nil and inst.components.combat and inst.components.combat.target == nil then
		if inst.tail and not inst.wantstoalert then
			inst.tail:PlayTailAnim("alert_pre", "alert_loop")
		end
		
		if inst.sg and (inst.sg:HasStateTag("foxwalk") or inst.sg:HasStateTag("idle")) and inst.components.locomotor
			and (inst._trusted_foods == nil or IsTableEmpty(inst._trusted_foods)) then
			
			inst.components.locomotor:StopMoving()
			inst.sg:GoToState("_alert")
		end
		
		inst.last_wake_time = GetTime()
		inst.wantstoalert = true
		
		if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
		
		if inst._droptask == nil then
			inst._droptask = inst:DoPeriodicTask(0.2, inst.ListenForPlayerDrops)
		end
	end
end

local function OnPlayerFar(inst, player)
	if inst.tail and inst.wantstoalert then
		inst.tail:PlayTailAnim("alert_pst", "idle")
	end
	
	if inst._droptask then
		inst._droptask:Cancel()
		inst._droptask = nil
		
		inst:ListenForPlayerDrops(true)
	end
	
	inst.wantstoalert = nil
end

local function OnEat(inst, food, feeder)
	if food and inst._trusted_foods and inst._trusted_foods[food] then
		if inst.components.follower and inst.components.follower.leader == nil then
			local player = inst._trusted_foods[food]
			
			if player:IsValid() and player.components.leader then
				player:PushEvent("makefriend")
				player.components.leader:AddFollower(inst)
				
				inst.components.follower:AddLoyaltyTime(TUNING.POLARFOX_LOYALTY_PER_FOOD)
				inst.components.follower.maxfollowtime = player:HasTag("polite")
					and TUNING.POLARFOX_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
					or TUNING.POLARFOX_LOYALTY_MAXTIME
			end
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
	end
	
	return true
end

local function ShouldAcceptItem(inst, item, giver)
	if inst.components.eater:CanEat(item) and inst.components.follower then
		if giver and inst._trusted_survivors and not inst._trusted_survivors[giver.prefab] then
			return false
		end
		
		return inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= TUNING.PIG_FULL_LOYALTY_PERCENT
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.edible then
		if giver.components.leader then
			giver:PushEvent("makefriend")
			giver.components.leader:AddFollower(inst)
			
			inst.components.follower:AddLoyaltyTime(TUNING.POLARFOX_LOYALTY_PER_FOOD)
			inst.components.follower.maxfollowtime = giver:HasTag("polite")
				and TUNING.POLARFOX_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
				or TUNING.POLARFOX_LOYALTY_MAXTIME
			
			if inst._droptask then
				inst._droptask:Cancel()
				inst._droptask = nil
				
				inst:ListenForPlayerDrops(true)
			end
			
			inst._trusted_foods = nil
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
	
	if leader and inst:GetDistanceSqToInst(leader) >= TUNING.POLARFOX_LEADER_RUN_DIST / 2 then
		return false
	end
	
	if not inst.sg:HasStateTag("busy") and (not inst.last_wake_time or GetTime() - inst.last_wake_time >= inst.nap_interval) then
		inst.nap_length = math.random(TUNING.MIN_CATNAP_LENGTH, TUNING.MAX_CATNAP_LENGTH)
		inst.last_sleep_time = GetTime()
		
		return true
	end
end

local function WakeTest(inst)
	local leader = inst.components.follower and inst.components.follower.leader
	
	if not inst.last_sleep_time
		or (GetTime() - inst.last_sleep_time >= inst.nap_length)
		or (leader and inst:GetDistanceSqToInst(leader) >= TUNING.POLARFOX_LEADER_RUN_DIST / 2) then
		
		inst.nap_interval = math.random(TUNING.MIN_CATNAP_INTERVAL, TUNING.MAX_CATNAP_INTERVAL)
		inst.last_wake_time = GetTime()
		
		return true
	end
end

--

local function OnSave(inst, data)
	if inst._trusted_survivors and not IsTableEmpty(inst._trusted_survivors) then
		data.trusted_survivors = inst._trusted_survivors
	end
end

local function OnLoad(inst, data)
	if data then
		inst._trusted_survivors = data.trusted_survivors
	end
end

local function NoHoles(pt)
	return not TheWorld.Map:IsPointNearHole(pt)
end

local function HuntRandomPrey(inst, tier)
	local pt = inst:GetPosition()
	local offset = FindWalkableOffset(pt, math.random() * TWOPI, 2, 8, true, false, NoHoles)
	
	if offset then
		local preyfab = weighted_random_choice(inst.snowhuntPrefabs)
		local prey = SpawnPrefab(preyfab)
		
		if prey then
			prey.Transform:SetPosition((pt + offset):Get())
		end
		TheWorld:PushEvent("spawned_snowhuntprey", {prey = prey, hunter = inst})
	end
end

--

local function OnAttacked(inst, data)
	inst.wantstoalert = nil
	inst.wantstosit = nil
	
	if inst.tail then
		inst.tail:PlayTailAnim("hit", (inst.components.follower and inst.components.follower.leader ~= nil) and "wiggle" or "idle")
	end
	
	if data and data.attacker then
		inst.components.combat:SetTarget(data.attacker)
		
		if inst._trusted_survivors then
			inst._trusted_survivors[data.attacker.prefab] = nil
		end
	end
end

local function OnLootPrefabSpawned(inst, data)
	if data and data.loot and data.loot.prefab == "manrabbit_tail" then
		inst.AnimState:HideSymbol("tail")
	end
end

local function OnTimerDone(inst, data)
	-- TODO: time to hunt for bunnies in the snow... also cooldown for bird hunting
end

--

local function TailSwip(inst)
	if not inst.sg:HasStateTag("moving") and not inst.wantstoalert and not inst.sg:HasStateTag("busy") then
		if inst.tail then
			inst.tail:PlayTailAnim("swip", (inst.components.follower and inst.components.follower.leader ~= nil) and "wiggle" or "idle")
		end
		
		inst.SoundEmitter:PlaySound("polarsounds/polarfox/sniff_low")
	end
	
	inst._tailswip = inst:DoTaskInTime(0.5 + (math.random() * 24.5), TailSwip)
end

local function TailTask(inst)
	if inst.tail == nil then
		inst.tail = SpawnPrefab("polarfox_tail")
		inst.tail:AttachToOwner(inst)
	end
	
	if inst._tailswip == nil then
		TailSwip(inst)
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
	
	inst.Transform:SetSixFaced()
	
	inst.DynamicShadow:SetSize(1.7, 1)
	
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("polarfox")
	inst.AnimState:SetBuild("polarfox")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetScale(1.25, 1.25)
	inst.AnimState:SetSymbolBloom("glowfx")
	inst.AnimState:SetSymbolLightOverride("glowfx", 0.7)
	inst.AnimState:SetSymbolMultColour("tail", 0, 0, 0, 0)
	
	inst:AddTag("animal")
	inst:AddTag("fox")
	inst:AddTag("snowhidden")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "body"
	inst.components.combat:SetDefaultDamage(TUNING.POLARFOX_DAMAGE)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({FOODTYPE.MEAT}, {FOODTYPE.MEAT})
	inst.components.eater:SetCanEatRaw()
	inst.components.eater:SetOnEatFn(OnEat)
	
	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = TUNING.POLARFOX_LOYALTY_MAXTIME
	inst.components.follower.OnChangedLeader = OnChangedLeader
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.POLARFOX_HEALTH)
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
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
	inst.components.playerprox:SetDist(8, 10)
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
	inst.components.freezable:SetResistance(6)
	inst.components.freezable:SetDefaultWearOffTime(3)
	
	inst.snowhuntPrefabs = snowhuntPrefabs
	inst.HuntRandomPrey = HuntRandomPrey
	inst.ListenForPlayerDrops = ListenForPlayerDrops
	inst.OnPlayerDrop = function(player, data) OnPlayerDrop(inst, player, data) end
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:DoTaskInTime(0, TailTask)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("loot_prefab_spawned", OnLootPrefabSpawned)
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
		if not loop and push and push ~= "__" then
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
		inst.tailpush:set(push or "__")
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