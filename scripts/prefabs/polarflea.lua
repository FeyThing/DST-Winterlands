local assets = {
	Asset("ANIM", "anim/polar_flea.zip"),
}

local brain = require("brains/polarfleabrain")

--[[SetSharedLootTable("polarflea", {
	{"monstermeat", 1},
})]]

local function KeepTargetFn(inst, target)
	return target and inst:IsNear(target, 30)
end

local RETARGET_MUST_TAGS = {"_combat"}
local RETARGET_CANT_TAGS = {"INLIMBO", "bearbuddy"}
local RETARGET_ONEOF_TAGS = {"player", "monster", "plant"}

local function Retarget(inst)
	local target = FindEntity(inst, TUNING.POLARFLEA_CHASE_RANGE, function(guy)
		local fleapack
		local inventory = guy.components.inventory
		
		if inventory then
			for k, v in pairs(inventory.equipslots) do
				if v:HasTag("fleapack") and v.components.container then
					fleapack = v
					break
				end
			end
		end
		
		return not guy:HasTag("flea") and inst.components.combat:CanTarget(guy)
			and (fleapack == nil or (fleapack and guy.components.inventory:IsFull() and fleapack.components.container:IsFull()))
	end, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS, RETARGET_ONEOF_TAGS) or nil
	
	return target
end

local function HostMaxFleas(inst, host)
	if host._fleacapacity then
		return FunctionOrValue(host._fleacapacity, host, inst)
	elseif host:HasTag("epic") or host:HasTag("largecreature") then
		return TUNING.POLARFLEA_HOST_MAXFLEAS_LARGE
	elseif host:HasTag("prey") then
		return TUNING.POLARFLEA_HOST_MAXFLEAS_SMALL
	end
	
	return TUNING.POLARFLEA_HOST_MAXFLEAS
end

local function CanBeHost(inst, host, capacity_mod)
	if host and host:IsValid() and not (host.components.health and host.components.health:IsDead()) and host.entity:IsVisible() then
		if host:HasTag("player") then
			local inventory = host.components.inventory
			if inventory then
				for k, v in pairs(inventory.equipslots) do
					if v:HasTag("fleapack") and v.components.container and not v.components.container:IsFull() then
						return true
					end
				end
			end
			
			return not (host:HasAnyTag(SOULLESS_TARGET_TAGS) or host:HasTag("fire") or host:GetIsWet()) and inventory and not inventory:IsFull()
		elseif (host._snowfleas and #host._snowfleas or 0) < inst:HostMaxFleas(host) + (capacity_mod or 0) then
			if not host:HasTag("likewateroffducksback") and (host:HasTag("animal") or host:HasTag("character") or host:HasTag("fleahosted") or host:HasTag("monster")) then
				return not (host:HasAnyTag(SOULLESS_TARGET_TAGS) or host:HasTag("fleaghosted") or host:HasTag("fire") or host:GetIsWet())
			end
		end
	end
	
	return false
end

local function SetHost(inst, host, kick, given)
	if inst.components.timer and inst.components.timer:TimerExists("findhost") then
		inst.components.timer:StopTimer("findhost")
	end
	if kick then
		inst.components.timer:StartTimer("findhost", 5 + math.random(TUNING.POLARFLEA_HOST_FINDTIME))
	end
	
	if inst._host then
		inst:RemoveEventCallback("attacked", inst.on_host_attacked, inst._host)
		inst:RemoveEventCallback("onattackother", inst.on_host_attackother, inst._host)
		
		if inst._host:IsValid() then
			inst.Transform:SetPosition(inst._host.Transform:GetWorldPosition())
			
			if inst._host._snowfleas then
				for i, v in ipairs(inst._host._snowfleas) do
					if v == inst then
						table.remove(inst._host._snowfleas, i)
						break
					--else
						--Hello neighbor, cozy in here isn't it?
					end
				end
			end
		end
	end
	
	if kick or host == nil then
		inst:ReturnToScene()
		
		if inst.components.health then
			inst.components.health:StopRegen()
		end
		
		if inst._host and inst._host:IsValid() and inst._host.components.inventory and inst.components.inventoryitem
			and (inst.components.inventoryitem:GetGrandOwner() == inst._host) then
			
			if inst.on_host_grab then
				inst:RemoveEventCallback("murdered", inst.on_host_grab, inst._host)
				inst:RemoveEventCallback("newactiveitem", inst.on_host_grab, inst._host)
				inst.on_host_grab = nil
			end
			
			inst._host.components.inventory:RemoveItem(inst, true)
			inst._host.components.inventory:DropItem(inst, true)
		end
		inst:PushEvent("fleahostkick", inst._host)
		
		inst._host = nil
		return
	end
	
	inst._host = host
	inst:ListenForEvent("attacked", inst.on_host_attacked, inst._host)
	inst:ListenForEvent("onattackother", inst.on_host_attackother, inst._host)
	
	if inst.components.health then
		inst.components.health:StartRegen(TUNING.POLARFLEA_POCKET_REGEN, TUNING.POLARFLEA_REGEN_RATE)
	end
	
	if not given and inst._host:HasTag("player") and inst._host.components.inventory then
		inst._try_fleapack = true
		inst._host.components.inventory:GiveItem(inst, nil, inst:GetPosition())
		inst._try_fleapack = nil
	else
		if inst._host._snowfleas == nil then
			inst._host._snowfleas = {}
		end
		if not table.contains(inst._host._snowfleas, inst) then
			table.insert(inst._host._snowfleas, inst)
		end
		
		inst:RemoveFromScene()
	end
	
	inst._host:PushEvent("gotpolarflea", {flea = inst, given = given})
end

local function GetStatus(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	
	if owner then
		return owner:HasTag("fleapack") and "HELD_BACKPACK" or "HELD"
	end
end

local function OnSave(inst, data)
	local ents = {}
	
	if inst._host then
		data.host_id = inst._host.GUID
		table.insert(ents, data.host_id)
	end
	
	return ents
end

local function OnLoadPostPass(inst, newents, savedata)
	if savedata then
		if savedata.host_id and newents[savedata.host_id] then
			local host = newents[savedata.host_id].entity
			inst:SetHost(host)
		end
	end
end

local function OnAttacked(inst, data)
	if data and data.attacker then
		inst.components.combat:SetTarget(data.attacker)
		inst.components.combat:ShareTarget(data.attacker, TUNING.POLARFLEA_CHASE_RANGE, function(dude)
			return dude:HasTag("flea") and not dude.components.health:IsDead()
		end, 10)
	end
end

local function OnRemove(inst)
	if inst._host and inst._host._snowfleas then
		for i, v in ipairs(inst._host._snowfleas) do
			if v == inst then
				table.remove(inst._host._snowfleas, i)
				break
			end
		end
	end
	if TheWorld._numfleas then
		TheWorld._numfleas = TheWorld._numfleas - 1
	end
end

local function OnTimerDone(inst, data)
	if data.name == "leavehost" then -- Unused
		inst:SetHost(nil, true)
	elseif data.name == "findhost" then
		if inst._host == nil then
			inst:PushEvent("fleafindhost")
			inst.components.timer:StartTimer("findhost", math.random(TUNING.POLARFLEA_HOST_FINDTIME))
		end
	end
end

local function OnHostAttacked(inst, host, data)
	if host and inst.components.combat then
		local attacker = data and data.attacker
		local isbuddy = attacker and attacker:HasTag("bearbuddy")
		local isflea = attacker and attacker:HasTag("flea")
		local hassack = host.components.inventory and host.components.inventory:EquipHasTag("fleapack")
		
		if (host.components.health and host.components.health:IsDead()) or ((hassack or math.random() < TUNING.POLARFLEA_HOST_HIT_DROPCHANCE) and not isflea) then
			if host.components.inventory then
				host.components.inventory:RemoveItem(inst, true)
				host.components.inventory:DropItem(inst, true)
			else
				inst:SetHost(nil, true)
			end
			
			if attacker and not isflea and not isbuddy then
				inst.components.combat:SetTarget(data.attacker)
			end
		end
	end
end

local function OnHostAttackOther(inst, host, data)
	if host and host.components.inventory and host.components.inventory:EquipHasTag("fleapack") and inst.components.combat then
		local target = data and data.target
		
		if target and not target:HasTag("flea") and not (target.components.health and target.components.health:IsDead())
			and inst.components.combat:CanTarget(target) then
			host.components.inventory:RemoveItem(inst, true)
			host.components.inventory:DropItem(inst, true)
			
			inst.components.combat:SetTarget(data.target)
		end
	end
end

local function OnHostGrab(inst, host, data)
	if data == nil then
		return
	end
	
	local item = data.item or data.victim
	local is_grabbed = item == inst
	
	if is_grabbed and host and inst._host == host and host.components.inventory then
		host:DoTaskInTime(0, function()
			local owner = inst.components.inventory.owner
			if not inst.skip_grab_bite and host.components.health and not host.components.health:IsDead() then
				host.components.combat:GetAttacked(inst, TUNING.POLARFLEA_HOST_REMOVE_DAMAGE)
			end
			
			if inst:IsValid() then
				host.components.inventory:RemoveItem(inst, true)
				host.components.inventory:DropItem(inst, true)
			end
			
			inst.skip_grab_bite = nil
		end)
	end
end

local function HostingInit(inst)
	if TheWorld._numfleas == nil then
		TheWorld._numfleas = 0
	end
	
	TheWorld._numfleas = TheWorld._numfleas + 1
	if inst._host == nil then
		if inst.components.inventoryitem and inst.components.inventoryitem:IsHeld() then
			inst:SetHost(inst.components.inventoryitem:GetGrandOwner())
		elseif inst.components.timer and not inst.components.timer:TimerExists("findhost") then
			inst.components.timer:StartTimer("findhost", 2 + math.random(TUNING.POLARFLEA_HOST_FINDTIME))
		end
	end
end

local function OnInvRefresh(inst, picked, keep_host)
	if picked then
		if inst._host == nil and not keep_host then
			local owner = inst.components.inventoryitem:GetGrandOwner()
			
			if owner and owner.components.inventory then
				inst:SetHost(owner, nil, true)
			end
		end
		
		if inst._host and not keep_host then
			if inst.skip_grab_bite == nil then
				local backpack = inst.components.inventoryitem.owner
				inst.skip_grab_bite = backpack and backpack.components.container and backpack:HasTag("fleapack") or nil
			end
			
			if inst.on_host_grab == nil then
				inst.on_host_grab = function(target, data) OnHostGrab(inst, target, data) end
				
				inst:ListenForEvent("murdered", inst.on_host_grab, inst._host)
				inst:ListenForEvent("newactiveitem", inst.on_host_grab, inst._host)
			end
		end
		
		inst.sg:GoToState("idle")
		inst.SoundEmitter:KillAllSounds()
		
	elseif inst._host then
		if inst.on_host_grab then
			inst:RemoveEventCallback("murdered", inst.on_host_grab, inst._host)
			inst:RemoveEventCallback("newactiveitem", inst.on_host_grab, inst._host)
			inst.on_host_grab = nil
		end
		
		if not keep_host then
			inst:SetHost(nil, true)
		else
			return
		end
		
		if inst.components.stackable and inst.components.stackable:IsStack() then
			local x, y, z = inst.Transform:GetWorldPosition()
			
			while inst.components.stackable:IsStack() do
				local item = inst.components.stackable:Get()
				
				if item then
					if item.components.inventoryitem then
						item.components.inventoryitem:OnDropped()
					end
					item.Physics:Teleport(x, y, z)
				end
			end
		end
	end
end

local function OnDropped(inst)
	inst:OnInvRefresh(false, false)
end

local function OnPickedUp(inst)
	inst:OnInvRefresh(true, false)
end

local function CanMouseThrough(inst)
	return ThePlayer and ThePlayer.replica.inventory and ThePlayer.replica.inventory:EquipHasTag("fleapack")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 5, 0.3)
	
	inst.Transform:SetFourFaced()
	
	inst.DynamicShadow:SetSize(1.25, 0.8)
	
	inst.AnimState:SetBank("polar_flea")
	inst.AnimState:SetBuild("polar_flea")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetScale(0.7, 0.7)
	
	inst:AddTag("canbetrapped")
	inst:AddTag("flea")
	inst:AddTag("insect")
	inst:AddTag("hostile")
	inst:AddTag("monster")
	inst:AddTag("smallcreature")
	inst:AddTag("snowhidden")
	inst:AddTag("NOBLOCK")
	
	MakeFeedableSmallLivestockPristine(inst)
	
	inst.CanMouseThrough = CanMouseThrough
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "bottom"
	inst.components.combat:SetDefaultDamage(TUNING.POLARFLEA_DAMAGE)
	inst.components.combat:SetRange(TUNING.POLARFLEA_ATTACK_RANGE)
	inst.components.combat:SetAttackPeriod(TUNING.POLARFLEA_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(3, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.RARELY)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.POLARFLEA_HEALTH)
	inst.components.health.murdersound = "polarsounds/snowflea/murder"
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.canbepickedupalive = false
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canonlygoinpocketorpocketcontainers = true
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.POLARFLEA_RUN_SPEED
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
	
	inst:AddComponent("sleeper")
	
	inst:AddComponent("timer")
	
	MakeSmallBurnableCharacter(inst, "bottom")
	
	MakeSmallFreezableCharacter(inst, "bottom")
	
	MakeHauntablePanic(inst)
	
	MakeFeedableSmallLivestock(inst, TUNING.POLARFLEA_STARVE_TIME, OnPickedUp, OnDropped)
	
	inst.CanBeHost = CanBeHost
	inst.HostMaxFleas = HostMaxFleas
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnInvRefresh = OnInvRefresh
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	inst.SetHost = SetHost
	
	inst.on_host_attacked = function(target, data) OnHostAttacked(inst, target, data) end
	inst.on_host_attackother = function(target, data) OnHostAttackOther(inst, target, data) end
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onremove", OnRemove)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:SetStateGraph("SGpolarflea")
	inst:SetBrain(brain)
	
	inst:DoTaskInTime(1, HostingInit)
	
	return inst
end

return Prefab("polarflea", fn, assets)