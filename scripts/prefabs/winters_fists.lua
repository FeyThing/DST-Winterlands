local assets = {
	Asset("ANIM", "anim/swap_wintersfists.zip")
}

local assets_snowball = {
	Asset("ANIM", "anim/snowball.zip")
}

local function IsInSnow(owner)
	if owner == nil or not owner:IsValid() then
		return
	end
	
	local tile, tileinfo = owner:GetCurrentTileType()
	local in_snow = tile and (tile == WORLD_TILES.POLAR_SNOW or (tileinfo and not tileinfo.nogroundoverlays and TheWorld.state.snowlevel and TheWorld.state.snowlevel > 0.15))
	
	return in_snow
end

local function OnEquip(inst, owner)
	owner.SoundEmitter:PlaySound("meta3/sharkboi/ice_spike")
	
	if not inst:HasTag("nosteal") then
		inst:AddTag("nosteal")
		inst._addednosteal = true
	end
	
	if inst._fists == nil then
		inst._fists = SpawnPrefab("winters_fists_over")
		inst._fists:AttachToOwner(owner, nil)
	end
end

local function OnUnequip(inst, owner)
	owner.SoundEmitter:PlaySound("meta3/sharkboi/ice_spike")
	
	if inst._addednosteal then
		inst:RemoveTag("nosteal")
		inst._addednosteal = nil
	end
	
	if inst._fists then
		inst._fists:Remove()
		inst._fists = nil
	end
end

local function OnCharged(inst)
	inst.components.spellcaster.canuseontargets = true
	inst.components.spellcaster.canuseonpoint = true
	inst.components.spellcaster.canuseonpoint_water = true
	inst.components.spellcaster.canusefrominventory = true
	inst.components.spellcaster.canonlyuseonlocomotorspvp = true
end

local function OnDischarged(inst)
	inst.components.spellcaster.canuseontargets = false
	inst.components.spellcaster.canuseonpoint = false
	inst.components.spellcaster.canuseonpoint_water = false
	inst.components.spellcaster.canusefrominventory = false
	inst.components.spellcaster.canonlyuseonlocomotorspvp = false
end

local ICICLE_TAGS = {"bigicicle"}

local function OnUse(inst, target, pos, caster)
	if caster == nil then
		return
	end
	
	local x, y, z = caster.Transform:GetWorldPosition()
	local usesmash = target == caster
	pos = target and target:GetPosition() or pos or caster:GetPosition()
	
	if usesmash then
		local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(x, y, z)
		local terraformer = SpawnPrefab("winters_fists_terraformer")
		
		terraformer.Transform:SetPosition(cx, cy, cz)
		terraformer:DoTerraform()
		
		ShakeAllCameras(CAMERASHAKE.FULL, 0.7, 0.05, 0.25, inst, 16)
		local icicles = TheSim:FindEntities(cx, cy, cz, 16, ICICLE_TAGS)
		for i, icicle in ipairs(icicles) do
			local dist = math.sqrt(icicle:GetDistanceSqToPoint(cx, cy, cz))
			local break_time = 0.5 * (dist / 16)
			
			icicle:DoTaskInTime(break_time, function()
				if icicle:IsValid() and icicle.StartBreaking then
					icicle:StartBreaking()
				end
			end)
		end
		
		local blocker = SpawnPrefab("snowwave_blocker")
		blocker.Transform:SetPosition(cx, cy, cz)
		blocker:SetSnowBlockRange(3)
	elseif pos and caster then
		local angle = caster.Transform:GetRotation() * DEGREES
		--local offset_x = math.cos(angle)
		--local offset_z = -math.sin(angle)
		
		local spelltype = tonumber(inst.spelltype:sub(-1))
		local snowball = SpawnPrefab("winters_fists_snowball")
		snowball.Transform:SetPosition(x, y, z)
		--snowball.Transform:SetPosition(x + offset_x, y, z + offset_z)
		
		snowball:SetSize(spelltype)
		snowball:ThrowAt(pos, caster)
		
		inst._spelltype:set((spelltype >= TUNING.WINTERS_FISTS_SPELL_TYPES and 0 or spelltype) + 1)
	end
	
	if inst.components.rechargeable then
		inst.components.rechargeable:Discharge(usesmash and TUNING.WINTERS_FISTS_TERRAFORMER_COOLDOWN or TUNING.WINTERS_FISTS_SNOWBALL_COOLDOWN)
	end
	if inst.components.finiteuses then
		inst.components.finiteuses:Use(TUNING.WINTERS_FISTS_DURABILITY / (usesmash and 30 or 150))
	elseif inst.components.perishable then
		inst.components.perishable:SetPercent(inst.components.perishable:GetPercent() - (usesmash and 0.033 or 0.006))
	end
end

local function OnSpellTypeDirty(inst)
	local num = inst._spelltype:value() or 1
	inst.spelltype = "WINTERS_FISTS_"..math.clamp(num, 1, TUNING.WINTERS_FISTS_SPELL_TYPES)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("winters_fists")
	inst.AnimState:SetBuild("swap_wintersfists")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("frozen")
	inst:AddTag("icebox_valid")
	inst:AddTag("rechargeable")
	inst:AddTag("show_spoilage")
	inst:AddTag("stickygrip")
	inst:AddTag("toolpunch")
	inst:AddTag("weapon")
	inst:AddTag("wintersfists")
	
	MakeInventoryFloatable(inst, "small", 0.15, 0.9)
	
	inst.spelltype = "WINTERS_FISTS_1"
	inst._spelltype = net_smallbyte(inst.GUID, "winters_fists._spelltype", "spelltypedirty")
	
	inst:ListenForEvent("spelltypedirty", OnSpellTypeDirty)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable.walkspeedmult = TUNING.WINTERS_FISTS_SLOW
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	--[[Gonna use perishable instead because basic ice should repair those a little too... but they don't have finiteuses repairs, by precaution we won't add it ourselves
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.WINTERS_FISTS_DURABILITY)
	inst.components.finiteuses:SetUses(TUNING.WINTERS_FISTS_DURABILITY)
	inst.components.finiteuses:SetOnFinished(inst.Remove)]]
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
	inst.components.insulator:SetSummer()
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(inst.Remove)
	
	inst:AddComponent("rechargeable")
	inst.components.rechargeable:SetOnChargedFn(OnCharged)
	inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
	
	inst:AddComponent("repairable")
	inst.components.repairable.repairmaterial = MATERIALS.ICE
	inst.components.repairable.announcecanfix = false
	
	inst:AddComponent("spellcaster")
	inst.components.spellcaster.canonlyuseoncombat = true
	inst.components.spellcaster.canonlyuseonlocomotorspvp = true
	inst.components.spellcaster.canonlyuseonworkable = true
	inst.components.spellcaster.canuseontargets = true
	inst.components.spellcaster.canuseonpoint = true
	inst.components.spellcaster.canuseonpoint_water = true
	inst.components.spellcaster.canusefrominventory = true
	inst.components.spellcaster.veryquickcast = true
	inst.components.spellcaster:SetSpellFn(OnUse)
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.WINTERS_FISTS_DAMAGE)
	
	MakeHauntableLaunch(inst) -- TODO: use, as smash ?
	
	return inst
end

--

local function FistsOnUpdate(inst)
	local owner = inst.components.highlightchild and inst.components.highlightchild.owner
	
	if owner and owner:IsValid() then
		local r, g, b, a = owner.AnimState:GetMultColour()
		inst.AnimState:SetMultColour(r, g, b, a)
		
		r, g, b, a = owner.AnimState:GetAddColour()
		inst.AnimState:SetAddColour(r, g, b, a)
	end
end

local function CreateFxFollowFrame(i)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("winters_fists")
	inst.AnimState:SetBuild("swap_wintersfists")
	inst.AnimState:PlayAnimation("hand"..i, true)
	inst.AnimState:SetFinalOffset(2)
	
	inst:AddComponent("highlightchild")
	
	inst.FistsOnUpdate = FistsOnUpdate
	
	inst._fistsupdate = inst:DoPeriodicTask(FRAMES, inst.FistsOnUpdate)
	
	inst.persists = false
	
	return inst
end

local function fx_OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx or {}) do
		v:Remove()
	end
end

local function fx_SpawnFxForOwner(inst, owner)
	inst.owner = owner
	inst.fx = {}
	
	for i = 0, 20 do
		local fx = CreateFxFollowFrame(i + 1)
		
		fx.entity:SetParent(owner.entity)
		fx.Follower:FollowSymbol(owner.GUID, "hand", 0, 0, 0, true, nil, i)
		fx.components.highlightchild:SetOwner(owner)
		
		table.insert(inst.fx, fx)
	end
	
	inst.OnRemoveEntity = fx_OnRemoveEntity
end

local function fx_OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	
	if owner then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function fx_AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	
	if not TheNet:IsDedicated() then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function over()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = fx_OnEntityReplicated
		
		return inst
	end
	
	inst.persists = false
	
	inst.AttachToOwner = fx_AttachToOwner
	
	return inst
end

--

local DEFAULT_ORIGINAL_TILE = WORLD_TILES.DIRT

local function DoTerraform(inst, is_load)
	local x, y, z = inst.Transform:GetWorldPosition()
	local radius = TUNING.WINTERS_FISTS_TERRAFORMER_RAD
	local delete = true
	
	for ix = -radius, radius do
		for iz = -radius, radius do
			if (math.abs(ix * ix) + math.abs(iz * iz) <= radius * radius) and (radius - 1 == 0 or not (math.abs(ix * ix) + math.abs(iz * iz) <= radius - 1 * radius - 1)) then
				local fx = x + (ix * TILE_SCALE)
				local fz = z + (iz * TILE_SCALE)
				
				local width, height = TheWorld.Map:GetWorldSize()
				local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(fx, 0, fz)
				
				local nx = (tx - width / 2) * TILE_SCALE
				local nz = (ty - height / 2) * TILE_SCALE
				
				local current_tile = TheWorld.Map:GetTile(tx, ty)
				SpawnPrefab("splash_snow_fx").Transform:SetPosition(nx, y, nz)
				
				if TheWorld.Map:IsVisualGroundAtPoint(nx, 0, nz) and not TileGroupManager:IsTemporaryTile(current_tile) and current_tile ~= WORLD_TILES.FARMING_SOIL then
					if current_tile ~= inst.tile then
						delete = false
					end
					--local old_tile = TheWorld.components.undertile:GetTileUnderneath(tx, ty) or DEFAULT_ORIGINAL_TILE
					local current_undertile = TheWorld.components.undertile:GetTileUnderneath(tx, ty)
					
					TheWorld.Map:SetTile(tx, ty, inst.tile)
					TheWorld.components.undertile:SetTileUnderneath(tx, ty, current_undertile or current_tile)
					
					--TheWorld.components.undertile:ClearTileUnderneath(tx, ty)
					--TheWorld.Map:SetTile(tx, ty, old_tile)
				else
					if TheWorld.components.polarice_manager then
						TheWorld.components.polarice_manager:StartDestroyingIceAtTile(nx, 0, nz, false)
					end
				end
			end
		end
	end
	
	if not is_load then
		if delete then
			inst:Remove()
		elseif inst.components.timer then
			inst.components.timer:StartTimer("undo_terraforming", TUNING.WINTERS_FISTS_TERRAFORMER_DURATION)
		end
	end
end

local function UndoTerraform(inst)
	
end

local function OnTimerDone(inst, data)
	if data.name == "undo_terraforming" then
		inst:UndoTerraform()
	elseif data.name == "remove" then
		inst:Remove()
	end
end

local function terraformer_OnInit(inst)
	if TheWorld.components.snowwaver then
		TheWorld.components.snowwaver:AddEnabler(inst, true)
	end
end

local function terraformer_OnRemove(inst)
	if TheWorld.components.snowwaver then
		TheWorld.components.snowwaver:AddEnabler(inst, false)
	end
end

local function OnEntitySleep(inst)
	if TheWorld.components.snowwaver then
		TheWorld.components.snowwaver:AddEnabler(inst, false)
	end
end

local function OnEntityWake(inst)
	if TheWorld.components.snowwaver then
		TheWorld.components.snowwaver:AddEnabler(inst, true)
	end
end

local function OnSave(inst, data)
	
end

local function OnLoad(inst, data)
	
end

local function terraformer()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	
	inst:DoTaskInTime(0, terraformer_OnInit)
	inst.OnRemoveEntity = terraformer_OnRemove
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._terraforms_to_do = 0
	inst._terraforms_to_undo = 0
	inst._terraformed_tiles = {}
	
	inst.tile = WORLD_TILES.POLAR_SNOW
	inst.DoTerraform = DoTerraform
	inst.UndoTerraform = UndoTerraform
	
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab("winters_fists", fn, assets),
	Prefab("winters_fists_over", over, assets),
	Prefab("winters_fists_terraformer", terraformer)