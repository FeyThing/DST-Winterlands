local ICE_SURPRISE_DEFS = require("icefishing_surprise_defs")

local ICE_SURPRISE_RESULTS = ICE_SURPRISE_DEFS.RESULTS
local ICE_SURPRISE_FNS = ICE_SURPRISE_DEFS.FNS

return Class(function(self, inst)
	assert(TheWorld.ismastersim, "Ice fishing surprise should not exist on client")
	self.inst = inst
	
	local ice_plows = {}
	
	local function OnEntSleep(ent)
		TheWorld:RemoveEventCallback("entitysleep", OnEntSleep, ent)
		ent:DoTaskInTime(0, ent.Remove)
	end
	
	local function GetLargestWaterPtAndRad(pt, plow)
		local cx, cy, cz = pt:Get()
		local attempts = 16
		local max_pt = pt
		local max_rad = 0
		
		for deploy_rad = 0, 5, 0.5 do
			if TheWorld.Map:CanDeployAtPointInWater(pt, plow, nil, {land = 0, boat = 0, radius = deploy_rad}) then
				max_rad = deploy_rad
			end
		end
		
		for radius = 1, 5 do
			for i = 0, attempts - 1 do
				local angle = (TWOPI / attempts) * i
				local offset_x = radius * TILE_SCALE * math.cos(angle)
				local offset_z = radius * TILE_SCALE * math.sin(angle)
				local check_x = cx + offset_x
				local check_z = cz + offset_z
				local check_pt = Vector3(check_x, 0, check_z)
				
				for deploy_rad = max_rad + 1, 5 do
					if TheWorld.Map:CanDeployAtPointInWater(check_pt, plow, nil, {land = 0, boat = 0, radius = deploy_rad}) then
						if deploy_rad > max_rad then
							max_rad = deploy_rad
							max_pt = check_pt
						end
					end
				end
			end
		end
		
		return max_pt, max_rad
	end
	
	function self:GetSurprise(pt, plow)
		if pt == nil then
			return
		end
		
		local max_pt, max_rad = GetLargestWaterPtAndRad(pt, plow, 6)
		local result_candidates = {}
		
		for name, def in pairs(ICE_SURPRISE_RESULTS) do
			local weight = def.weight and FunctionOrValue(def.weight, max_pt, max_rad) or 0
			
			-- TODO: Certain mobs should change weight based on world settings
			if weight > 0 and (def.rad and FunctionOrValue(def.rad, max_pt, max_rad) or 0.5) <= max_rad then
				if def.canspawnfn == nil or def.canspawnfn(max_pt, plow) then
					result_candidates[name] = weight
				end
			end
		end
		
		if not IsTableEmpty(result_candidates) then
			return weighted_random_choice(result_candidates), max_pt, max_rad
		end
	end
	
	function self:SpawnEnt(ent_def, pt, radius)
		local prefab, ent_data = FunctionOrValue(ent_def.prefab, pt, radius)
		local ent = SpawnPrefab(prefab)
		ent_data = ent_data or {}
		
		if ent then
			local spawn_fn = ent_def.spawnposfn or ICE_SURPRISE_FNS.GetSpawnOffset
			local spawn_pos, found_pos = spawn_fn(ent, pt, radius, FunctionOrValue(ent_def.offset or 0, pt, radius), ent_def.customspawnfn)
			
			if spawn_pos then
				ent.Transform:SetPosition(spawn_pos:Get())
			end
			
			if (ent_data.state or ent_def.state) and ent.sg then
				ent.sg:GoToState(ent_data.state or ent_def.state)
			end
			
			if ent.components.amphibiouscreature then
				ent.components.amphibiouscreature:OnEnterOcean()
			end
			
			if ent_def.onspawn then
				ent_def.onspawn(ent, pt, radius)
			end
			
			local persists = ent_data.persists or ent_def.persists
			if not persists and (ent.components.health or persists == false) then
				TheWorld:ListenForEvent("entitysleep", OnEntSleep, ent)
				ent.persists = false
			end
		end
		
		return ent
	end
	
	function self:StartSurprise(pt, plow)
		local surprise, max_pt, radius = self:GetSurprise(pt, plow)
		pt = max_pt or pt
		
		if surprise == nil then
			print("Ice fishing surprise couldn't spawn!", radius)
			return
		end
		print("Ice fishing surprise: "..surprise.." spawned at", pt, radius)
		
		local def = ICE_SURPRISE_RESULTS[surprise]
		local ents = {}
		
		for i, ent_def in ipairs(def.ents or {}) do
			local spawn_chance = FunctionOrValue(ent_def.chance or 1, pt, radius)
			
			if spawn_chance >= math.random() then
				local spawn_time = ent_def.spawntime or math.random() * 0.5
				
				TheWorld:DoTaskInTime(FunctionOrValue(spawn_time, pt), function()
					local ent = self:SpawnEnt(ent_def, pt, radius)
					table.insert(ents, ent)
				end)
			end
		end
		
		if def.onstarted then
			def.onstarted(pt, ents)
		end
		
		TheWorld:PushEvent("ms_icefishingsurprise", {ents = ents, name = surprise, pt = pt})
		
		return ents
	end
	
	self.OnDoSurprise = function(src, data)
		local pt = data and ice_plows[data.plow]
		
		if pt then
			self:StartSurprise(pt, data.plow)
		end
		
		ice_plows[data.plow] = nil
	end
	
	self.OnStartSurprise = function(src, data)
		if data and data.plow then
			ice_plows[data.plow] = data.pt
		end
	end
	
	inst:ListenForEvent("ms_doicefishingsurprise", self.OnDoSurprise)
	inst:ListenForEvent("ms_starticefishingsurprise", self.OnStartSurprise)
end)