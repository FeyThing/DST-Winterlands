--	Biome detection

function IsInPolarAtPoint(x, y, z, range)
	local node = TheWorld.Map:FindNodeAtPoint(x, y, z)
	
	if node == nil and range and range > 0 then
		local pt = Vector3(x, y, z)
		local node_offset = FindValidPositionByFan(0, range, 64, function(offset)
			local _node = TheWorld.Map:FindNodeAtPoint((pt + offset):Get())
			
			return _node and _node.tags and table.contains(_node.tags, "polararea")
		end)
		
		return node_offset ~= nil
	else
		return node and node.tags and table.contains(node.tags, "polararea")
	end
	
	return false
end

function IsInPolar(inst, range)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	return IsInPolarAtPoint(x, y, z, range)
end

function GetClosestPolarTileToPoint(x, y, z, maxdist)
	if IsInPolarAtPoint(x, y, z) then
		return TheWorld.Map:GetTileAtPoint(x, y, z), 0
	end
	
	if TheWorld.components.winterlands_manager == nil then
		return
	end
	
	local best_distsq = math.huge
	local best_tile
	
	maxdist = maxdist or math.huge
	local max_distsq = maxdist * maxdist
	
	local tiles = TheWorld.components.winterlands_manager:GetTiles()
	for i = 1, #tiles do
		local t = tiles[i]
		local dx = x - t.wx
		local dz = z - t.wz
		local distsq = dx * dx + dz * dz
		
		if distsq < best_distsq then
			best_distsq = distsq
			best_tile = t.tile
		end
	end
	
	if best_tile and best_distsq <= max_distsq then
		return best_tile, math.sqrt(best_distsq)
	end
end

--	Plowing

local SNOWBLOCKER_TAGS = {"snowblocker"}
local MIN_SNOWBLOCKER_DIST = 2

function SpawnPolarSnowBlocker(pos, radius, duration, doer, cause)
	local blockers = TheSim:FindEntities(pos.x, pos.y, pos.z, radius or 0, SNOWBLOCKER_TAGS)
	local dist = radius
	
	TheWorld:PushEvent("ms_plowarea_pre", {doer = doer, pt = pos, radius = radius, blockers = blockers, cause = cause}) -- (Useful to know if area was previously covered)
	
	duration = duration or TUNING.POLARPLOW_BLOCKER_DURATION
	
	for i, v in ipairs(blockers) do
		if v.ExtendSnowBlocker then
			v:ExtendSnowBlocker(doer, nil, duration)
		end
		
		local blocker_dist = v:GetDistanceSqToPoint(pos.x, pos.y, pos.z)
		if blocker_dist <= radius and v.SetSnowBlockRange and v._snowblockrange and v._snowblockrange:value() < radius then
			v:SetSnowBlockRange(radius)
		end
		
		if v.prefab == "snowwave_blocker" then
			dist = blocker_dist < dist and blocker_dist or dist
		end
	end
	
	local blocker
	if dist >= MIN_SNOWBLOCKER_DIST then
		blocker = SpawnPrefab("snowwave_blocker")
		blocker.Transform:SetPosition(pos.x, pos.y, pos.z)
		
		blocker:ExtendSnowBlocker(doer, true, duration)
		if blocker.SetSnowBlockRange then
			blocker:SetSnowBlockRange(radius)
		end
	end
	
	TheWorld:PushEvent("ms_plowarea", {doer = doer, pt = pos, radius = radius, blocker = blocker, blockers = blockers, cause = cause})
	
	return blocker, blockers
end

function GetPolarPlowDuration(doer, t, cause)
	local iscanadian = doer and (doer:HasTag("polite") or doer:HasTag("pinetreepioneer"))
	t = t or TUNING.POLARPLOW_BLOCKER_DURATION
	
	if cause == "frostfall" then
		t = t * (2 - math.random())
	end
	
	return t * (iscanadian and TUNING.POLARPLOW_BLOCKER_CANADIAN_MULT or 1)
end

--	MakeNoGrowInWinter(lands) / Make(High)SnowCovered loop

function DoPolarComponentsUpdate(inst, loading)
	local in_polar = IsInPolar(inst)
	
	if inst.pause_grow_in_polar then
		if in_polar then
			if inst.components.growable then
				if not inst:HasTag("canpolargrow") then
					inst.components.growable:Pause("polar")
				else
					inst.components.growable:Resume("polar")
				end
			end
			if inst.components.pickable then
				inst.components.pickable:PolarPause(true)
			end
		else
			if inst.components.growable then
				inst.components.growable:Resume("polar")
			end
			if inst.components.pickable then
				inst.components.pickable:PolarPause(false)
			end
		end
	end
	
	if inst:HasTag("SnowCovered") then
		local x, y, z = inst.Transform:GetWorldPosition()
		local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
		
		local lock_covered = IsUnderIceCaveAtXZ(x, z)
		local snow_covered = in_polar and not lock_covered and TheWorld.components.polarsnow_manager and
			not TheWorld.components.polarsnow_manager:IsTileMelting(tx, ty)
		
		if snow_covered then
			--inst.AnimState:OverrideSymbol("snow", "polar_snow", "snow") -- The snow is snowier than before...
			inst.AnimState:Show("snow")
		else
			if lock_covered or not TheWorld.state.issnowcovered then
				inst.AnimState:Hide("snow")
			end
		end
		
		inst.polar_snow_covered = snow_covered
	end
	
	local cd = loading and 0.1 or GetRandomMinMax(TUNING.POLAR_SNOWCOVERED_TIME.min, TUNING.POLAR_SNOWCOVERED_TIME.max)
	inst._polarcomponents_task = inst:DoTaskInTime(cd, function() DoPolarComponentsUpdate(inst) end)
end

function SetPolarComponentsUpdates(inst, loading)
	DoPolarComponentsUpdate(inst, loading)
end

--	Convert dirt sprites to snow

function MakeSnowAndDirtToggleable(inst, overrides)
	if overrides then
		inst._polardirt_overrides = #overrides > 0 and overrides or {overrides}
	end
	
	if inst._polardirt_callback then
		local x, y, z = inst.Transform:GetWorldPosition()
		local in_snow = TheWorld.Map:IsPolarSnowAtPoint(x, y, z, true)
			or (not IsInPolar(inst) and (TheWorld.state.snowlevel and TheWorld.state.snowlevel > TUNING.DIRT_TO_SNOW_MIN_LEVEL))
		
		for i, v in ipairs(inst._polardirt_overrides or {}) do
			if in_snow then
				inst.AnimState:OverrideSymbol(v.symbol, v.build, v.override or v.symbol)
			elseif v.clearbuild then -- If this needs another override instead of clearing !
				inst.AnimState:OverrideSymbol(v.symbol, v.clearbuild, v.clearsym or v.symbol)
			else
				inst.AnimState:ClearOverrideSymbol(v.symbol)
			end
		end
	else
		inst._polardirt_callback = function() MakeSnowAndDirtToggleable(inst) end
		
		if inst.components.locomotor then
			if inst.components.areaaware == nil then
				inst:AddComponent("areaaware")
				inst.components.areaaware:SetUpdateDist(0.45)
			end
			inst.components.areaaware:StartWatchingTile(WORLD_TILES.POLAR_SNOW)
		end
		
		inst:ListenForEvent("on_POLAR_SNOW_tile", inst._polardirt_callback)
		inst:ListenForEvent("onterraform", inst._polardirt_callback, TheWorld)
		inst:WatchWorldState("snowlevel", inst._polardirt_callback)
		
		inst:DoTaskInTime(0, inst._polardirt_callback)
	end
end

--	Frozen Wetness

function SetPolarWetness(inst, level)
	if level <= 0 then
		inst:RemoveDebuff("buff_polarwetness")
		
		if inst.components.snowedshader then
			inst.components.snowedshader:SetFreezeAmount(0)
		end
	end
	
	for i = 1, TUNING.POLAR_WETNESS_LVLS do
		inst:AddOrRemoveTag("polarwet_"..i, i > 0 and i == level)
	end
end

function GetPolarWetness(inst)
	if inst:HasTag("polarwet") then
		return TUNING.POLAR_WETNESS_LVLS, true
	end
	
	for i = 1, TUNING.POLAR_WETNESS_LVLS do
		if inst:HasTag("polarwet_"..i) then
			return i, true
		end
	end
	
	return 0, false
end

function HasPolarDebuffImmunity(inst, ignorewaterproof, ignoredesiccant)
	if inst:HasTag("polarimmune") or inst:HasTag("wereplayer") or inst:HasTag("playerghost") then
		return true
	end
	
	if inst.components.inventory then
		for k, v in pairs(inst.components.inventory.equipslots) do
			if v:HasTag("polarimmunity") then
				return true, v
			end
		end
		
		local desiccant = inst.components.inventory:FindItem(function(item)
			return item.components.moistureabsorbersource and item.components.moistureabsorbersource:GetDryingRate(0) > 0
		end)
		
		if desiccant and not ignoredesiccant then
			return true
		end
	end
	
	return (not ignorewaterproof and inst.components.moisture and inst.components.moisture:GetWaterproofness() >= TUNING.POLAR_WETNESS_MIN_PROOFNESS) or false
end

function HasPolarSnowImmunity(inst)
	if inst:HasTag("polarsnowimmune") or inst:HasTag("weregoose") or inst:HasTag("playerghost") or inst:HasTag("vigorbuff") then
		return true
	end
	
	if inst.components.inventory then
		for k, v in pairs(inst.components.inventory.equipslots) do
			if v:HasTag("polarsnowimmunity") then
				return true, v
			end
		end
	end
	
	return false
end

--	Ice Lettuce things buff

function EatIceLettuce(inst, eater, duration, freeziness, temperature)
	if freeziness and eater.components.freezable then
		eater.components.freezable:AddColdness(freeziness)
	end
	
	if temperature and eater.components.temperature and eater.components.temperature.current then
		eater.components.temperature:SetTemperature(eater.components.temperature.current + temperature)
	end
	
	if eater.components.debuffable == nil then
		eater:AddComponent("debuffable")
	end
	
	if not duration then
		return
	end
	
	local buff = eater.components.debuffable:GetDebuff("buff_polarimmunity") or eater.components.debuffable:AddDebuff("buff_polarimmunity", "buff_polarimmunity")
	local timeleft = (buff and buff.components.timer) and buff.components.timer:GetTimeLeft("buffover") or nil
	
	if timeleft and duration and duration > timeleft then
		buff.components.timer:SetTimeLeft("buffover", duration)
	end
	
	return buff
end

--	EZ compatibilities

function IsWintersFistsSnowball(item)
	return item.prefab == "snowball_item" -- I'm tired atm but later we should add other mod snowballs
end

function WandaTimeFreezeDrain(inst, stat, delta, old, max, min)
	local buff = inst:GetDebuff("buff_wandatimefreeze")
	if not buff or not (buff.components.timer and buff.components.timer:TimerExists("buffover")) then
		return
	end
	
	local new = math.clamp(old + delta, min or 0, max or 100) - old
	local mult = TUNING.POCKERWATCH_BUFF_DRAINS[stat] or 0
	local drain = math.abs(new) * mult
	
	if new == 0 or mult == 0 or drain <= 0 then
		return
	end
	if buff.debugstatdrain then
		buff:debugstatdrain(stat, drain)
	end
	
	local timeleft = buff.components.timer:GetTimeLeft("buffover")
	buff.components.timer:SetTimeLeft("buffover", math.max(timeleft - drain, 0))
end