local assets = {
	Asset("ANIM", "anim/polarice_plow.zip"),
}

local prefabs = {
	"polarice_plow",
	"polarice_plow_item_placer",
}

local function OnHammered(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(x, y, z)
	
	if inst.deploy_item_save_record then
		local item = SpawnSaveRecord(inst.deploy_item_save_record)
		item._ice_harvested = inst._ice_harvested
		
		item.Transform:SetPosition(x, y, z)
	end
	
	inst:Remove()
end

local function item_foldup_finished(inst)
	inst:RemoveEventCallback("animqueueover", item_foldup_finished)
	inst.AnimState:PlayAnimation("idle_packed")
	
	inst.components.inventoryitem.canbepickedup = true
end

local function Finished(inst, force_fx)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if inst.deploy_item_save_record then
		local item = SpawnSaveRecord(inst.deploy_item_save_record)
		item._ice_harvested = inst._ice_harvested
		
		item.Transform:SetPosition(x, y, z)
		item.components.inventoryitem.canbepickedup = false
		
		item.AnimState:PlayAnimation("collapse", false)
		item:ListenForEvent("animover", item_foldup_finished)
		
		item.SoundEmitter:PlaySound("polarsounds/plow/drill_pst")
		
		SpawnPrefab("ice_splash").Transform:SetPosition(x, y, z)
		item.SoundEmitter:PlaySound("farming/common/farm/plow/dirt_puff")
	else
		SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
	end
	
	inst:PushEvent("finishplowing")
	inst:Remove()
end

local function OnTerraform(inst, pt, old_tile_type, old_tile_turf_prefab)
	local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(pt:Get())
	local TILE_EXTENTS = TILE_SCALE * 0.9
	local spawned_positions = {}
	
	Finished(inst)
end

local function DoDrilling(inst)
	inst:RemoveEventCallback("animover", DoDrilling)

	inst.AnimState:PlayAnimation("drill_loop", true)
	inst.SoundEmitter:PlaySound("polarsounds/plow/LP", "loop")
	
	local fx_time = 0
	if not inst.components.timer:TimerExists("drilling") then
		inst.components.timer:StartTimer("drilling", TUNING.POLARICE_PLOW_DRILLING_DURATION)
	else
		fx_time = TUNING.POLARICE_PLOW_DRILLING_DURATION - inst.components.timer:GetTimeLeft("drilling")
	end
	
	local pt = inst:GetPosition()
	TheWorld:PushEvent("ms_starticefishingsurprise", {pt = pt, plow = inst})
	
	inst:DoTaskInTime(0, inst.BreakIce)
	inst:DoTaskInTime(2, inst.BreakIce)
	inst:DoTaskInTime(4, inst.BreakIce)
end

local function TimerDone(inst, data)
	if data ~= nil and data.name == "drilling" then
		if inst.components.terraformer ~= nil then
			if not inst.components.terraformer:Terraform(inst:GetPosition()) then
				Finished(inst)
			end
		else
			Finished(inst)
		end
	end
end

local function StartUp(inst)
	inst.AnimState:PlayAnimation("drill_pre")
	inst.SoundEmitter:PlaySound("polarsounds/plow/drill_pre")
	inst:ListenForEvent("animover", DoDrilling)
	
	inst.startup_task = nil
end

local function DoBreakIce(inst, tx, ty, delay)
	if TheWorld.Map:GetTile(tx, ty) == WORLD_TILES.POLAR_ICE then
		inst._ice_demolished = inst._ice_demolished + 1
		TheWorld.components.polarice_manager:StartDestroyingIceAtTile(tx, ty, false, delay, true)
	end
end

local function BreakIce(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
	local step = inst.break_step or 1
	
	if TheWorld.components.polarice_manager then
		inst._ice_demolished = 0
		
		if step == 1 then
			DoBreakIce(inst, tx, ty, 6)
		elseif step == 2 then
			DoBreakIce(inst, tx + 1, ty, 7 + math.random() * 0.5)
			DoBreakIce(inst, tx - 1, ty, 7 + math.random() * 0.5)
			DoBreakIce(inst, tx, ty + 1, 7 + math.random() * 0.5)
			DoBreakIce(inst, tx, ty - 1, 7 + math.random() * 0.5)
		elseif step == 3 then
			DoBreakIce(inst, tx + 1, ty + 1, 6 + math.random() * 0.5)
			DoBreakIce(inst, tx - 1, ty + 1, 6 + math.random() * 0.5)
			DoBreakIce(inst, tx + 1, ty - 1, 6 + math.random() * 0.5)
			DoBreakIce(inst, tx - 1, ty - 1, 6 + math.random() * 0.5)
		end
		
		inst._ice_harvested = (inst._ice_harvested or 0) + inst._ice_demolished
		if not inst._pushed_icesurprise then
			if inst._ice_demolished == 0 then
				TheWorld:DoTaskInTime(step < 3 and 6.5 or 7, function() TheWorld:PushEvent("ms_doicefishingsurprise", {plow = inst}) end)
				inst._pushed_icesurprise = true
			elseif step == 3 then
				TheWorld:DoTaskInTime(7.5, function() TheWorld:PushEvent("ms_doicefishingsurprise", {plow = inst}) end)
				inst._pushed_icesurprise = true
			end
		end
	end
	
	inst.break_step = step + 1
end

local function OnSave(inst, data)
	data.deploy_item = inst.deploy_item_save_record
end

local function OnLoadPostPass(inst, newents, data)
	if data then
		inst.deploy_item_save_record = data.deploy_item
	end
	
	if inst.components.timer:TimerExists("drilling") then
		if inst.startup_task then
			inst.startup_task:Cancel()
			inst.startup_task = nil
		end
		
		DoDrilling(inst)
	end
end

local function main_fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	
	inst:SetDeploySmartRadius(1)
	MakeObstaclePhysics(inst, 0.5)
	
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("polarice_plow")
	inst.AnimState:SetBuild("polarice_plow")
	
	inst:AddTag("polariceplow")
	inst:AddTag("scarytoprey")
	inst:AddTag("walkableperipheral")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("terraformer")
	inst.components.terraformer.turf = WORLD_TILES.POLAR_ICE
	inst.components.terraformer.onterraformfn = OnTerraform
	inst.components.terraformer.plow = true
	
	inst:AddComponent("timer")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
	inst.BreakIce = BreakIce
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	
	inst.startup_task = inst:DoTaskInTime(0, StartUp)
	
	inst:ListenForEvent("timerdone", TimerDone)
	
	return inst
end

local ICE_PROTECT_TAGS = {"icecaveshelter", "polariceplow"}

local function OnDeploy(inst, pt, deployer)
	local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(pt:Get())
	local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(cx, cy, cz)
	
	local valid = TheWorld.Map:GetTile(tx, ty) == WORLD_TILES.POLAR_ICE
	if valid and #TheSim:FindEntities(cx, cy, cz, 12, nil, nil, ICE_PROTECT_TAGS) > 0 then
		valid = false
	end
	
	if valid then
		for dx = -1, 1 do
			for dy = -1, 1 do
				local temp_time = TheWorld.components.polarice_manager:GetTemporaryIceTime(tx + dx, ty + dy)
				if temp_time and type(temp_time) == "number" and temp_time <= 10 then
					valid = false
					break
				end
			end
		end
	end
	
	if not valid then
		if deployer then
			if deployer.components.inventory then
				deployer.components.inventory:GiveItem(inst, nil, pt)
			end
			if deployer.components.talker then
				deployer.components.talker:Say(GetString(deployer, "ANNOUNCE_POLARICE_PLOW_BAD"))
			end
		end
		
		return false
	end
	
	local obj = SpawnPrefab("polarice_plow")
	obj.Transform:SetPosition(cx, cy, cz)
	
	inst.components.finiteuses:Use(1)
	
	if inst:IsValid() then
		obj.deploy_item_save_record = inst:GetSaveRecord()
		inst:Remove()
	end
end

local function OnPickup(inst, owner)
	if inst._ice_harvested and inst._ice_harvested > 0 and owner and owner.components.inventory then
		local ice = SpawnPrefab("ice")
		if ice.components.stackable then
			ice.components.stackable:SetStackSize(inst._ice_harvested)
		end
		
		owner.components.inventory:GiveItem(ice, nil, inst:GetPosition())
		inst._ice_harvested = nil
	end
end

local function can_plow_tile(inst, pt, mouseover, deployer)
	local ents = TheWorld.Map:GetEntitiesOnTileAtPoint(pt.x, 0, pt.z)
	
	for i, ent in ipairs(ents) do
		if ent ~= inst and ent ~= deployer and (ent:HasTag("structure") or ent:HasTag("wall") or ent:HasTag("icecaveshelter")) then
			return false
		end
	end
	
	return TheWorld.Map:IsOceanIceAtPoint(pt.x, 0, pt.z)
end

local function item_fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polarice_plow")
	inst.AnimState:SetBuild("polarice_plow")
	inst.AnimState:PlayAnimation("idle_packed")
	
	inst:AddTag("usedeploystring")
	--inst:AddTag("tile_deploy")	< FARMING MUSIC AAAA
	inst:AddTag("walkableperipheral")
	
	MakeInventoryFloatable(inst, "small", 0.1, 0.8)
	
	inst._custom_candeploy_fn = can_plow_tile
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
	inst.components.deployable.ondeploy = OnDeploy
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.finiteuses:SetMaxUses(TUNING.POLARICE_PLOW_USES)
	inst.components.finiteuses:SetUses(TUNING.POLARICE_PLOW_USES)
	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickup)
	
	MakeHauntableLaunch(inst)
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	
	return inst
end

local function placer_fn()
	local inst = CreateEntity()
	
	inst:AddTag("CLASSIFIED")
	inst:AddTag("NOCLICK")
	inst:AddTag("placer")
	
	inst.entity:SetCanSleep(false)
	inst.persists = false
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	inst.AnimState:SetBank("polarice_plow")
	inst.AnimState:SetBuild("polarice_plow")
	inst.AnimState:PlayAnimation("idle_place")
	inst.AnimState:SetLightOverride(1)
	
	inst:AddComponent("placer")
	inst.components.placer.snap_to_tile = true
	
	inst.outline = SpawnPrefab("tile_outline")
	inst.outline.entity:SetParent(inst.entity)
	
	inst.components.placer:LinkEntity(inst.outline)
	
	return inst
end

return Prefab("polarice_plow", main_fn, assets),
	Prefab("polarice_plow_item", item_fn, assets, prefabs),
	Prefab("polarice_plow_item_placer", placer_fn)