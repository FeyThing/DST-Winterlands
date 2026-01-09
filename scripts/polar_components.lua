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

function GetClosestPolarTileToPoint(x, y, z, maxdist) -- LukaS: Kinda hacky, don't overuse it or suffer the consequences of L A G
	if TheWorld.components.winterlands_manager == nil then
		return
	end

	if IsInPolarAtPoint(x, y, z) then
		return TheWorld.Map:GetTileAtPoint(x, y, z), 0
	end

	maxdist = maxdist or math.huge
	local polartiles = TheWorld.components.winterlands_manager:GetGrid().grid
	local mindist = math.huge
	local tile

	for i, ispolar in pairs(polartiles) do
		if ispolar then
			local tx, ty = TheWorld.components.winterlands_manager:GetGrid():GetXYFromIndex(i)
			local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(tx, ty)
			local dist = distsq(x, z, cx, cz)
			if dist < mindist then
				mindist = dist
				tile = TheWorld.Map:GetTileAtPoint(cx, cy, cz)
			end
		end
	end

	if math.sqrt(mindist) <= maxdist then
		return tile, math.sqrt(mindist)
	end
end

local SNOWBLOCKER_TAGS = {"snowblocker"}
local MIN_SNOWBLOCKER_DIST = 2

function SpawnPolarSnowBlocker(pos, radius, duration, doer)
	local blockers = TheSim:FindEntities(pos.x, pos.y, pos.z, radius or 0, SNOWBLOCKER_TAGS)
	local dist = radius
	
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
	
	return blocker, blockers
end

function GetPolarPlowDuration(doer, t, cause)
	local iscanadian = doer and (doer:HasTag("polite") or doer:HasTag("pinetreepioneer"))
	t = t or TUNING.POLARPLOW_BLOCKER_DURATION
	
	return t * (iscanadian and TUNING.POLARPLOW_BLOCKER_CANADIAN_MULT or 1)
end

function MakePolarCovered(inst, polar)
	if polar then
		inst.AnimState:OverrideSymbol("snow", "polar_snow", "snow") -- The snow is snowier than before...
		inst.AnimState:Show("snow")
	else
		if inst.polar_snowed then
			inst.AnimState:OverrideSymbol("snow", "snow", "snow")
		end
		if not TheWorld.state.issnowcovered then
			inst.AnimState:Hide("snow")
		end
	end
	
	inst.polar_snowed = polar or nil
	inst.polarsnow_task = nil
end

function OnPolarCover(inst, loading)
	local polar = IsInPolar(inst)
	
	if inst.pause_grow_in_polar then
		if polar then
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
				inst.components.pickable:PolarPause()
			end
		end
	end
	
	if inst:HasTag("SnowCovered") then
		if inst.polarsnow_task then
			inst.polarsnow_task:Cancel()
		end
		
		local covered_time = loading and 0 or GetRandomMinMax(TUNING.POLAR_COVERTIME.min, TUNING.POLAR_COVERTIME.max)
		inst.polarsnow_task = inst:DoTaskInTime(covered_time, function() MakePolarCovered(inst, polar) end)
	end
end

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

function IsWintersFistsSnowball(item)
	return item.prefab == "snowball_item" -- I'm tired atm but later we should add other mod snowballs
end

local TIMEFREEZE_DRAINS = TUNING.POCKERWATCH_BUFF_DRAINS

function WandaTimeFreezeDrain(inst, stat, delta, old, max, min)
	local buff = inst:GetDebuff("buff_wandatimefreeze")
	if not buff or not (buff.components.timer and buff.components.timer:TimerExists("buffover")) then
		return
	end
	
	local new = math.clamp(old + delta, min or 0, max or 100) - old
	local mult = TIMEFREEZE_DRAINS[stat] or 0
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