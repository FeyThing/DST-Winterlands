local assets = {
	Asset("ANIM", "anim/polar_flea.zip"),
}

local brain = require("brains/polarfleabrain")

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
				if v:HasTag("fleapack") and v.components.container and v.components.container:IsOpen() then
					fleapack = v
					break
				end
			end
		end
		
		local full
		if fleapack then
			if inst.components.stackable and fleapack.components.upgradeable and fleapack.components.upgradeable:GetStage() >= 2 then
				full = fleapack.components.container:CanAcceptCount(inst, 1) <= 0
			else
				full = inventory:IsFull() and fleapack.components.container:IsFull()
			end
		end
		
		return not guy:HasTag("flea") and inst.components.combat:CanTarget(guy)
			and (fleapack == nil or full)
	end, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS, RETARGET_ONEOF_TAGS)
	
	return target
end

local function ReleaseStack(inst)
	local fleas = {inst}
	
	if inst.components.stackable then
		while inst.components.stackable:StackSize() > 1 do
			local item = inst.components.stackable:Get()
			
			if item then
				if inst.babyflea then
					item.babyflea = true
					item.Transform:SetScale(TUNING.POLARFLEA_BABY_SCALE, TUNING.POLARFLEA_BABY_SCALE, TUNING.POLARFLEA_BABY_SCALE)
					item.AnimState:OverrideSymbol("shell", "polar_flea", "shell_mini")
				end
				
				if item.components.inventoryitem then
					item.components.inventoryitem:OnDropped()
				end
				item.Physics:Teleport(inst.Transform:GetWorldPosition())
				item:PushEvent("fleahostkick", {host = inst._host})
				
				table.insert(fleas, item)
			end
		end
	end
	
	return fleas
end

local function HostCapacity(inst, host)
	local inventory = host.components.inventory or host.components.container
	local max
	
	if not (host.components.container or host:HasTag("player")) then
		max = (host:HasAnyTag({"epic", "largecreature"}) and TUNING.POLARFLEA_HOST_MAXFLEAS_LARGE)
			or (host:HasAnyTag({"_inventoryitem", "prey"}) and TUNING.POLARFLEA_HOST_MAXFLEAS_SMALL)
			or TUNING.POLARFLEA_HOST_MAXFLEAS
	end
	
	if host._fleacapacity then
		local val = FunctionOrValue(host._fleacapacity, host, inst)
		
		max = max and math.min(val, max) or val
	elseif inventory then
		local stackmax = (inst.components.stackable and inst.components.stackable.maxsize) or TUNING.STACK_SIZE_LARGEITEM
		local containers = {inventory}
		
		if host.components.inventory then
			local overflow = host.components.inventory:GetOverflowContainer()
			if overflow then
				table.insert(containers, overflow)
			end
		end
		
		local fleas_in_inv, free = 0, 0
		
		for _, c in ipairs(containers) do
			local maxslots = c.maxslots or c.numslots or 0
			local slots = c.itemslots or c.slots
			
			for i = 1, maxslots do
				local v = slots[i]
				
				if v then
					if v.prefab == inst.prefab then
						if v.components.stackable then
							fleas_in_inv = fleas_in_inv + v.components.stackable:StackSize()
							free = free + v.components.stackable:RoomLeft()
						else
							fleas_in_inv = fleas_in_inv + 1
						end
					end
				elseif c:CanTakeItemInSlot(inst, i) then
					free = free + (c:AcceptsStacks() and stackmax or 1)
				end
			end
		end
		
		if max then
			max = math.min(math.max(0, max - fleas_in_inv), free)
		else
			max = free
		end
	end
	
	local current = (not inventory and host._snowfleas and #host._snowfleas) or 0
	
	return math.max((max or 0) - current, 0)
end

local function CanBeHost(inst, host)
	inst._try_hosting = true
	
	local function test_hosting()
		if host and host:IsValid() and not (host.components.health and host.components.health:IsDead()) and host.entity:IsVisible() and inst:HostCapacity(host) > 0 and
			not host:HasAnyTag({"fire", "fleaghosted", "likewateroffducksback", "smallcreature"}) then
			
			--	Player logic
			if host:HasTag("player") then
				local inventory = host.components.inventory
				if inventory then
					for k, v in pairs(inventory.equipslots) do
						if v:HasTag("fleapack") and v.components.container and v.components.container:IsOpen() and v.components.container:CanAcceptCount(inst, 1) > 0 then
							return true
						end
					end
				end
				
				return not host:HasAnyTag(SOULLESS_TARGET_TAGS) and inventory and not inventory:IsFull() and not host:GetIsWet()
			--	Anything else...
			else
				--	Containers logic
				if host.components.container and host.components.container.canbeopened then
					if host.components.container:CanAcceptCount(inst, 1) > 0 then
						return true
					end
				end
				
				--	Creatures logic
				if host:HasAnyTag({"animal", "character", "monster", "fleahosted"}) then
					return not host:HasAnyTag(SOULLESS_TARGET_TAGS) and not host:GetIsWet()
				end
			end
		end
		
		return false
	end
	
	local can_host = test_hosting()
	inst._try_hosting = nil
	
	return can_host
end

local function SetHost(inst, host, kick, given)
	if inst.components.timer then
		if inst.components.timer:TimerExists("findhost") then
			inst.components.timer:StopTimer("findhost")
		end
		
		if kick then
			inst.components.timer:StartTimer("findhost", 5 + math.random(TUNING.POLARFLEA_HOST_FINDTIME))
		end
	end
	
	--	Removing old host
	
	if inst._host then
		inst:RemoveEventCallback("onignite", inst.on_host_attacked, inst._host)
		inst:RemoveEventCallback("attacked", inst.on_host_attacked, inst._host)
		inst:RemoveEventCallback("onattackother", inst.on_host_attackother, inst._host)
		inst:RemoveEventCallback("onpickup", inst.on_host_pickedup, inst._host)
		inst:RemoveEventCallback("picked", inst.on_host_pickedup, inst._host)
		inst:RemoveEventCallback("worked", inst.on_host_pickedup, inst._host)
		
		if inst._host:IsValid() then
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
		local inventory = inst._host and (inst._host.components.inventory or inst._host.components.container)
		
		if inventory and inst.components.inventoryitem and inst.components.inventoryitem:IsHeld() then
			inventory:RemoveItem(inst, true)
			inventory:DropItem(inst, true)
		else
			inst:ReturnToScene()
		end
		
		if inst.components.health then
			inst.components.health:StopRegen()
		end
		if inst.components.stackable == nil then
			inst:AddComponent("stackable")
			inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
			inst.skinname = nil
		end
		
		inst:PushEvent("fleahostkick", {host = inst._host})
		inst._host = nil
		
		return
	end
	
	local pt = inst:GetPosition()
	if inst.components.knownlocations then
		inst.components.knownlocations:RememberLocation("home", pt)
	end
	
	--	Setting new host
	
	inst._host = host
	if inst._host == nil or not inst._host:IsValid() then
		return -- Shouldn't happen
	end
	
	inst:ListenForEvent("onignite", inst.on_host_attacked, inst._host)
	inst:ListenForEvent("attacked", inst.on_host_attacked, inst._host)
	inst:ListenForEvent("onattackother", inst.on_host_attackother, inst._host)
	inst:ListenForEvent("onpickup", inst.on_host_pickedup, inst._host)
	inst:ListenForEvent("picked", inst.on_host_pickedup, inst._host)
	inst:ListenForEvent("worked", inst.on_host_pickedup, inst._host)
	
	if inst.components.health then
		inst.components.health:StartRegen(TUNING.POLARFLEA_POCKET_REGEN, TUNING.POLARFLEA_REGEN_RATE)
	end
	if inst.components.follower and inst.components.follower.leader then
		inst.components.follower:SetLeader(nil)
	end
	
	local inventory = inst._host.components.inventory or inst._host.components.container
	if inventory then
		if inst.components.inventoryitem and not inst.components.inventoryitem:IsHeld() then
			inst._try_hosting = true -- Needed for fleas to go in pockets and prioritize Itchhiker Pack
			inventory:GiveItem(inst, nil, pt)
			inst._try_hosting = nil
		end
	else
		if inst._host._snowfleas == nil then
			inst._host._snowfleas = {} -- Only used for things without inv
		end
		if not table.contains(inst._host._snowfleas, inst) then
			table.insert(inst._host._snowfleas, inst)
		end
		
		inst:RemoveFromScene()
	end
	
	local fleapack = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if not (fleapack and fleapack.components.upgradeable and fleapack.components.upgradeable:GetStage() >= 2) then
		inst:RemoveComponent("stackable")
		inst.skinname = "unstackable_flea"
	end
	
	inst._host:PushEvent("gotpolarflea", {flea = inst, given = given})
end

local function GetStatus(inst, viewer)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	
	if owner and owner:HasTag("fleapack") then
		return "HELD_BACKPACK"
	end
	
	return owner == viewer and "HELD_INV" or nil -- HELD is autocompleted by game but we use another logic
end

--	Host events

local function OnHostAttacked(inst, host, data) -- This is for both onattacked and onignite
	if host and inst.components.combat then
		local attacker = data and (data.attacker or data.doer)
		local isbuddy = attacker and attacker:HasTag("bearbuddy")
		local isflea = attacker and attacker:HasTag("flea")
		
		local release_chance = ((host.components.burnable and host.components.burnable:IsBurning())
			or (host.components.health and host.components.health:IsDead())) and 1 or TUNING.POLARFLEA_HOST_HIT_DROPCHANCE
		
		local fleapack
		if host.components.inventory then
			for k, v in pairs(host.components.inventory.equipslots) do
				if v:HasTag("fleapack") then
					fleapack = v
					break
				end
			end
		end
		
		if fleapack then
			release_chance = (fleapack.components.container == nil or fleapack.components.container:IsOpen()) and 1 or 0
		end
		
		if math.random() <= release_chance and not isflea then
			local fleas = ReleaseStack(inst)
			inst:SetHost(nil, true)
			
			if attacker and not isflea and not isbuddy then
				for i, v in ipairs(fleas) do
					if v.components.combat then
						v.components.combat:SetTarget(attacker)
					end
				end
			end
		end
	end
end

local function OnDeath(inst, data)
	local killer = data and data.afflicter
	
	if killer and (killer:HasTag("character") or killer:HasTag("monster")) then
		TheWorld:PushEvent("motherflea_triggered", {victim = inst})
	end
end

local function OnHostAttackOther(inst, host, data)
	if host and inst.components.combat then
		local fleapack
		if host.components.inventory then
			for k, v in pairs(host.components.inventory.equipslots) do
				if v:HasTag("fleapack") then
					fleapack = v
					break
				end
			end
		end
		
		if fleapack then
			if fleapack.components.container and not fleapack.components.container:IsOpen() then
				return
			else
				local target = data and data.target
				if target and not target:HasTag("flea") and not (target.components.health and target.components.health:IsDead())
					and inst.components.combat:CanTarget(target) then
					
					local fleas = ReleaseStack(inst)
					inst:SetHost(nil, true)
					
					for i, v in ipairs(fleas) do
						if v.components.combat then
							v.components.combat:SetTarget(target)
						end
					end
				end
			end
		end
	end
end

local function OnHostPickedUp(inst, host, data) -- This is for both items, pickables and workables
	if host and not host.components.container and inst.components.combat then
		local picker = data and (data.picker or data.owner or data.worker)
		local isbuddy = picker and picker:HasTag("bearbuddy")
		local isflea = picker and picker:HasTag("flea")
		
		local fleas = ReleaseStack(inst)
		inst:SetHost(nil, true)
		
		if picker and not isflea and not isbuddy then
			for i, v in ipairs(fleas) do
				if v.components.combat then
					v.components.combat:SetTarget(picker)
				end
			end
		end
	end
end

--	Inventory

local function OnBecomeActiveItem(inst, doer)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	local prevcontainer = inst.prevcontainer and inst.prevcontainer.inst
	
	-- Fleas are intended to bite in the pocket they are stored. So players, chesters, etc, but not in backpacks
	if inst._host and inst._host.components.combat and inst._host == owner and
		not (prevcontainer and prevcontainer:HasTag("fleapack")) then -- Itchhiker Pack transfers ownership
		
		inst._host.components.combat:GetAttacked(inst, TUNING.POLARFLEA_HOST_REMOVE_DAMAGE)
	end
	
	inst:DoTaskInTime(0, function()
		local inventory = inst._host and (inst._host.components.inventory or inst._host.components.container)
		
		if inst:IsValid() then
			ReleaseStack(inst)
			
			if inventory then
				inventory:RemoveItem(inst, true)
				inventory:DropItem(inst, true)
			end
			
			local doer_inv = doer and doer.components.inventory
			if doer_inv then
				doer_inv:RemoveItem(inst, true)
				doer_inv:DropItem(inst, true)
			end
			
			inst:SetHost(nil, true)
		end
	end)
end

local function OnMurdered(inst, data)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	
	if owner and owner.components.combat then
		owner.components.combat:GetAttacked(inst, TUNING.POLARFLEA_HOST_REMOVE_DAMAGE)
	end
end

--

local function OnSave(inst, data)
	local ents = {}
	
	if inst._host then
		data.host_id = inst._host.GUID
		table.insert(ents, data.host_id)
	end
	data.babyflea = inst.babyflea or nil
	
	return ents
end

local function OnLoad(inst, data)
	if data then
		if data.babyflea then
			inst.babyflea = data.babyflea or nil
			inst.Transform:SetScale(TUNING.POLARFLEA_BABY_SCALE, TUNING.POLARFLEA_BABY_SCALE, TUNING.POLARFLEA_BABY_SCALE)
			inst.AnimState:OverrideSymbol("shell", "polar_flea", "shell_mini")
		end
	end
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
	if inst._host and inst._host._snowfleas then
		for i, v in ipairs(inst._host._snowfleas) do
			if v == inst then
				table.remove(inst._host._snowfleas, i)
				break
			end
		end
	end
	
	if TheWorld._numfleas and not inst.babyflea then
		TheWorld._numfleas = TheWorld._numfleas - 1
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

local function HostingInit(inst)
	if not inst.babyflea then
		TheWorld._numfleas = (TheWorld._numfleas or 0) + 1
	end
	
	if inst._host == nil then
		local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
		
		if owner then
			inst:SetHost(inst.components.inventoryitem:GetGrandOwner())
		elseif owner == nil and inst.components.timer and not inst.components.timer:TimerExists("findhost") then
			inst.components.timer:StartTimer("findhost", 2 + math.random(TUNING.POLARFLEA_HOST_FINDTIME))
		end
	end
	
	local container = inst.components.inventoryitem.owner
	if inst._host and not (container and container:HasTag("fleapack") and container.components.upgradeable and container.components.upgradeable:GetStage() >= 2) then
		inst:RemoveComponent("stackable")
		inst.skinname = "unstackable_flea"
	end
	
	inst._try_hosting = nil
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
	inst.Physics:ClearCollidesWith(COLLISION.CHARACTERS)
	
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
	
	-- Important on load or containers will kick our bum out, otherwise this is useful to let fleas pick their pocket space, while restricting player inv actions
	inst._try_hosting = true
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "bottom"
	inst.components.combat:SetDefaultDamage(TUNING.POLARFLEA_DAMAGE)
	inst.components.combat:SetRange(TUNING.POLARFLEA_ATTACK_RANGE)
	inst.components.combat:SetAttackPeriod(TUNING.POLARFLEA_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(3, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	inst.components.combat:SetPlayerStunlock(PLAYERSTUNLOCK.RARELY)
	
	inst:AddComponent("follower")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.POLARFLEA_HEALTH)
	inst.components.health.murdersound = "polarsounds/snowflea/murder"
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.onactiveitemfn = OnBecomeActiveItem
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.canbepickedupalive = false
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.POLARFLEA_RUN_SPEED
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
	
	inst:AddComponent("sleeper")
	
	inst:AddComponent("timer")
	
	MakeSmallBurnableCharacter(inst, "bottom")
	
	MakeSmallFreezableCharacter(inst, "bottom")
	
	MakeHauntablePanic(inst)
	
	MakeFeedableSmallLivestock(inst, TUNING.POLARFLEA_STARVE_TIME)
	
	inst.CanBeHost = CanBeHost
	inst.HostCapacity = HostCapacity
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass
	inst.SetHost = SetHost
	
	inst.on_host_attacked = function(target, data) OnHostAttacked(inst, target, data) end
	inst.on_host_attackother = function(target, data) OnHostAttackOther(inst, target, data) end
	inst.on_host_pickedup = function(target, data) OnHostPickedUp(inst, target, data) end
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("fleabiteback", OnMurdered)
	inst:ListenForEvent("onremove", OnRemove)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:SetStateGraph("SGpolarflea")
	inst:SetBrain(brain)
	
	inst:DoTaskInTime(0, HostingInit)
	
	return inst
end

return Prefab("polarflea", fn, assets)