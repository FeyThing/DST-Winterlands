local assets = {
	Asset("ANIM", "anim/walrus_beartrap.zip"),
}

local TRAP_TARGET_TAGS = {"_combat", "locomotor"}
local TRAP_TARGET_NOT_TAGS = {"flight", "flying", "noattack", "notarget", "playerghost", "INLIMBO", "isdead", "brightmare", "shadowcreature", "structure", "wall"}
local TRAP_CANT_SNARE_TAGS = {"wereplayer"} -- TODO: Wereplayer should be snare-able but we have to animate it first!

local ITEM_FLING_TAGS = {"_inventoryitem"}
local ITEM_FLING_NOT_TAGS = {"INLIMBO", "_health"}

--	On Events

local function LaunchTrap(inst, speed)
	local angle = math.random(360)
	inst.Physics:SetVel(speed * math.cos(angle), 3 + math.random() * 2, speed * math.sin(angle))
end

local function OnTargetAttacked(inst, target, data)
	if data and data.attacker and data.attacker ~= inst then
		inst:DoTrapStruggle(target)
	end
end

local function OnAnimOver(inst)
	if inst.AnimState:IsCurrentAnimation("trap") then
		local x, y, z = inst.Transform:GetWorldPosition()
		local target = FindEntity(inst, TUNING.WALRUS_BEARTRAP_RADIUS, function(guy)
			return guy.Physics and not guy:HasTag("walrus_beartrapped") and not (guy.sg and guy.sg:HasStateTag("nointerrupt"))
		end, TRAP_TARGET_TAGS, TRAP_TARGET_NOT_TAGS)
		
		local mount = (target and target.components.rider) and target.components.rider:GetMount() or nil
		local snared = false
		
		if target then
			if target.components.combat and target.components.health and not target.components.health:IsDead() then
				target.components.combat:GetAttacked(inst, TUNING.WALRUS_BEARTRAP_DAMAGE)
			end
			target = mount or target
			
			if not target:HasAnyTag(TRAP_CANT_SNARE_TAGS) and not (inst.components.health and inst.components.health:GetPercent() <= 0) then
				snared = ((not target:HasTag("epic") or target:HasTag("bearger")) or inst._walrus_beartrap_snareable) and not inst._walrus_beartrap_notsnareable
			end
			inst.SoundEmitter:PlaySound("polarsounds/walrus/trap_bear_trigger")
		else
			inst.SoundEmitter:PlaySound("polarsounds/walrus/trap_bear_miss")
		end
		
		LaunchTrap(inst, target and 1 or 2)
		
		if snared then
			inst.AnimState:PlayAnimation("trap_loop", true)
			inst:SetTrapTarget(target, true)
		else
			local item = FindEntity(inst, TUNING.WALRUS_BEARTRAP_RADIUS, nil, ITEM_FLING_TAGS, ITEM_FLING_NOT_TAGS)
			if item then
				item.components.inventoryitem:DoDropPhysics(x, y, z, true)
			end
			
			inst.AnimState:PushAnimation("trap_pst", false)
			inst.AnimState:PushAnimation("inactive", false)
			
			if inst.components.inventoryitem then
				inst.components.inventoryitem.canbepickedup = true
			end
			if inst.components.workable then
				inst.components.workable:SetWorkable(true)
			end
			if inst.components.finiteuses then
				inst.components.finiteuses:Use(1)
			end
		end
		
		local fx = SpawnPrefab("walrus_beartrap_snapfx")
		fx.Transform:SetPosition(x, y - 1, z)
		fx.Transform:SetScale(1.5, 1.5, 1.5)
	end
end

--	Mine behaviours

local function TrapTestTimeFn()
	return 0.1
end

local function OnExplode(inst, target)
	inst:RemoveTag("canbait")
	inst.AnimState:PlayAnimation("trap") -- OnAnimOver takes care of the rest
	inst.proxytrap_activated:set(false)
end

local function OnReset(inst)
	inst:AddTag("canbait")
	inst:RemoveTag("mine_not_reusable")
	inst:RemoveTag("NOCLICK")
	
	if inst.components.mine then
		inst.components.mine:SetAlignment("nobody")
	end
	if inst.components.inventoryitem then
		inst.components.inventoryitem.canbepickedup = false
	end
	if inst.components.workable then
		inst.components.workable:SetWorkable(false)
	end
	
	inst.AnimState:PlayAnimation("idle_invisible")
	if not inst.proxytrap_activated:value() then
		inst.SoundEmitter:PlaySound("polarsounds/walrus/trap_bear_reset")
		inst.proxytrap_activated:set(true)
	end
end

local function SetSprung(inst)
	inst:RemoveTag("canbait")
	inst.AnimState:PlayAnimation("inactive")
	
	if inst.components.inventoryitem then
		inst.components.inventoryitem.canbepickedup = true
	end
	if inst.components.workable then
		inst.components.workable:SetWorkable(true)
	end
	inst.proxytrap_activated:set(false)
end

local function SetInactive(inst)
	inst:RemoveTag("canbait")
	inst:RemoveTag("mine_not_reusable")
	inst:RemoveTag("NOCLICK")
	inst.AnimState:PlayAnimation("inactive")
	
	if inst.components.inventoryitem then
		inst.components.inventoryitem.canbepickedup = true
	end
	if inst.components.workable then
		inst.components.workable:SetWorkable(true)
	end
	inst.proxytrap_activated:set(false)
end

--	Trap behaviours

local function DoTrapUpdate(inst, target)
	if target and target:IsValid() then
		local range = TUNING.WALRUS_BEARTRAP_RADIUS * TUNING.WALRUS_BEARTRAP_RADIUS
		
		-- Mounts are the ones being snared, but are in limbo while in use, first we wait for them to buck off the rider...
		if not (target.components.rideable and target.components.rideable:GetRider() ~= nil) then
			if target._walrus_beartrap == nil or target:HasAnyTag(TRAP_CANT_SNARE_TAGS) or target:HasAnyTag(TRAP_TARGET_NOT_TAGS) or inst:GetDistanceSqToInst(target) > range then
				inst:SetTrapTarget(target)
				inst.AnimState:PlayAnimation("trap_pst")
				return
			end
			
			if not target:HasTag("walrus_beartrapped") and not target:HasTag("player") then -- Not an ent with auto-struggle. Needs help from the trap !
				if inst._autostruggle_task == nil then
					local struggletime = math.random(TUNING.WALRUS_BEARTRAP_AUTOSTRUGGLE_TIMES.min, TUNING.WALRUS_BEARTRAP_AUTOSTRUGGLE_TIMES.max)
					
					inst._autostruggle_task = inst:DoTaskInTime(struggletime, inst.DoTrapStruggle, target)
				end
			end
		end
		
		target.Transform:SetPosition(inst.Transform:GetWorldPosition())
		target.Physics:Stop()
	end
end

local function DoTrapStruggle(inst, target, rescued)
	inst.struggle_lefts = rescued and 0 or (inst.struggle_lefts or 1) - 1
	local released = rescued or inst.struggle_lefts <= 0
	
	if not rescued and target:IsValid() and target.components.combat then
		target.components.combat:GetAttacked(inst, TUNING.WALRUS_BEARTRAP_STRUGGLE_DAMAGE)
	end
	
	local isdead = target.components.health and target.components.health:IsDead()
	if not isdead then
		LaunchTrap(inst, released and 2 or 1)
		inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_mech_med_dull")
	end
	
	if inst._autostruggle_task then
		inst._autostruggle_task:Cancel()
		inst._autostruggle_task = nil
	end
	
	if released then
		if not isdead then
			inst.AnimState:PlayAnimation("trap_pst")
		end
		inst:SetTrapTarget(target, false)
		
		if inst.components.mine then
			inst.components.mine:Deactivate()
			inst.components.mine.issprung = true
		end
		
		if inst.components.finiteuses then
			inst.components.finiteuses:Use(1)
		end
	end
end

local function SetTrapTarget(inst, target, trapped)
	local isvalid = target and target:IsValid()
	
	target._walrus_beartrap = trapped and inst or nil
	inst._target = target or nil
	
	inst.struggle_lefts = trapped and (math.random(TUNING.WALRUS_BEARTRAP_STRUGGLES_REQUIRED.min, TUNING.WALRUS_BEARTRAP_STRUGGLES_REQUIRED.max
		+ (target.components.houndedtarget and TUNING.WALRUS_BEARTRAP_STRUGGLES_REQUIRED.unlucky_added or 0)) -- :o)
		+ (not target:HasTag("player") and TUNING.WALRUS_BEARTRAP_STRUGGLES_REQUIRED.mob_added or 0))
		or nil
	
	if inst.components.inventoryitem then
		inst.components.inventoryitem.canbepickedup = not trapped
	end
	if inst.components.workable then
		inst.components.workable:SetWorkable(not trapped)
	end
	
	if target.components.locomotor and isvalid then
		if trapped then
			target.components.locomotor:SetExternalSpeedMultiplier(target, "walrus_beartrapped", 0)
		else
			target.components.locomotor:RemoveExternalSpeedMultiplier(target, "walrus_beartrapped")
		end
	end
	
	if inst._autostruggle_task then
		inst._autostruggle_task:Cancel()
		inst._autostruggle_task = nil
	end
	if inst._trap_update then
		inst._trap_update:Cancel()
		inst._trap_update = nil
	end
	
	if trapped and isvalid then
		target.Transform:SetPosition(inst.Transform:GetWorldPosition())
		target.Physics:Stop()
		
		inst._target_mass = (inst._target_mass or target.Physics:GetMass()) or nil
		if inst._target_mass then
			target.Physics:SetMass(TUNING.WALRUS_BEARTRAP_TEMP_MASS_OVERRIDE)
		end
		inst._trap_update = inst:DoPeriodicTask(0.1, DoTrapUpdate, 0.5, target)
		
		inst:ListenForEvent("attacked", inst._target_attacked, target)
		inst:ListenForEvent("onremove", inst._target_removed, target)
	else
		if inst._target_mass and isvalid then
			target.Physics:SetMass(inst._target_mass)
			inst._target_mass = nil
		end
		
		inst:RemoveEventCallback("attacked", inst._target_attacked, target)
		inst:RemoveEventCallback("onremove", inst._target_removed, target)
	end
	
	inst:AddOrRemoveTag("mine_not_reusable", trapped)
	inst:AddOrRemoveTag("NOCLICK", trapped)
	target:AddOrRemoveTag("walrus_beartrapped_auto", trapped)
	target:PushEvent("walrus_beartrapped", {trap = inst, captured = trapped, released = not trapped})
end

--	Item components

local function OnFinished(inst)
	inst:RemoveComponent("inventoryitem")
	inst:RemoveComponent("mine")
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst.Physics:SetActive(false)
	
	inst.persists = false
	ErodeAway(inst, 3)
end

local function OnDropped(inst)
	if inst.components.mine then
		inst.components.mine:Deactivate()
		inst.components.mine.issprung = true
	end
end

local function OnDeploy(inst, pt, deployer)
	if inst.components.mine then
		inst.components.mine:Reset()
		inst.components.mine:SetAlignment(deployer:HasTag("walrus") and "walrus" or "nobody")
	end
	
	inst.Physics:Stop()
	inst.Physics:Teleport(pt:Get())
end

local function OnHaunt(inst, haunter)
	if inst.components.mine and not inst.components.mine.issprung and math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
		inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
		inst.components.mine:Explode(nil)
		
		return true
	elseif math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
		inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
		if inst.components.mine then
			inst.components.mine:Reset()
		end
		
		return true
	end
	
	return false
end

local function OnHit(inst)
	LaunchTrap(inst, 2)
end

local function OnHammered(inst)
	if inst.components.inventoryitem then
		inst.components.inventoryitem.canbepickedup = false
	end
	if inst.components.finiteuses then
		inst.components.finiteuses:SetPercent(0)
	end
end

local function ShouldRecoil(inst, worker, tool, numworks) -- No actual recoil, but only players can damage Bear Traps
	return false, not (worker and worker:HasTag("player")) and 0 or numworks
end

local function OnSave(inst, data)
	data.walrus_owned = inst.components.mine and inst.components.mine.alignment == "walrus" or nil
end

local function OnLoad(inst, data)
	if data then
		if data.walrus_owned and inst.components.mine then
			inst.components.mine:SetAlignment("walrus")
		end
	end
end

--	Client

local PLAYER_TAGS = {"player"}

local function CanDeployFn(inst, pt, mouseover, deployer, rotation)
	if not TheWorld.Map:IsPassableAtPoint(pt:Get()) or not TheWorld.Map:IsDeployPointClear(pt, inst, inst.replica.inventoryitem:DeploySpacingRadius()) then
		return false
	end
	
	return TheNet:GetPVPEnabled() or FindEntity(inst, TUNING.WALRUS_BEARTRAP_RADIUS + 0.2, function(guy) return guy ~= deployer end, PLAYER_TAGS) == nil
end

local function UpdateSnowCamo(inst, snowlevel)
	if ThePlayer == nil then
		return
	end
	
	snowlevel = snowlevel or (IsInPolar(inst) and 0 or TheWorld.state.snowlevel) -- (Snow overlay is disabled in Winterlands)
	local tile, tileinfo = inst:GetCurrentTileType()
	
	if not inst.AnimState:IsCurrentAnimation("idle") or not TileGroupManager:IsLandTile(tile) or
		not ((tile and tile == WORLD_TILES.POLAR_SNOW) or (tileinfo and not tileinfo.nogroundoverlays)) then
		
		return inst.AnimState:SetMultColour(1, 1, 1, 1)
	end
	
	local snow_visibility = math.max(0, math.min(1, 1 - (tile == WORLD_TILES.POLAR_SNOW and 1 or snowlevel * 3)))
	local dist = inst:GetDistanceSqToInst(ThePlayer)
	local a = snow_visibility
	
	local min_d = TUNING.WALRUS_BEARTRAP_VISILITY_SNOWDISTS.min
	local max_d = TUNING.WALRUS_BEARTRAP_VISILITY_SNOWDISTS.max
	
	if dist then
		dist = math.sqrt(dist)
		
		if dist <= min_d then
			a = 1
		elseif dist < max_d then
			local t = (dist - min_d) / (max_d - min_d)
			a = 1 + (snow_visibility - 1) * t
		end
	end
	
	inst.AnimState:SetMultColour(1, 1, 1, math.max(0.1, a))
end

local function OnEntityReplicated(inst)
	local parent = inst.entity:GetParent()
	
	if parent and parent.prefab == "atrium_gate" then
		table.insert(parent.highlightchildren, inst)
	end
end

local function OnRemoveEntity(inst)
	local parent = inst.entity:GetParent()
	if parent and parent.highlightchildren then
		table.removearrayvalue(parent.highlightchildren, inst)
	end
end

local function OnProxyTrapActivatedDirty(inst)
	local proxy = inst._proxytrap
	
	if proxy == nil then
		proxy = SpawnPrefab("walrus_beartrap_proxy")
		proxy.entity:SetParent(inst.entity)
		proxy.components.highlightchild:SetOwner(inst)
		
		inst._proxytrap = proxy
	end
	
	if inst.proxytrap_activated:value() then
		proxy.AnimState:PlayAnimation("reset")
		proxy.AnimState:PushAnimation("idle", false)
	else
		proxy.AnimState:PlayAnimation("idle_invisible")
	end
end

local function proxy()
	local inst = CreateEntity()
	
	inst:AddTag("NOCLICK")
	inst:AddTag("FX")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetCanSleep(false)
	inst.persists = false
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	inst.AnimState:SetBank("walrus_beartrap")
	inst.AnimState:SetBuild("walrus_beartrap")
	inst.AnimState:PlayAnimation("idle_invisible")
	inst.AnimState:SetScale(1.35, 1.35)
	inst.AnimState:SetFinalOffset(3)
	
	inst:AddComponent("highlightchild")
	
	inst.UpdateSnowCamo = UpdateSnowCamo
	
	if not TheNet:IsDedicated() then
		inst:DoPeriodicTask(FRAMES * 2, inst.UpdateSnowCamo, 0)
	end
	
	return inst
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst:SetPhysicsRadiusOverride(1)
	
	inst.AnimState:SetBank("walrus_beartrap")
	inst.AnimState:SetBuild("walrus_beartrap")
	inst.AnimState:PlayAnimation("inactive")
	inst.AnimState:SetScale(1.35, 1.35)
	inst.AnimState:SetFinalOffset(3)
	
	inst:AddTag("cattoy")
	inst:AddTag("trap")
	inst:AddTag("walrus_beartrap")
	inst:AddTag("noepicmusic")
	
	inst._custom_candeploy_fn = CanDeployFn
	
	inst.proxytrap_activated = net_bool(inst.GUID, "walrus_beartrap.proxytrap_activated", "proxytrap_activateddirty")
	
	inst.entity:SetPristine()
	
	if not TheNet:IsDedicated() then
		inst:ListenForEvent("proxytrap_activateddirty", OnProxyTrapActivatedDirty)
	end
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.WALRUS_BEARTRAP_USES)
	inst.components.finiteuses:SetUses(TUNING.WALRUS_BEARTRAP_USES)
	inst.components.finiteuses:SetOnFinished(OnFinished)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("mine")
	inst.components.mine:SetAlignment("nobody")
	inst.components.mine:SetRadius(TUNING.WALRUS_BEARTRAP_RADIUS)
	inst.components.mine:SetTestTimeFn(TrapTestTimeFn)
	inst.components.mine:SetOnExplodeFn(OnExplode)
	inst.components.mine:SetOnResetFn(OnReset)
	inst.components.mine:SetOnSprungFn(SetSprung)
	inst.components.mine:SetOnDeactivateFn(SetInactive)
	inst.components.mine:Deactivate()
	inst.components.mine.issprung = true
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy
	inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
	inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetShouldRecoilFn(ShouldRecoil)
	inst.components.workable:SetWorkable(false)
	
	inst._target_attacked = function(target, data) OnTargetAttacked(inst, target, data) end
	inst._target_removed = function(target) inst:DoTrapStruggle(target, true) end
	
	inst.DoTrapStruggle = DoTrapStruggle
	inst.SetTrapTarget = SetTrapTarget
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("animover", OnAnimOver)
	
	return inst
end

return Prefab("walrus_beartrap", fn, assets),
	Prefab("walrus_beartrap_proxy", proxy, assets),
	MakePlacer("walrus_beartrap_placer", "walrus_beartrap", "walrus_beartrap", "idle", nil, nil, nil, 1.35)