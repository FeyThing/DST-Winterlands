local assets = {
	Asset("ANIM", "anim/polar_throne.zip"),
}

local assets_gifts = {
	Asset("ANIM", "anim/polar_throne_gifts.zip"),
}

local function NoIceOrHoles(pt)
	return not TheWorld.Map:IsOceanIceAtPoint(pt:Get()) and not TheWorld.Map:IsPointNearHole(pt)
end

local function SpawnGifts(inst, sack)
	local loot = TheWorld.components.klaussackloot and TheWorld.components.klaussackloot:GetLoot() or nil
	if loot == nil or not IsTableEmpty(inst.throne_gifts) then
		return
	end
	
	local dist = TUNING.POLAR_THRONE_GIFTRING_DIST
	local dtheta = TWOPI / #loot
	local x, y, z = inst.Transform:GetWorldPosition()
	
	for theta = math.random() * dtheta, TWOPI, dtheta do
		local x1 = x + dist * math.cos(theta)
		local z1 = z + dist * math.sin(theta)
		
		local offset
		local pt = Vector3(x1, y, z1)
		local radius = 1
		
		while offset == nil and radius < TUNING.POLAR_THRONE_GIFTRING_MAX_OFFSET do
			offset = FindWalkableOffset(pt, math.random() * TWOPI, radius, 12, true, false, NoIceOrHoles)
			radius = radius + 1
		end
		
		if offset then
			local gift = SpawnPrefab("polar_throne_gifts")
			gift.Transform:SetPosition((pt + offset):Get())
			inst.throne_gifts[gift] = true
			
			if gift.components.unwrappable then
				local loot_i = math.random(#loot)
				local items = loot[loot_i]
				
				for i, v in ipairs(items) do
					if type(v) == "string" then
						items[i] = SpawnPrefab(v)
					else
						items[i] = SpawnPrefab(v[1])
						items[i].components.stackable:SetStackSize(v[2])
					end
				end
				
				gift.components.unwrappable:WrapItems(items)
				gift._throne = inst
				
				gift.AnimState:PlayAnimation("pick"..gift.anim_var)
				gift.AnimState:PushAnimation("idle"..gift.anim_var, false)
				
				table.remove(loot, loot_i)
			end
		end
	end
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain")
	inst.SoundEmitter:PlaySound("dontstarve/common/dropGeneric")
end

local function DespawnGifts(inst, sack)
	for gift, v in pairs(inst.throne_gifts) do
		gift:DoGiftFade(nil, nil, true)
	end
	
	inst.throne_gifts = {}
end

local function ReleaseKrampi(inst, opened_gift, player)
	local added_time = 0 - (TUNING.THRONE_KRAMPUS_STAY_ADD_TIME * 3) -- Add some more time
	
	for gift, v in pairs(inst.throne_gifts) do
		gift._throne_activated = true
		
		if gift ~= opened_gift and gift:IsValid() then
			added_time = added_time + TUNING.THRONE_KRAMPUS_STAY_ADD_TIME
			if gift.components.unwrappable then
				gift.components.unwrappable.canbeunwrapped = false
			end
			
			if gift.ReleaseKrampus then
				gift:DoTaskInTime(1.5 + math.random() * 2, gift.ReleaseKrampus, player, opened_gift)
			end
		end
	end
	
	inst._krampus_stay_addedtime = added_time > 0 and added_time or nil
	inst.waiting_for_next_sack = true
end

--

local function OnSave(inst, data)
	local ents = {}
	local gift_ids = {}
	
	data.sack_cooldown = inst.waiting_for_next_sack
	if inst.waiting_for_sack and inst.waiting_for_sack:IsValid() then
		data.sack_id = inst.waiting_for_sack.GUID
		table.insert(ents, inst.waiting_for_sack.GUID)
	end
	
	if not IsTableEmpty(inst.throne_gifts) then
		for gift, v in pairs(inst.throne_gifts) do
			table.insert(ents, gift.GUID)
			table.insert(gift_ids, gift.GUID)
		end
		
		data.gift_ids = gift_ids
	end
	
	return ents
end

local function OnLoadPostPass(inst, newents, savedata)
	if savedata then
		inst.waiting_for_next_sack = savedata.sack_cooldown
		if savedata.sack_id and newents[savedata.sack_id] then
			inst.waiting_for_sack = newents[savedata.sack_id].entity
			
			inst:ListenForEvent("ms_respawnthronegifts", inst._onsackopened, TheWorld)
			inst:ListenForEvent("onremove", inst._onsackremoved, inst.waiting_for_sack)
		end
		
		if savedata.gift_ids then
			for i, gift_id in ipairs(savedata.gift_ids) do
				if newents[gift_id] then
					local gift = newents[gift_id].entity
					
					inst.throne_gifts[gift] = true
					gift._throne = inst
				end
			end
		end
	end
end

--

local function OnSackSpawned(inst, sack)
	if sack and not inst.waiting_for_sack then
		inst.waiting_for_sack = sack
		
		inst:DespawnGifts(sack)
		inst:ListenForEvent("onremove", inst._onsackremoved, sack) -- When removed (end of season or whatever) ... only respawn gifts if they weren't used
		inst:ListenForEvent("ms_respawnthronegifts", inst._onsackopened, TheWorld) -- When opened with stash key, just respawn gifts
	end
end

local function OnSackRemoved(inst, sack, despawned)
	if sack then
		if not despawned or (despawned and not inst.waiting_for_next_sack) then
			inst:SpawnGifts(sack)
		end
		inst:RemoveEventCallback("onremove", inst._onsackremoved, sack)
		inst:RemoveEventCallback("ms_respawnthronegifts", inst._onsackopened, TheWorld)
		
		inst.waiting_for_sack = nil
	end
end

local function OnInit(inst)
	local sack = TheSim:FindFirstEntityWithTag("polarthrone_emptier")
	
	if sack then
		inst._onsackspawned(nil, sack)
	elseif not inst.waiting_for_sack and not inst.waiting_for_next_sack then
		inst:SpawnGifts()
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.65)
	
	inst.MiniMapEntity:SetIcon("polar_throne.png")
	inst.MiniMapEntity:SetPriority(3)
	
	inst.DynamicShadow:SetSize(2, 1)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("polar_throne")
	inst.AnimState:SetBuild("polar_throne")
	inst.AnimState:PlayAnimation("idle")
	
	--inst:AddTag("faced_chair")
	inst:AddTag("polarthrone")
	inst:AddTag("rotatableobject")
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_tinybyte(inst.GUID, "polar_throne._snowblockrange")
	inst._snowblockrange:set(12)
	
	if not TheNet:IsDedicated() then
		inst:AddComponent("pointofinterest")
		inst.components.pointofinterest:SetHeight(270)
	end
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.throne_gifts = {}
	
	inst.Transform:SetRotation(math.random() * 360)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("savedrotation")
	inst.components.savedrotation.dodelayedpostpassapply = true
	
	--inst:AddComponent("sittable") TODO: could be nice for later, but it will not be too simple
	
	MakeHauntableLaunch(inst)
	
	inst.SpawnGifts = SpawnGifts
	inst.DespawnGifts = DespawnGifts
	inst.ReleaseKrampi = ReleaseKrampi
	
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	
	inst._onsackopened = function(src, sack)
		OnSackRemoved(inst, sack)
	end
	inst._onsackremoved = function(sack)
		OnSackRemoved(inst, sack, true)
	end
	inst._onsackspawned = function(src, sack)
		OnSackSpawned(inst, sack)
	end
	
	if not TUNING.SPAWN_POLAR_THRONE then
		inst:RemoveFromScene()
	else
		inst._gifttask = inst:DoTaskInTime(1, OnInit)
		inst:ListenForEvent("ms_registerklaussack", inst._onsackspawned, TheWorld)
	end
	
	return inst
end

--

local NUM_VARS = 3

local function DoGiftFade(inst, doanim, doer, skip)
	if inst._gift_fading then
		return
	end
	inst._gift_fading = true
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	
	if doanim then
		inst.AnimState:PlayAnimation("pick"..inst.anim_var)
	end
	
	if not skip and not inst._throne_activated and inst._throne and inst._throne:IsValid() then
		inst._throne:ReleaseKrampi(inst, doer)
	end
	ErodeAway(inst)
end

local function Enjoy(doer)
	if doer.components.talker and doer.sg then
		doer.components.talker:Say(GetString(doer, "ANNOUNCE_THRONE_GIFT_TAKEN"))
		
		if doer.components.combat and GetTime() - (doer.components.combat.lastwasattackedtime or 0) > 10 then
			doer.sg:GoToState("emote", {anim = "research", randomanim = false, mounted = true})
		end
	end
end

local function OnWrapped(inst, num, doer)
	
end

local function OnUnwrapped(inst, pos, doer)
	if not inst._throne_activated then
		if inst.burnt then
			SpawnPrefab("ash").Transform:SetPosition(pos:Get())
		else
			local fx = SpawnPrefab("gift_unwrap")
			fx.Transform:SetPosition(pos:Get())
			
			inst.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
		end
	end
	
	if doer and doer:IsValid() then
		doer:DoTaskInTime(0.25 + math.random(), Enjoy)
	end
	
	inst:DoGiftFade(true, doer)
end

local function OnBurnt(inst)
	inst.burnt = true
	inst.components.unwrappable:Unwrap()
end

local function OnIgnite(inst)
	if inst.components.unwrappable then
		inst.components.unwrappable.canbeunwrapped = false
	end
end

local function OnExtinguish(inst)
	if inst.components.unwrappable then
		inst.components.unwrappable.canbeunwrapped = true
	end
end

local BUNDLED_ITEM_TAGS = {"_inventoryitem"}
local BUNDLED_ITEM_NOT_TAGS = {"INLIMBO"}

local function ReleaseKrampus(inst, player)
	local items
	
	local krampus = SpawnPrefab("krampus")
	local x, y, z = inst.Transform:GetWorldPosition()
	krampus.Transform:SetPosition(x, y, z)
	
	if krampus.sg then
		krampus.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke")
		
		local rdm = math.random()
		local state = (rdm <= 0.33 and "idle")
			or (rdm <= 0.66 and "sleeping")
			or "taunt"
		
		local sleep_time = TUNING.THRONE_KRAMPUS_SLEEP_TIME
		if state == "sleeping" and krampus.components.sleeper and sleep_time > 0 then
			krampus.components.sleeper:GoToSleep(sleep_time)
		end
		krampus.sg:GoToState(state)
	end
	
	if inst.components.unwrappable and krampus.components.inventory then
		inst.components.unwrappable:Unwrap(krampus)
		
		local ents = TheSim:FindEntities(x, y, z, 3, BUNDLED_ITEM_TAGS, BUNDLED_ITEM_NOT_TAGS)
		for i, v in ipairs(ents) do
			if v:GetTimeAlive() < 0.1 then
				krampus.components.inventory:GiveItem(v, nil, v:GetPosition())
			end
		end
	end
	
	if krampus.DoThroneCombat then
		krampus:DoThroneCombat(player)
	end
	
	inst:DoGiftFade(true)
end

local function gifts()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("polar_throne_gifts")
	inst.AnimState:SetBuild("polar_throne_gifts")
	
	inst:AddTag("thronegift")
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_tinybyte(inst.GUID, "polar_throne_gifts._snowblockrange")
	inst._snowblockrange:set(4)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.anim_var = math.random(NUM_VARS)
	inst.AnimState:PlayAnimation("idle"..inst.anim_var)
	
	local color = 0.7 + math.random() * 0.3
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	local scale = math.random() <= 0.5 and 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnWrappedFn(OnWrapped)
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	
	MakeLargeBurnable(inst, TUNING.MED_BURNTIME)
	MakeLargePropagator(inst)
	inst.components.propagator.flashpoint = 10 + math.random() * 5
	inst.components.burnable:SetOnBurntFn(OnBurnt)
	inst.components.burnable:SetOnIgniteFn(OnIgnite)
	inst.components.burnable:SetOnExtinguishFn(OnExtinguish)
	
	inst.DoGiftFade = DoGiftFade
	inst.ReleaseKrampus = ReleaseKrampus
	
	if not TUNING.SPAWN_POLAR_THRONE then
		inst:RemoveFromScene()
	end
	
	return inst
end

return Prefab("polar_throne", fn, assets),
	Prefab("polar_throne_gifts", gifts, assets_gifts)