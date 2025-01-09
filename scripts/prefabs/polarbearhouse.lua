require("worldsettingsutil")

local assets = {
	Asset("ANIM", "anim/polarbearhouse.zip"),
}

local prefabs = {
	"polarbear",
	"splash_sink",
}

local DEFAULT_PAINTING = "blue"
local HOUSE_PAINTINGS = {
	"blue",
	"red",
}

local function GetStatus(inst)
	return (inst:HasTag("burnt") and "BURNT") or nil
end

local BEAR_TAGS = {"bear"}

local function OnVacate(inst, child)
	inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
	
	if not inst:HasTag("burnt") and child then
		local x, y, z = child.Transform:GetWorldPosition()
		local child_platform = TheWorld.Map:GetPlatformAtPoint(x, y, z)
		
		if (child_platform == nil and not child:IsOnValidGround()) then
			local fx = SpawnPrefab("splash_sink")
			fx.Transform:SetPosition(x, y, z)
			
			child:Remove()
		elseif child.components.health then
			child.components.health:SetPercent(1)
			
			local free_hat = math.random() < TUNING.POLARBEAR_HAT_CHANCE
			if free_hat then
				local ents = TheSim:FindEntities(x, y, z, 30, BEAR_TAGS)
				for i, v in ipairs(ents) do
					local equipped_hat = v.components.inventory and v.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
					if equipped_hat and equipped_hat.prefab == "polarmoosehat" then
						free_hat = false
						break
					end
				end
			end
			
			if free_hat and child.components.inventory and child.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) == nil then
				local hat = SpawnPrefab("polarmoosehat")
				hat.Transform:SetPosition(x, y, z)
				child.components.inventory:Equip(hat)
			end
			
			if TheWorld.state.iscaveday and child.components.timer and not child.components.timer:TimerExists("plowinthemorning") then
				child.components.timer:StartTimer("plowinthemorning", TUNING.POLARBEAR_PLOWTIME)
				if child:IsAsleep() then
					child.components.timer:PauseTimer("plowinthemorning")
				end
			end
			
			if child.SetPainting then
				child:SetPainting(inst.house_paint)
			end
		end
	end
end

local function OnHammered(inst, worker)
	if inst.components.burnable and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	if inst.doortask then
		inst.doortask:Cancel()
		inst.doortask = nil
	end
	if inst.components.spawner and inst.components.spawner:IsOccupied() then
		inst.components.spawner:ReleaseChild()
	end
	inst.components.lootdropper:DropLoot()
	
	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	
	inst:Remove()
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle")
		
		local child = inst.components.spawner and inst.components.spawner.child
		local prot_range = TUNING.POLARBEAR_PROTECTSTUFF_RANGE
		
		if worker and worker.components.combat and child and child.components.combat and child.components.combat.target == nil and child.components.combat:CanTarget(worker)
			and child.components.health and not child.components.health:IsDead() and child.sg and child:IsNear(inst, prot_range * prot_range)
			and not (child.components.follower and child.components.follower.leader) and not (child:HasTag("INLIMBO") or child:HasTag("sleeping")) then
			
			if worker.components.timer and not worker.components.timer:TimerExists("stealing_bear_stuff") then
				worker.components.timer:StartTimer("stealing_bear_stuff", 2)
			end
			child.components.combat:SuggestTarget(worker)
			child.sg:GoToState("abandon", worker)
		end
	end
end

local function OnStartDayLightTask(inst)
	inst.doortask = nil
	inst.components.spawner:ReleaseChild()
end

local function OnStartDay(inst)
	if not inst:HasTag("burnt") and inst.components.spawner:IsOccupied() then
		if inst.doortask then
			inst.doortask:Cancel()
		end
		
		inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, OnStartDayLightTask)
	end
end

local function SpawnCheckDay(inst)
	inst.inittask = nil
	inst:WatchWorldState("startcaveday", OnStartDay)
	
	if inst.components.spawner and inst.components.spawner:IsOccupied() then
		if not TheWorld.state.iscavenight or (inst.components.burnable and inst.components.burnable:IsBurning()) then
			inst.components.spawner:ReleaseChild()
		end
	end
end

local BLOCKER_CANT_TAGS = {"_inventoryitem", "locomotor", "NOBLOCK", "fx"}

local function customcheckfn(pt)
	return #TheSim:FindEntities(pt.x, pt.y, pt.z, 2, nil, BLOCKER_CANT_TAGS) == 0 and not TheWorld.Map:IsPointNearHole(pt)
end

local function OnInit(inst)
	if inst.house_paint == nil then
		inst:SetPainting(HOUSE_PAINTINGS[math.random(#HOUSE_PAINTINGS)])
	end
	
	if not inst.spawned_brazier and math.random() < TUNING.POLAR_BRAZIER_HOUSE_SPAWN_CHANCE then
		local pt = inst:GetPosition()
		local radius = 3
		
		local offset
		while offset == nil and radius <= 7 do
			offset = FindWalkableOffset(pt, math.random() * TWOPI, GetRandomMinMax(3, 7), 12, false, true, customcheckfn)
			
			if offset then
				local brazier = SpawnPrefab("polar_brazier")
				
				brazier.Transform:SetPosition((pt + offset):Get())
				brazier.house_paint = inst.house_paint
			else
				radius = radius + 1
			end
		end
	end
	inst.spawned_brazier = true
	
	inst.inittask = inst:DoTaskInTime(math.random(), SpawnCheckDay)
	if inst.components.spawner and inst.components.spawner.child == nil and inst.components.spawner.childname and not inst.components.spawner:IsSpawnPending() then
		local child = SpawnPrefab(inst.components.spawner.childname)
		
		if child then
			inst.components.spawner:TakeOwnership(child)
			inst.components.spawner:GoHome(child)
		end
	end
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or (inst.components.burnable and inst.components.burnable:IsBurning()) then
		data.burnt = true
	end
	data.colour = inst.house_paint
	data.spawned_brazier = inst.spawned_brazier
end

local function OnLoad(inst, data)
	if data then
		if data.burnt then
			inst.components.burnable.onburnt(inst)
		end
		if data.colour then
			inst:SetPainting(data.colour)
		end
		inst.spawned_brazier = data.spawned_brazier
	end
end

local function OnPreLoad(inst, data)
	WorldSettings_Spawner_PreLoad(inst, data, TUNING.POLARBEARHOUSE_SPAWN_TIME)
end

local function SetPainting(inst, colour)
	if colour ~= DEFAULT_PAINTING then
		inst.AnimState:OverrideSymbol("base", "polarbearhouse", "base_"..colour)
		inst.AnimState:OverrideSymbol("head", "polarbearhouse", "head_"..colour)
	else
		inst.AnimState:ClearOverrideSymbol("base")
		inst.AnimState:ClearOverrideSymbol("head")
	end
	
	inst.house_paint = colour
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/rabbit_hutch_craft")
	
	inst.spawned_brazier = true -- Lies!
end

local function OnBurntUp(inst)
	if inst.doortask then
		inst.doortask:Cancel()
		inst.doortask = nil
	end
	if inst.inittask then
		inst.inittask:Cancel()
		inst.inittask = nil
	end
end

local function OnIgnite(inst)
	if inst.components.spawner and inst.components.spawner:IsOccupied() then
		inst.components.spawner:ReleaseChild()
	end
end

local function OnPolarstormChanged(inst, active)
	local child = inst.components.spawner and inst.components.spawner.child
	
	if child and active and TheWorld.components.polarstorm and TheWorld.components.polarstorm:GetPolarStormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL then
		if inst._leavestormtask == nil then
			inst._leavestormtask = inst:DoPeriodicTask(1 + math.random() * 3, function()
				if child.components.follower == nil or child.components.follower.leader == nil then
					child:PushEvent("gohome")
				end
			end)
		end
	elseif inst._leavestormtask then
		inst._leavestormtask:Cancel()
		inst._leavestormtask = nil
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	
	inst.MiniMapEntity:SetIcon("polarbearhouse.png")
	
	inst.AnimState:SetBank("polarbearhouse")
	inst.AnimState:SetBuild("polarbearhouse")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_tinybyte(inst.GUID, "polarbearhouse._snowblockrange")
	inst._snowblockrange:set(5)
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	
	inst:AddComponent("spawner")
	WorldSettings_Spawner_SpawnDelay(inst, TUNING.POLARBEARHOUSE_SPAWN_TIME, TUNING.POLARBEARHOUSE_ENABLED)
	inst.components.spawner:Configure("polarbear", TUNING.POLARBEARHOUSE_SPAWN_TIME)
	inst.components.spawner.onvacate = OnVacate
	inst.components.spawner:CancelSpawning()
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	MakeHauntableWork(inst)
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	MakeSnowCovered(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnPreLoad = OnPreLoad
	inst.SetPainting = SetPainting
	
	inst.inittask = inst:DoTaskInTime(0, OnInit)
	inst.onpolarstormchanged = function(src, data)
		if data and data.stormtype == STORM_TYPES.POLARSTORM then
			OnPolarstormChanged(inst, data.setting)
		end
	end
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("burntup", OnBurntUp)
	inst:ListenForEvent("onignite", OnIgnite)
	inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	
	return inst
end

return Prefab("polarbearhouse", fn, assets, prefabs),
	MakePlacer("polarbearhouse_placer", "polarbearhouse", "polarbearhouse", "idle")