local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function OnPolarFreeze(inst, forming)
	inst:DoTaskInTime(0, function()
		if inst.components.floater then
			if forming or inst.stage == "empty" or inst.stage == "dryup" then
				inst.components.floater:OnNoLongerLandedServer()
			elseif not forming then
				inst.components.floater:OnLandedServer()
			end
		end
	end)
end

local OldSetStage
local function SetStage(inst, stage, source, ...)
	local x, y, z = inst.Transform:GetWorldPosition()
	if inst.stage == "empty" and stage ~= "dryup" and TheWorld.Map:GetPlatformAtPoint(x, y, z) then
		stage = "empty" -- Don't allow icebergs to grow if there's a boat atop
	end
	
	if inst._canpolarise and IsInPolar(inst) and (source == nil or source == "grow" or source == "melt") then
		stage = "tall"
		
		local grow_tries = 0
		while inst.stage and inst.stage ~= stage and grow_tries < 5 do
			grow_tries = grow_tries + 1
			OldSetStage(inst, stage, source, ...)
		end
	else
		OldSetStage(inst, stage, source, ...)
	end
	
	if inst.stage == "empty" or inst.stage == "dryup" then
		inst.AnimState:Hide("snow")
		
		if inst.components.floater then
			inst.components.floater:OnNoLongerLandedServer()
		end
	else
		if inst.components.waterphysics then
			inst:RemoveComponent("waterphysics")
		end
		MakeWaterObstaclePhysics(inst, 1, 2, 0.75)
		
		if inst.components.floater then
			inst.components.floater:OnLandedServer()
		end
	end
	
	if not TheWorld.Map:IsPassableAtPoint(x, y, z) and inst._puddle then
		inst._puddle:Hide()
	end
end

local function OnPolarInit(inst, ismastersim)
	local hide_puddle = false
	
	if ismastersim and TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(inst) then
		inst:Remove()
	elseif IsInPolar(inst) then
		if ismastersim then
			inst._canpolarise = true
			SetStage(inst, "tall", "grow")
		end
		
		hide_puddle = true
	end
	
	if not TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) then
		hide_puddle = true
	end
	if hide_puddle and inst._puddle then
		inst._puddle:Hide()
	end
end

local function DoWorkedBy_GameThread(inst, worker, numworks)
	if inst.components.workable then
		local snap_to_stage = worker and worker:HasTag("boat") and not worker:HasTag("shadowminion")
		if snap_to_stage then
			worker:AddTag("shadowminion") -- This helps replicate the 1 stage only destruction that sharkboi_ice_hazard has but basic rock_ice don't
		end
		
		inst.components.workable:WorkedBy(worker, numworks)
		
		if snap_to_stage then
			worker:RemoveTag("shadowminion")
		end
	end
end

local function OnCollide(inst, data)
	local boat_physics = (data and data.other) and data.other.components.boatphysics
	
	if boat_physics then
		local damage_scale = 0.5
		local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * damage_scale / boat_physics.max_velocity + 0.5)
		
		if hit_velocity > 0 then
			inst:DoTaskInTime(0, DoWorkedBy_GameThread, data.other, hit_velocity * TUNING.ICE_MINE)
		end
	end
end

ENV.AddPrefabPostInit("rock_ice", function(inst)
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "rock_ice._snowblockrange")
	inst._snowblockrange:set(3)
	
	inst:SetPhysicsRadiusOverride(2) -- Helps mining those at sea
	
	if inst.components.floater == nil then
		inst:AddTag("floaterobject")
		inst:AddTag("ignorewalkableplatforms")
		
		MakeInventoryFloatable(inst, "large", nil, 0.85)
		inst.components.floater.bob_percent = 0
	end
	
	inst:DoTaskInTime(0.1, OnPolarInit, TheWorld.ismastersim) -- Stage change should be delayed because OnLoad begs to restore saved stage first
	
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.workable and OldSetStage == nil then
		OldSetStage = PolarUpvalue(inst.components.workable.onwork, "SetStage")
		
		if OldSetStage then
			PolarUpvalue(inst.components.workable.onwork, "SetStage", SetStage)
		end
	end
	
	inst.OnPolarFreeze = OnPolarFreeze
	
	if not (inst.event_listeners.on_collide and inst.event_listeners.on_collide[inst]) then
		inst:ListenForEvent("on_collide", OnCollide) -- In case some vanilla on_collide event ever gets added... skip, probably because it's the same thing
	end
end)

ENV.AddPrefabPostInit("sharkboi_ice_hazard", function(inst)
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "rock_ice._snowblockrange")
	inst._snowblockrange:set(3)
	
	inst:SetPhysicsRadiusOverride(2)
	
	if not TheWorld.ismastersim then
		return
	end
	
	inst.OnPolarFreeze = OnPolarFreeze
end)