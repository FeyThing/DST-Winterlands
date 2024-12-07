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

function GetClosestPolarTileToPoint(x, y, z, maxdist) -- LukaS: Kinda hacky but works well and doesn't brick your pc
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

function HasPolarDebuffImmunity(inst, ignorewaterproof)
	if inst:HasTag("polarimmune") or inst:HasTag("wereplayer") then
		return true
	end
	
	if inst.components.inventory then
		for k, v in pairs(inst.components.inventory.equipslots) do
			if v:HasTag("polarimmunity") then
				return true, v
			end
		end
	end
	
	return (not ignorewaterproof and inst.components.moisture and inst.components.moisture:GetWaterproofness() >= TUNING.POLAR_WETNESS_MIN_PROOFNESS) or false
end

function HasPolarSnowImmunity(inst)
	if inst:HasTag("polarimmune") then
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