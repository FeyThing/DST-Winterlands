local LAYOUTS = {
	["basic"] = {
		0, 	0, 	1, 	2, 	1, 	2, 	1, 	2, 	1, 	2, 	1, 	2, 	1, 	2, 	1, 	0, 	0,
		0, 	6, 	12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 6, 	0,
		2, 	12, 0, 	0, 	0, 	13, 0, 	0, 	9, 	0, 	0, 	13, 0, 	0, 	0, 	12, 2,
		1, 	12, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	12, 1,
		2, 	12, 9, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	9, 	12, 2,
		1, 	12, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	12, 1,
		2, 	12, 13, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	13, 12, 2,
		1, 	12, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	12, 1,
		2, 	12, 9, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	9, 	12, 2,
		1, 	12, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	12, 1,
		2, 	12, 13, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	13, 12, 2,
		1, 	12, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	12, 1,
		2, 	12, 9, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	9, 	12, 2,
		1, 	12, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	12, 1,
		2, 	12, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	12, 2,
		0, 	6, 	12, 12, 12, 0, 	0, 	0, 	0, 	0, 	0, 	0, 	12, 12, 12, 6, 	0,
		0, 	0, 	1, 	2, 	1, 	2, 	1, 	11, 0, 	13, 1, 	2, 	1, 	2, 	1, 	0, 	0,
	},
}

--

local DECOR_BLOCKER_TAGS = {"blocker", "plant", "structure", "wall"}
local SLIPPERY_MUST_TAGS = {"slipperyfeettarget"}

local castle_chesspieces = {
	chesspiece_emperor_penguin_fruity_dryice = 4,
	chesspiece_emperor_penguin_juggle_dryice = 4,
	chesspiece_emperor_penguin_magestic_dryice = 4,
	chesspiece_emperor_penguin_spin_dryice = 4,
	chesspiece_deerclops_dryice = 1,
	chesspiece_klaus_dryice = 1,
}

local castle_items = {
	ice = 9,
	polar_dryice = 1,
}

--

local FNS = {
	TowerSpawnFn = function(num, pt, center_pos)
		local inst = SpawnPrefab("tower_polar")
		inst.Transform:SetPosition(pt:Get())
		
		local angle = inst:GetAngleToPoint(center_pos)
		inst.Transform:SetRotation(angle)
		
		if num < 8 and (num == 7 or math.random() < 0.5) then
			inst:AddFlag()
		end
		
		return inst
	end,

	WallSpawnFn = function(num, pt)
		local inst = SpawnPrefab("wall_polar")
		inst.Transform:SetPosition(pt:Get())
		
		if inst.components.health then
			inst.components.health:SetPercent(num == 1 and 1
				or num == 2 and 0.85
				or num == 3 and 0.5
				or num == 4 and 0.15
				or 0)
		end
		
		return inst
	end,
	
	ChesspieceSpawnFn = function(num, pt)
		if num > 9 or math.random() < 0.3 then
			return
		end
		
		local inst = SpawnPrefab(weighted_random_choice(castle_chesspieces))
		inst.Transform:SetPosition(pt:Get())
		
		return inst
	end,
	
	SignSpawnFn = function(num, pt)
		if math.random() < 0.66 then
			return
		end
		
		local inst = SpawnPrefab("homesign")
		if inst.components.writeable then
			inst.components.writeable:SetText(STRINGS.EMPEROR_PENGUIN_SIGNTEXT[math.random(#STRINGS.EMPEROR_PENGUIN_SIGNTEXT)])
		end
		
		local offset = FindWalkableOffset(pt, math.random() * TWOPI, 4, 12, false, true, function(_pt)
			local slippery = TheSim:FindEntities(_pt.x, _pt.y, _pt.z, 12, SLIPPERY_MUST_TAGS)
			
			for i, ent in ipairs(slippery) do
				if ent.components.slipperyfeettarget and ent.components.slipperyfeettarget:IsSlipperyAtPosition(_pt.x, _pt.y, _pt.z) then
					return false
				end
			end
			
			return #TheSim:FindEntities(_pt.x, _pt.y, _pt.z, 2, nil, nil, DECOR_BLOCKER_TAGS) == 0 and not TheWorld.Map:IsPointNearHole(_pt)
		end) or Vector3(0, 0, 0)
		
		inst.Transform:SetPosition((pt + offset):Get())
		
		return inst
	end,
		
	ItemSpawnFn = function(num, pt)
		if math.random() < 0.1 then
			return
		end
		
		local inst = SpawnPrefab(weighted_random_choice(castle_items))
		inst.Transform:SetPosition(pt:Get())
		
		return inst
	end,

	GlacierSpawnFn = function(num, pt)
		if math.random() < 0.33 then
			return
		end
		
		local inst = SpawnPrefab("rock_ice")
		inst.remove_on_dryup = true
		
		local offset = FindWalkableOffset(pt, math.random() * TWOPI, 8, 12, false, true, function(_pt)
			local slippery = TheSim:FindEntities(_pt.x, _pt.y, _pt.z, 12, SLIPPERY_MUST_TAGS)
			
			for i, ent in ipairs(slippery) do
				if ent.components.slipperyfeettarget and ent.components.slipperyfeettarget:IsSlipperyAtPosition(_pt.x, _pt.y, _pt.z) then
					return false
				end
			end
			
			return #TheSim:FindEntities(_pt.x, _pt.y, _pt.z, 4, nil, nil, DECOR_BLOCKER_TAGS) == 0 and not TheWorld.Map:IsPointNearHole(_pt)
		end) or Vector3(0, 0, 0)
		
		inst.Transform:SetPosition((pt + offset):Get())
		
		return inst
	end
}

--

local PARTS = {
	["1"] = {fn = FNS.WallSpawnFn},
	["2"] = {fn = FNS.WallSpawnFn},
	["3"] = {fn = FNS.WallSpawnFn},
	["4"] = {fn = FNS.WallSpawnFn},
	["5"] = {fn = FNS.WallSpawnFn},
	["6"] = {fn = FNS.TowerSpawnFn},
	["7"] = {fn = FNS.TowerSpawnFn},
	["8"] = {fn = FNS.TowerSpawnFn},
	["9"] = {fn = FNS.ChesspieceSpawnFn},
	["10"] = {fn = FNS.ChesspieceSpawnFn},
	["11"] = {fn = FNS.SignSpawnFn, spawnlast = true},
	["12"] = {fn = FNS.ItemSpawnFn, spawnlast = true},
	["13"] = {fn = FNS.GlacierSpawnFn, spawnlast = true},
}

return {FNS = FNS, LAYOUTS = LAYOUTS, PARTS = PARTS}