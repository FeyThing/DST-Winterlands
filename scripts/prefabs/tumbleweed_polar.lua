local assets = {
	Asset("ANIM", "anim/tumbleweed_polar.zip"),
	Asset("ANIM", "anim/tumbleweed.zip"),
}

local prefabs = {
	"splash_sink",
	"tumbleweed_polarbreakfx",
}

local ANGLE_VARIANCE = 10

local function OnPicked(inst, picker)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	inst:PushEvent("detachchild")
	
	if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
		if math.random() < TUNING.WINTER_FOOD_TUMBLEWIND_CHANCE then
			table.insert(inst.loot, "winter_food2")
			table.insert(inst.lootaggro, false)
		end
		
		if math.random() < TUNING.WINTER_ORNAMENT_TUMBLEWIND_CHANCE then
			local ornament
			local rnd = math.random(6)
			
			if rnd <= 2 then
				ornament = GetRandomBasicWinterOrnament()
			elseif rnd == 3 then
				ornament = GetRandomFancyWinterOrnament()
			elseif rnd == 4 then
				ornament = GetRandomLightWinterOrnament()
			else
				ornament = GetRandomPolarWinterOrnament()
			end
			
			table.insert(inst.loot, ornament)
			table.insert(inst.lootaggro, false)
		end
	end
	
	local item = nil
	for i, v in ipairs(inst.loot) do
		item = inst.components.lootdropper:SpawnLootPrefab(v)
		
		if item then
			item.Transform:SetPosition(x, y, z)
			
			if item.components.inventoryitem and item.components.inventoryitem.ondropfn then
				item.components.inventoryitem.ondropfn(item)
			end
			
			if inst.lootaggro[i] and item.components.combat and picker then
				if not (
					item:HasTag("spider") and (picker:HasTag("spiderwhisperer") or picker:HasTag("spiderdisguise") or (picker:HasTag("monster") and not picker:HasTag("player"))) or
					item:HasTag("frog") and picker:HasTag("merm")) then
					
					item.components.combat:SuggestTarget(picker)
				end
			end
		end
	end
	
	SpawnPrefab("tumbleweed_polarbreakfx").Transform:SetPosition(x, y, z)
	inst.SoundEmitter:PlaySound("meta3/sharkboi/ice_spike")
	
	return true
end

local function OnHaunt(inst, haunter)
	if math.random() <= TUNING.HAUNT_CHANCE_OCCASIONAL then
		if inst.components.pickable then
			inst.components.pickable.onpickedfn(inst, haunter)
		end
	end
	
	return true
end

local function MakeLoot(inst)
	local loot_groups = {
		{weight = 80, 	items = {"ice"}},
		{weight = 7, 	items = {"furtuft", "bluegem_shards", "seeds"}},
		{weight = 5.5, 	items = {"berries", "icelettuce", "icelettuce_seeds"}},
		{weight = 3.5, 	items = {"boneshard", "dug_marsh_bush", "dug_grass", "feather_crow", "feather_robin_winter", "houndstooth", "polarbearfur"}},
		{weight = 2, 	items = {"bluegem", "bird_egg", "rottenegg", "spoiled_fish", "spoiled_fish_small", "blowdart_pipe"}},
		{weight = 1, 	items = {"mole", "polarflea", "polarfox", "rabbit", "spider_dropper", "wobster_sheller_land"}},
		{weight = 0.65, items = {"antler_tree_stick", "blueprint", "cookingrecipecard", "fishsticks", "polartrinket_1", "polartrinket_2", "scrapbook_page"}},
		{weight = 0.35, items = {"purplegem", "greengem"}},
	}
	
	local loot_aggros = {"spider_dropper", "polarflea"}
	
	local groups_weight = 0
	for i, v in ipairs(loot_groups) do
		groups_weight = groups_weight + v.weight
	end
	
	inst.loot = {}
	inst.lootaggro = {}
	
	local num_loots = TUNING.TUMBLEWIND_NUMLOOT
	while num_loots > 0 do
		local next_group = math.random() * groups_weight
		local group = nil
		
		for i, v in ipairs(loot_groups) do
			next_group = next_group - v.weight
			if next_group <= 0 then
				group = v
				break
			end
		end
		
		if group and #group.items > 0 then
			local item = group.items[math.random(#group.items)]
			
			table.insert(inst.loot, item)
			table.insert(inst.lootaggro, table.contains(loot_aggros, item))
			
			num_loots = num_loots - 1
		end
	end
end

--

local function CheckGround(inst)
	if not inst:IsOnValidGround() then
		SpawnPrefab("splash_sink").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:PushEvent("detachchild")
		inst:Remove()
	end
end

local function StartMoving(inst)
	inst.AnimState:PushAnimation("move_loop", true)
	
	inst.bouncepretask = inst:DoTaskInTime(6 * FRAMES, function(inst)
		inst.SoundEmitter:PlaySound("polarsounds/common/tumblewind_bounce")
		inst.bouncetask = inst:DoPeriodicTask(27 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("polarsounds/common/tumblewind_bounce")
			CheckGround(inst)
		end)
	end)
	
	inst.components.blowinwind:Start()
	inst:RemoveEventCallback("animover", StartMoving)
end

local function CancelRunningTasks(inst)
	if inst.bouncepretask then
	   inst.bouncepretask:Cancel()
		inst.bouncepretask = nil
	end
	if inst.bouncetask then
		inst.bouncetask:Cancel()
		inst.bouncetask = nil
	end
	if inst.restartmovementtask then
		inst.restartmovementtask:Cancel()
		inst.restartmovementtask = nil
	end
end

local function OnLongAction(inst)
	inst.AnimState:PlayAnimation("move_pst")
	inst.Physics:Stop()
	
	inst.components.blowinwind:Stop()
	
	inst:RemoveEventCallback("animover", StartMoving)
	CancelRunningTasks(inst)
	
	inst.AnimState:PushAnimation("idle", true)
	inst.restartmovementtask = inst:DoTaskInTime(math.random(2, 6), function(inst)
		if inst and inst.components.blowinwind then
			inst.AnimState:PlayAnimation("move_pre")
			inst.restartmovementtask = nil
			inst:ListenForEvent("animover", StartMoving)
		end
	end)
end

local function DoDirectionChange(inst, data)
	--[[if not inst.last_dir_sfx_time or (GetTime() - inst.last_dir_sfx_time > 5) then
		inst.last_dir_sfx_time = GetTime()
		inst.SoundEmitter:PlaySound("polarsounds/common/tumblewind_choir")
	end]]
	
	if not inst.entity:IsAwake() then
		return
	end
	
	if data and data.angle and data.velocity and inst.components.blowinwind then
		if inst.angle == nil then
			inst.angle = math.clamp(GetRandomWithVariance(data.angle, ANGLE_VARIANCE), 0, 360)
			inst.components.blowinwind:Start(inst.angle, data.velocity)
		else
			inst.angle = math.clamp(GetRandomWithVariance(data.angle, ANGLE_VARIANCE), 0, 360)
			inst.components.blowinwind:ChangeDirection(inst.angle, data.velocity)
		end
	end
end

--

local function OnEntityWake(inst)
	inst.AnimState:PlayAnimation("move_loop", true)
	
	if inst.despawntask then
		inst.despawntask:Cancel()
		inst.despawntask = nil
	end
	
	inst.bouncepretask = inst:DoTaskInTime(6 * FRAMES, function(inst)
		inst.SoundEmitter:PlaySound("polarsounds/common/tumblewind_bounce")
		inst.bouncetask = inst:DoPeriodicTask(27 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("polarsounds/common/tumblewind_bounce")
			CheckGround(inst)
		end)
	end)
end

local function OnEntitySleep(inst)
	CancelRunningTasks(inst)
	
	if inst.despawntask == nil then
		inst.despawntask = inst:DoTaskInTime(10 + math.random(3), inst.Remove)
	end
end

local function OnRemove(inst)
	if TheWorld._numtumblers then
		TheWorld._numtumblers = TheWorld._numtumblers - 1
	end
end

local function OnInit(inst)
	if TheWorld._numtumblers == nil then
		TheWorld._numtumblers = 0
	end
	
	TheWorld._numtumblers = TheWorld._numtumblers + 1
end

--

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	inst.DynamicShadow:SetSize(1.7, 0.8)
	
	MakeCharacterPhysics(inst, 0.5, 1)
	--[[inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.GROUND)
	inst.Physics:CollidesWith(COLLISION.OBSTACLES)
	inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)]]
	
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("tumbleweed_polar")
	inst.AnimState:SetBuild("tumbleweed_polar")
	inst.AnimState:PlayAnimation("move_loop", true)
	
	inst:AddTag("tumblewind")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	MakeLoot(inst)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor:SetTriggersCreep(false)
	
	inst:AddComponent("blowinwind")
	inst.components.blowinwind.soundPath = "dontstarve_DLC001/common/tumbleweed_roll"
	inst.components.blowinwind.soundName = "tumbleweed_roll"
	inst.components.blowinwind.soundParameter = "speed"
	inst.angle = (TheWorld and TheWorld.components.worldwind) and TheWorld.components.worldwind:GetWindAngle() or nil
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("pickable")
	inst.components.pickable.onpickedfn = OnPicked
	inst.components.pickable.canbepicked = true
	inst.components.pickable.jostlepick = true
	inst.components.pickable.remove_when_picked = true

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst.OnEntityWake = OnEntityWake
	inst.OnEntitySleep = OnEntitySleep
	
	inst:ListenForEvent("onremove", OnRemove)
	inst:ListenForEvent("startlongaction", OnLongAction)
	inst:ListenForEvent("windchange", function(world, data)
		DoDirectionChange(inst, data)
	end, TheWorld)
	
	if inst.angle then
		inst.angle = math.clamp(GetRandomWithVariance(inst.angle, ANGLE_VARIANCE), 0, 360)
		inst.components.blowinwind:Start(inst.angle)
	else
		inst.components.blowinwind:StartSoundLoop()
	end
	
	inst:DoTaskInTime(1, OnInit)
	
	return inst
end

local function fx()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("tumbleweed_polar")
	inst.AnimState:SetBuild("tumbleweed_polar")
	inst.AnimState:PlayAnimation("break")
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	inst:ListenForEvent("animover", inst.Remove)
	
	inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + FRAMES, inst.Remove)
	
	return inst
end

return Prefab("tumbleweed_polar", fn, assets, prefabs),
	Prefab("tumbleweed_polarbreakfx", fx, assets)