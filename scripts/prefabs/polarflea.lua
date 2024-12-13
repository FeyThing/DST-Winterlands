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
local RETARGET_CANT_TAGS = {"INLIMBO"}
local RETARGET_ONEOF_TAGS = {"player", "monster"}

local function Retarget(inst)
	return FindEntity(inst, TUNING.POLARFLEA_CHASE_RANGE, function(guy)
		return not guy:HasTag("flea") and inst.components.combat:CanTarget(guy)
	end, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS, RETARGET_ONEOF_TAGS) or nil
end

local function OnPolarstormChanged(inst, active)
	if active and TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst) and not inst.inlimbo then
		inst.components.health:StartRegen(TUNING.POLARFLEA_STORM_REGEN, TUNING.POLARFLEA_STORM_REGEN_RATE)
	else
		inst.components.health:StopRegen()
	end
end

local function HostMaxFleas(inst, host)
	if host._fleacapacity then
		return FunctionOrValue(host._fleacapacity, host)
	elseif host:HasTag("epic") or host:HasTag("largecreature") then
		return TUNING.POLARFLEA_HOST_MAXFLEAS_LARGE
	elseif host:HasTag("prey") then
		return TUNING.POLARFLEA_HOST_MAXFLEAS_SMALL
	end
	
	return TUNING.POLARFLEA_HOST_MAXFLEAS
end

local function CanBeHost(inst, host, capacity_mod)
	if host and host:IsValid() and host.components.health and not host.components.health:IsDead() and host.entity:IsVisible() then
		if host:HasTag("player") then
			return host.components.inventory and not host.components.inventory:IsFull()
		elseif (host._snowfleas and #host._snowfleas or 0) <= inst:HostMaxFleas(host) + (capacity_mod or 0) then
			if host:HasTag("animal") or host:HasTag("character") or host:HasTag("fleahosted") then
				return not (host:HasAnyTag(SOULLESS_TARGET_TAGS) or host:HasTag("fleaghosted") or host:HasTag("fire") or host:HasTag("wet"))
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
		inst.components.timer:StartTimer("findhost", 2 + math.random(TUNING.POLARFLEA_HOST_FINDTIME))
	end
	
	if inst._host then
		inst:RemoveEventCallback("attacked", inst.on_host_attacked, inst._host)
		
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
		
		if kick and inst.onpolarstormchanged and TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst) then
			OnPolarstormChanged(inst, true)
		end
		
		inst._host = nil
		return
	end
	
	inst._host = host
	inst:ListenForEvent("attacked", inst.on_host_attacked, inst._host)
	
	if inst.components.health then
		inst.components.health:StopRegen()
	end
	
	if not given and inst._host:HasTag("player") and inst._host.components.inventory then
		inst._host.components.inventory:GiveItem(inst, nil, inst:GetPosition())
		inst._host:PushEvent("gotpolarflea")
	else
		if inst._host._snowfleas == nil then
			inst._host._snowfleas = {}
		end
		if not table.contains(inst._host._snowfleas, inst) then
			table.insert(inst._host._snowfleas, inst)
		end
		
		inst:RemoveFromScene()
	end
end

local function GetStatus(inst)
	if inst.components.inventoryitem.owner then
		return "HELD"
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

local function OnRemove(inst)
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
	if host then
		if (host.components.health and host.components.health:IsDead()) or math.random() < TUNING.POLARFLEA_HOST_HIT_DROPCHANCE then
			inst:SetHost(nil, true)
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
			if host.components.health and not host.components.health:IsDead() then
				host.components.combat:GetAttacked(inst, TUNING.POLARFLEA_HOST_REMOVE_DAMAGE)
			end
			if inst:IsValid() then
				host.components.inventory:RemoveItem(inst, true)
				host.components.inventory:DropItem(inst, true)
			end
		end)
	end
end

local function HostingInit(inst)
	if TheWorld._numfleas == nil then
		TheWorld._numfleas = 0
	end
	
	TheWorld._numfleas = TheWorld._numfleas + 1
	if inst._host == nil and inst.components.timer and not inst.components.timer:TimerExists("findhost") then
		inst.components.timer:StartTimer("findhost", 2 + math.random(TUNING.POLARFLEA_HOST_FINDTIME))
	end
end

local function OnDropped(inst)
	if inst._host and inst.on_host_grab then
		inst:RemoveEventCallback("murdered", inst.on_host_grab, inst._host)
		inst:RemoveEventCallback("newactiveitem", inst.on_host_grab, inst._host)
		inst.on_host_grab = nil
		
		inst:SetHost(nil, true)
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

local function OnPickedUp(inst)
	if inst._host == nil then
		local owner = inst.components.inventoryitem:GetGrandOwner()
		
		if owner and owner.components.inventory then
			inst:SetHost(owner, nil, true)
		end
	end
	
	if inst.on_host_grab == nil then
		inst.on_host_grab = function(target, data) OnHostGrab(inst, target, data) end
		
		inst:ListenForEvent("murdered", inst.on_host_grab, inst._host)
		inst:ListenForEvent("newactiveitem", inst.on_host_grab, inst._host)
	end
	
	inst.sg:GoToState("idle")
	inst.SoundEmitter:KillAllSounds()
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
	inst:AddTag("hostile")
	inst:AddTag("monster")
	inst:AddTag("smallcreature")
	inst:AddTag("snowhidden")
	
	MakeFeedableSmallLivestockPristine(inst)
	
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
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.POLARFLEA_RUN_SPEED
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
	
	inst:AddComponent("sleeper")
	
	--inst:AddComponent("stackable")
	
	inst:AddComponent("timer")
	
	MakeSmallBurnableCharacter(inst, "bottom")
	
	MakeSmallFreezableCharacter(inst, "bottom")
	
	MakeHauntablePanic(inst)
	
	MakeFeedableSmallLivestock(inst, TUNING.POLARFLEA_STARVE_TIME, OnPickedUp, OnDropped)
	
	inst.CanBeHost = CanBeHost
	inst.HostMaxFleas = HostMaxFleas
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	inst.SetHost = SetHost
	
	inst.on_host_attacked = function(target, data) OnHostAttacked(inst, target, data) end
	inst.onpolarstormchanged = function(src, data)
		if data and data.stormtype == STORM_TYPES.POLARSTORM then
			OnPolarstormChanged(inst, data.setting)
		end
	end
	
	inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	inst:ListenForEvent("onremove", OnRemove)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:SetStateGraph("SGpolarflea")
	inst:SetBrain(brain)
	
	inst:DoTaskInTime(1, HostingInit)
	
	return inst
end

return Prefab("polarflea", fn, assets)