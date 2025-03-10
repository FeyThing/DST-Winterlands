return Class(function(self, inst)
	assert(TheWorld.ismastersim, "Polar Fox respawner should not exist on client")
	self.inst = inst
	
	local _foxspawns = {}
	
	local SPAWN_AVOID_TAGS = {"character", "hostile"}
	local SPAWN_CANCEL_TAGS = {"wall", "structure"}
	local SPAWN_CANCEL_NOT_TAGS = {"campfire"}
	
	local function CanFoxSpawn(pt)
		return TheWorld.Map:IsPolarSnowAtPoint(pt.x, 0, pt.z, true) and not TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z)
			and #TheSim:FindEntities(pt.x, pt.y, pt.z, 2, SPAWN_CANCEL_TAGS, SPAWN_CANCEL_NOT_TAGS) == 0
	end
	
	local function ShouldFoxSpawn(pt)
		local temperature = TheWorld.state.temperature
		
		return #TheSim:FindEntities(pt.x, pt.y, pt.z, 5, SPAWN_AVOID_TAGS) == 0 and not (temperature and temperature >= TUNING.POLAR_SNOW_MELT_TEMP)
			and not (TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsPolarStormActive())
	end
	
	--
	
	function self:GetRespawnTime()
		if not TUNING.POLARFOX_ENABLED then
			return
		end
		
		return TUNING.POLARFOX_SPAWN_TIME + math.random(TUNING.POLARFOX_SPAWN_TIME_VARIATION)
	end
	
	function self:ScheduleFoxSpawn(pt, time_override)
		local spawntime = time_override or self:GetRespawnTime()
		
		if spawntime then
			_foxspawns[pt] = GetTime() + spawntime
			
			self.inst:DoTaskInTime(spawntime, function()
				self:RespawnFox(pt)
			end)
		end
	end
	
	function self:RespawnFox(pt)
		if pt and CanFoxSpawn(pt) then
			if ShouldFoxSpawn(pt) then
				local fox = SpawnPrefab("polarfox")
				fox.Transform:SetPosition(pt:Get())
				
				_foxspawns[pt] = nil
			else
				print("PolarFoxRespawner: rescheduling respawn point at ", pt)
				self:ScheduleFoxSpawn(pt)
			end
		elseif pt then
			print("PolarFoxRespawner: removed respawn point because of structure at ", pt)
			_foxspawns[pt] = nil
		end
	end
	
	--
	
	function self:GetDebugString()
		local str = ""
		local spawns = 0
		local t = GetTime()
		c_countprefabs("polarfox")
		
		for pt, spawn_time in pairs(_foxspawns) do
			local remaining_time = spawn_time - t
			
			spawns = spawns + 1
			str = str .. string.format("	Point #%d: %.2f, %.2f | Respawn in: %2f seconds\n", spawns, pt.x, pt.z, math.max(0, remaining_time))
		end
		
		return spawns > 0 and string.format("%d Respawn Points found:\n%s", spawns, str) or "No Respawn Point found"
	end
	
	function self:OnSave()
		local spawntimes = {}
		
		local _t = GetTime()
		for pt, t in pairs(_foxspawns) do
			table.insert(spawntimes, {
				x = pt.x,
				z = pt.z,
				remaining = t - _t,
			})
		end
		
		return not IsTableEmpty(spawntimes) and {
			spawntimes = spawntimes,
		} or nil
	end
	
	function self:OnLoad(data)
		if data and data.spawntimes then
			for i, spawn_data in ipairs(data.spawntimes) do
				if spawn_data.remaining and spawn_data.remaining > 0 then
					local pt = Vector3(spawn_data.x, 0, spawn_data.z)
					self:ScheduleFoxSpawn(pt, spawn_data.remaining)
				end
			end
		end
	end
	
	local function CanSpawnInSnow(pt)
		return TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z) == WORLD_TILES.POLAR_SNOW and FindClosestPlayerInRange(pt.x, 0, pt.z, 20) == nil
	end
	
	function self:FindSpawnPoint()
		local radius = TheWorld.Map:GetSize() * 2 * 0.85
		local attemps = 0
		local pt
		
		while attemps < 10 and pt == nil do
			pt = FindWalkableOffset(Vector3(0, 0, 0), math.random() * TWOPI, math.random(radius), 8, false, true, CanSpawnInSnow)
			attemps = attemps + 1
		end
		
		return pt
	end
	
	self.OnSeasonChange = function(_, season)
		local to_spawn = TUNING.POLARFOX_MIN_SPAWN_POINTS
		
		for k, v in pairs(Ents) do
			if v.prefab == "polarfox" then
				to_spawn = to_spawn - 1
			end
		end
		for k, v in pairs(_foxspawns) do
			to_spawn = to_spawn - 1
		end
		
		if to_spawn > 0 then
			print("PolarFoxRespawner: generating "..to_spawn.." new spawn points")
			for i = 1, to_spawn do
				local pt = self:FindSpawnPoint()
				
				if pt then
					print("PolarFoxRespawner: "..i..": success, at ", pt)
					self:RespawnFox(pt)
				else
					print("PolarFoxRespawner: "..i..": failed")
				end
			end
		end
	end
	
	self:WatchWorldState("season", self.OnSeasonChange)
end)