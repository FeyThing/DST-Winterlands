local COMBAT_MUST_TAGS = {"_combat", "_health"}
local COMBAT_CANT_TAGS = {"INLIMBO"}
local COMBAT_TAGS = {"character", "monster", "hostile"}

local LOOT = {
	FLOATSAM = {
		--	basic
		kelp = 2,
		bullkelp_root = 1,
		cutgrass = 2,
		twigs = 2,
		driftwood_log = 1,
		spoiled_fish = 1,
		--	exclusive
		dug_trap_starfish = 2,
		bluegem_shards = 2,
		bluegem = 1,
	},
	FLOATSAM_CHUM = {
		chum = 1,
		nothing_at_all = 1,
	},
	FLOATSAM_STARFISH = {
		dug_trap_starfish = 1,
	},
	KELP = {
		bullkelp_beachedroot = 1,
		bullkelp_plant = 2,
		bullkelp_root = 1,
		kelp = 2,
	}
}

local FNS = {
	--	Get spawn prefab
	GnarwailOrShark = function(pt, radius)
		if radius <= 1 then
			return
		end
		local ent = math.random() <= 0.5 and "gnarwail" or "shark"
		
		return ent, {state = ent == "gnarwail" and "emerge" or "eat_pst"}
	end,
	GetKelp = function(pt, radius)
		local loot = deepcopy(LOOT.KELP)
		if radius and radius > 1 then
			loot.bullkelp_beachedroot = radius
			loot.bullkelp_root = radius
		end
		
		return weighted_random_choice(loot)
	end,
	GetFragment = function()
		return "boatfragment0"..math.random(3, 5)
	end,
	
	--	On ent spawn
	AttackOther = function(inst, pt)
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10, COMBAT_MUST_TAGS, COMBAT_CANT_TAGS, COMBAT_TAGS)
		
		for i, v in ipairs(ents) do
			if v.prefab ~= inst.prefab then
				if inst.components.combat and inst.components.combat.target == nil then
					inst.components.combat:SuggestTarget(v)
				end
				
				break
			end
		end
	end,
	GetKilled = function(inst, chance)
		if (chance == nil or chance > math.random()) and inst.components.health and not inst.components.health:IsDead() then
			inst.components.health:Kill()
		end
	end,
	SetFloatsamLoot = function(inst, loot)
		if inst.SetIceFishingLoot then
			local item = weighted_random_choice(LOOT[loot or "FLOATSAM"])
			
			if item ~= "nothing_at_all" then
				inst:SetIceFishingLoot(item)
			end
		end
	end,
	
	--	On started
	SpawnShoal = function(pt)
		if TheWorld.components.schoolspawner then
			return TheWorld.components.schoolspawner:SpawnSchool(pt, nil, Vector3(0, 0, 0))
		end
	end,
	SpawnBirds = function(pt, radius, bird_min, bird_max)
		if TheWorld.components.birdspawner then
			local num = math.random(bird_min or 1, bird_max or 2)
			local delay = 0
			
			for k = 1, num do
				local offset = FindSwimmableOffset(pt, math.random() * TWOPI, math.random(4), 8, false, false, nil, true)
				
				if offset then
					local bird = TheWorld.components.birdspawner:SpawnBird(pt + offset, true)
					
					if bird and bird.sg then
						bird.sg:GoToState("delay_glide", delay)
						delay = delay + .034 + .033 * math.random()
					end
				end
			end
		end
	end,
	
	--	Shared
	GetSpawnOffset = function(inst, pt, radius, def_offset, customcheckfn)
		local offset = FindSwimmableOffset(pt, math.random() * TWOPI, def_offset or 0, 12, nil, nil, customcheckfn)

		return offset ~= nil and (pt + offset) or pt, offset ~= nil
	end,
	
	--	Spawn chances / pos / times
	OffsetIfLarger = function(pt, radius, offset)
		return math.min(offset or radius, radius) or math.random(radius)
	end,
	SpawnIfLarger = function(pt, radius, radius_needed, chance, not_chance)
		if radius >= radius_needed or 2 then
			return chance or 1
		else
			return not_chance or 0
		end
	end,
	AvoidIfLarger = function(pt, radius, radius_avoided, chance, not_chance)
		if radius >= (radius_avoided or 1.5) then
			return not_chance or 0
		else
			return chance or 1
		end
	end,
	SpawnShort = function()
		return math.random()
	end,
	SpawnLong = function()
		return math.random(6, 12)
	end,
	SpawnVariable = function()
		return math.random(12)
	end,
}

local RESULTS = {
	--	Fishing
	["Just Shoal"] = {
		onstarted = FNS.SpawnShoal,
		rad = 1.5,
		weight = 3,
	},
	["Now With Birds"] = {
		onstarted = function(pt, radius, ...) FNS.SpawnShoal(pt, radius, ...) FNS.SpawnBirds(pt, radius, 2, 5, ...) end,
		rad = 1.5,
		weight = 2,
	},
	["Now With Boards"] = {
		ents = {
			{prefab = FNS.GetFragment, 		chance = 0.5, 	offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
			{prefab = FNS.GetFragment, 		chance = 0.5, 	offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
			{prefab = FNS.GetFragment, 		chance = 0.5, 	offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
		},
		onstarted = FNS.SpawnShoal,
		rad = 1.5,
		weight = 2,
	},
	["Swimming Sushi"] = {
		ents = {
			{prefab = FNS.GetKelp,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
			{prefab = FNS.GetKelp,
				chance = function(pt, radius, ...) return FNS.SpawnIfLarger(pt, radius, 1.5, 0.5, 0.1, ...) end,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
			{prefab = FNS.GetKelp,
				chance = function(pt, radius, ...) return FNS.SpawnIfLarger(pt, radius, 3, 0.5, 0.1, ...) end,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
		},
		onstarted = FNS.SpawnShoal,
		rad = 1.5,
		weight = 2,
	},
	["The Bigger Fish"] = {
		ents = {
			{prefab = FNS.GnarwailOrShark, 		spawntime = FNS.SpawnLong},
		},
		onstarted = FNS.SpawnShoal,
		rad = 3,
		weight = 2,
	},
	["Wobster Party"] = {
		ents = {
			{prefab = "wobster_sheller", 					state = "spawn_in", 		spawntime = FNS.SpawnShort},
			{prefab = "wobster_sheller", 	chance = 0.6, 	state = "spawn_in", 		spawntime = FNS.SpawnVariable,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
			{prefab = "wobster_sheller", 	chance = 0.5, 	state = "spawn_in", 		spawntime = FNS.SpawnVariable,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
			{prefab = "wobster_sheller", 	chance = 0.4, 	state = "spawn_in", 		spawntime = FNS.SpawnVariable,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, 2, ...) end},
			{prefab = "wobster_sheller", 	chance = 0.3, 	state = "spawn_in", 		spawntime = FNS.SpawnVariable,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, 2, ...) end},
			{prefab = "wobster_sheller", 	chance = 0.2, 	state = "spawn_in", 		spawntime = FNS.SpawnVariable,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, 3, ...) end},
			{prefab = "wobster_sheller", 	chance = 0.1, 	state = "spawn_in", 		spawntime = FNS.SpawnLong,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, 3, ...) end},
		},
		rad = 1.5,
		weight = 2,
	},
	
	--	Looting
	["Fish and Floatsam"] = {
		ents = {
			{prefab = "oceanfishableflotsam_water", 					spawntime = FNS.SpawnVariable,
				onspawn = function(inst, ...) return FNS.SetFloatsamLoot(inst, nil, ...) end},
			{prefab = "oceanfishableflotsam_water", 	offset = 2, 	spawntime = FNS.SpawnLong,
				onspawn = function(inst, ...) return FNS.SetFloatsamLoot(inst, "FLOATSAM_CHUM", ...) end},
		},
		onstarted = FNS.SpawnShoal,
		rad = 1.5,
		weight = 2,
	},
	["Starfish Floatsam"] = {
		ents = {
			{prefab = "oceanfishableflotsam_water",
				onspawn = function(inst, ...) return FNS.SetFloatsamLoot(inst, nil, ...) end},
			{prefab = "oceanfishableflotsam_water", offset = 2,
				chance = function(pt, radius, ...) return FNS.SpawnIfLarger(pt, radius, 2, 1, nil, ...) end,
				onspawn = function(inst, ...) return FNS.SetFloatsamLoot(inst, "FLOATSAM_STARFISH", ...) end},
			{prefab = "oceanfishableflotsam_water", offset = 3,
				chance = function(pt, radius, ...) return FNS.SpawnIfLarger(pt, radius, 3, 0.5, nil, ...) end,
				onspawn = function(inst, ...) return FNS.SetFloatsamLoot(inst, nil, ...) end},
		},
		rad = 0.5,
		weight = 2,
	},
	
	--	Hazardous
	["Cookies"] = {
		ents = {
			{prefab = "oceanfish_medium_polar1", 	state = "arrive", 	chance = 0.5, 		offset = 1,			spawntime = FNS.SpawnShort},
			{prefab = "oceanfish_medium_polar1", 	state = "arrive", 	chance = 0.5, 		offset = 1.5,		spawntime = FNS.SpawnVariable},
			{prefab = "oceanfish_medium_polar1", 	state = "arrive", 	chance = 0.5,							spawntime = FNS.SpawnVariable},
			{prefab = "cookiecutter", 																			spawntime = FNS.SpawnShort,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end,
				onspawn = function(inst, ...) return FNS.GetKilled(inst, 0.75, ...) end},
			{prefab = "cookiecutter", 				chance = 0.75, 												spawntime = FNS.SpawnShort,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end,
				onspawn = function(inst, ...) return FNS.GetKilled(inst, 0.75, ...) end},
			{prefab = "cookiecutter", 				chance = 0.5, 												spawntime = FNS.SpawnShort,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end,
				onspawn = function(inst, ...) return FNS.GetKilled(inst, 0.75, ...) end},
			{prefab = "cookiecutter", 				chance = 0.5, 												spawntime = FNS.SpawnShort,
				offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end,
				onspawn = function(inst, ...) return FNS.GetKilled(inst, 0.75, ...) end},
		},
		rad = 1.5,
		weight = 1,
	},
	["Friend or Foe"] = {
		ents = {
			{prefab = FNS.GnarwailOrShark},
			{prefab = FNS.GetFragment, 		chance = 0.25, 	offset = function(pt, radius, ...) return FNS.OffsetIfLarger(pt, radius, nil, ...) end},
		},
		rad = 1.5,
		weight = 2,
	},
	["Squids"] = {
		ents = {
			{prefab = "squid", 									state = "spawn", 	offset = 2,		spawntime = FNS.SpawnLong},
			{prefab = "squid", 				chance = 0.5, 		state = "spawn", 	offset = 2,		spawntime = FNS.SpawnLong},
			{prefab = "squid", 				chance = 0.25, 		state = "spawn", 	offset = 2,		spawntime = FNS.SpawnLong},
		},
		onstarted = function(pt, radius, ...)
			if math.random() <= 0.5 then
				FNS.SpawnBirds(pt, radius, nil, nil, ...)
			end
			
			if math.random() <= 0.5 then
				return FNS.SpawnShoal(pt, radius, ...)
			end
		end,
		rad = 1.5,
		weight = 2,
	},
	["Squid Skirmish"] = {
		ents = {
			{prefab = FNS.GnarwailOrShark, 	chance = 0.75},
			{prefab = "squid", 									state = "spawn", 	offset = 1,		spawntime = FNS.SpawnShort, 	onspawn = FNS.AttackOther},
			{prefab = "squid", 									state = "spawn", 	offset = 2,		spawntime = FNS.SpawnLong, 		onspawn = FNS.AttackOther},
			{prefab = "squid", 				chance = 0.5, 		state = "spawn", 	offset = 3,		spawntime = FNS.SpawnVariable, 	onspawn = FNS.AttackOther},
		},
		rad = 3,
		weight = 2,
	},
	
	--	Happens
	["Nothing"] = {
		rad = 0.5,
		weight = FNS.AvoidIfLarger,
	},
}

return {FNS = FNS, RESULTS = RESULTS, LOOT = LOOT}