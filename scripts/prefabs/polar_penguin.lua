--	NOTE: This file auto copies the basic penguin mainfuction to (hopefully) keep up to date with changes with Penguins,
--	useful, but risky so check this file for possible maintenance if penguins change in a way we don't want these to replicate !!

--	The Pengulls in the Winterlands are "flipped" version of vanilla Pengulls,
--	which despawn in winter (they leave for the mainland), while they return and stay at home for rest of the time

local assets = Prefabs.penguin.assets

local prefabs = Prefabs.penguin.deps

local brain = require("brains/polar_penguinbrain")

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 20
local MAX_CHASEAWAY_DIST_SQ = 40 * 40

local function KeepTarget(inst, target)
	local pos = inst.components.knownlocations and (inst.components.knownlocations:GetLocation("herd") or inst.components.knownlocations:GetLocation("rookery"))
	if pos and target:GetDistanceSqToPoint(pos:Get()) < MAX_CHASEAWAY_DIST_SQ then
		return true
	elseif inst.components.combat.lastwasattackedbytargettime + 3 >= GetTime() then
		return true
	end
	
	return false
end

local function RetargetFn(inst)
	-- Does nothing, but won't crash from not having teamattacker
end

--

local function CheckAutoRemove(inst)
	local curseason = POLARRIFY_MOD_SEASONS[TheWorld.state.season] or "autumn"
	
	if curseason == "winter" then
		inst:Remove()
	end
end

--[[NOTE: For now we'll try to use drownable... but I don't quite trust that so we may switch back!
local function OnPolarFreeze(inst, forming)
	if not forming then
		inst:Remove()
	end
end]]

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

local function OnInit(inst)
	inst.OnEntityWake = CheckAutoRemove
	inst.OnEntitySleep = CheckAutoRemove
end

local function fn()
	local inst = Prefabs.penguin.fn()
	
	inst:AddTag("polar_penguin")
	inst:AddTag("herdmember")
	
	inst:SetPrefabNameOverride("penguin")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.combat then
		inst.components.combat:SetKeepTargetFunction(KeepTarget)
		inst.components.combat:SetRetargetFunction(1, RetargetFn)
	end
	
	inst:AddComponent("drownable")
	
	if inst.components.herdmember then
		inst.components.herdmember.herdprefab = "polar_penguinherd"
		inst.components.herdmember.enabled = false -- These seems to be a bug that causes lots of herds to appear in the same area. Testing if this solves it?
	end
	
	inst:RemoveComponent("hunger")
	
	if inst.components.locomotor then
		inst.components.locomotor.pathcaps = {allowocean = true}
	end
	
	inst:RemoveComponent("teamattacker")
	
	--inst.OnPolarFreeze = OnPolarFreeze
	
	inst:SetBrain(brain)
	
	inst:ListenForEvent("attacked", OnAttacked)
	
	inst:DoTaskInTime(0, OnInit)
	
	return inst
end

--	Herd

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

return Prefab("polar_penguin", fn, assets, prefabs),
	Prefab("polar_penguinherd", herd)