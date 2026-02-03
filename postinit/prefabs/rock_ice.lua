local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function OnPolarFreeze(inst, forming)
	--[[if not forming then
		DestroyEntity(inst, TheWorld, true, true)
	end]]
	
	if inst.components.floater then
		inst.components.floater:OnLandedServer()
	end
end

local OldSetStage
local function SetStage(inst, stage, source, ...)
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
	
	if inst.stage == "empty" then
		--if TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) then
			inst.AnimState:Hide("snow")
		--else
		--	inst:Remove()
		--end
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
	if ismastersim and inst.components.floater then
		inst.components.floater:OnLandedServer()
	end
	
	if hide_puddle and inst._puddle then
		inst._puddle:Hide()
	end
end

ENV.AddPrefabPostInit("rock_ice", function(inst)
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "rock_ice._snowblockrange")
	inst._snowblockrange:set(3)
	
	inst:SetPhysicsRadiusOverride(2) -- Helps mining those at sea
	
	if inst.components.floater == nil then
		inst:AddTag("floaterobject")
		
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