return Class(function(self, inst)
	self.inst = inst
	
	self.enabled = false
	self.lines = 50
	self.rows = 50
	self.spacing_x = TILE_SCALE / 2
	self.spacing_y = TILE_SCALE / 2
	
	self.waves_positions = {}
	self.last_tile = {}
	
	local _player = nil
	
	local batch_index = 1
	local batch_total = 0
	local BATCH_MAX_WAVES = 200
	
	local function OnSnowBlockRangeDirty(src, data)
		self.blocker_update = true
	end
	
	local function OnInPolar(inst, enable)
		self.in_polar = enable
		self:OnTemperatureChanged()
	end
	
	--
	
	function self:OnTemperatureChanged(temperature)
		if not _player then
			return
		end
		
		local x, y, z = _player.Transform:GetWorldPosition()
		temperature = temperature or TheWorld.state.temperature
		
		if temperature <= TUNING.POLAR_SNOW_MELT_TEMP and not self.enabled and self.in_polar then
			self:Enable(true)
		elseif (not self.in_polar or temperature > TUNING.POLAR_SNOW_MELT_TEMP) and self.enabled then
			self:Enable(false)
		end
	end
	
	--	TODO: Angular positioning is disabled until SetWaves can recognize their old position under all camera angles, and spacing other than multiples of 2
	function self:GetWavePosition(row, line, x, y, z)
		local row_x = -((self.lines - 1) * self.spacing_x) / 2 + (line - 1) * self.spacing_x
		local row_z = -((self.rows - 1) * self.spacing_y) / 2 + (row - 1) * self.spacing_y
		
		--[[local heading = math.rad(TheCamera:GetHeadingTarget())
		local heading_cos = math.cos(heading)
		local heading_sin = math.sin(heading)
		
		local rotated_x = row_x * heading_cos - row_z * heading_sin
		local rotated_z = row_x * heading_sin + row_z * heading_cos
		
		return Vector3(x + rotated_x, 0, z + rotated_z)]]
		return Vector3(x + row_x, 0, z + row_z)
	end
	
	function self:RemoveWaves()
		for pt_str, wave in pairs(self.waves_positions) do
			if wave and wave:IsValid() then
				wave:DoWaveFade(true, wave.Remove)
			end
		end
		
		self.waves_positions = {}
		self.last_tile = {}
	end
	
	function self:SetWaves()
		local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(TheCamera.currentpos:Get())
		local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(cx, cy, cz)
		
		-- or TheCamera:GetHeadingTarget() ~= TheCamera:GetHeading()
		if self.blocker_update or tile_x ~= self.last_tile[1] or tile_y ~= self.last_tile[2] then
			batch_index = 1
			batch_total = self.rows * self.lines
			self.last_tile = {tile_x, tile_y}
			self.blocker_update = nil
		end
		
		local processed = 0
		while processed < BATCH_MAX_WAVES and batch_index <= batch_total do
			local row = math.floor((batch_index - 1) / self.lines) + 1
			local line = (batch_index - 1) % self.lines + 1
			local pt = self:GetWavePosition(row, line, cx, cy, cz)
			local pt_str = string.format("%.2f_%.2f", pt.x, pt.z)
			
			local wave = self.waves_positions[pt_str]
			local insnow = TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z) == WORLD_TILES.POLAR_SNOW
				and not TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z, TUNING.POLAR_SNOW_FORGIVENESS.SNOWWAVE)
				
			if wave == nil and insnow then
				wave = SpawnPrefab("snowwave")
				wave.Transform:SetPosition(pt.x, pt.y, pt.z)
				self.waves_positions[pt_str] = wave
				wave:DoWaveFade()
			elseif wave and wave:IsValid() then
				if not insnow and not wave._fading then
					wave:DoWaveFade(true)
				elseif insnow and wave._fading then
					wave:DoWaveFade()
				end
			end
			
			batch_index = batch_index + 1
			processed = processed + 1
		end
		
		if batch_index > batch_total then
			for pt_str, wave in pairs(self.waves_positions) do
				if wave and wave:IsValid() then
					local x, _, z = wave.Transform:GetWorldPosition()
					local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
					
					if tile ~= WORLD_TILES.POLAR_SNOW then
						wave:DoWaveFade(true, wave.Remove)
						self.waves_positions[pt_str] = nil
					end
				end
			end
		end
	end
	
	function self:SpawnWaves()
		self:RemoveWaves()
		self:SetWaves()
	end
	
	function self:Enable(enabled)
		self.enabled = enabled or false
		
		if self.enabled then
			self:SpawnWaves()
			inst:StartUpdatingComponent(self)
			
			-- For fires or other blockers that don't update the client
			self.update_internal = inst:DoPeriodicTask(TUNING.POLAR_SNOW_UPDATE_RATE, function()
				self.blocker_update = true
			end)
			
			inst:ListenForEvent("snowwave_blockerupdate", OnSnowBlockRangeDirty)
		elseif self.update_internal then
			self.update_internal:Cancel()
			self.update_internal = nil
			inst:RemoveEventCallback("snowwave_blockerupdate", OnSnowBlockRangeDirty)
		end
	end
	
	function self:OnUpdate(dt) -- TODO: Change to static updates so waves get replaced even when paused for camera rotations
		if not self.enabled then
			self:RemoveWaves()
			inst:StopUpdatingComponent(self)
			return
		end
		
		self:SetWaves()
	end
	
	--
	
	local function OnPlayerActivated(inst, player)
		if _player ~= player then
			if _player == nil then
				inst:ListenForEvent("setinpolar", function(src, enable) OnInPolar(self, enable) end, player)
				inst:ListenForEvent("temperaturetick", function(src, temperature) self:OnTemperatureChanged(temperature) end)
			end
			_player = player
		end
	end
	
	local function OnPlayerDeactivated(inst, player)
		if _player == player then
			inst:RemoveEventCallback("setinpolar", function(src, enable) OnInPolar(self, enable) end, _player)
			inst:RemoveEventCallback("temperaturetick", function(src, temperature) self:OnTemperatureChanged(temperature) end)
			_player = nil
		end
	end
	
	if TUNING.POLAR_WAVES_ENABLED then
		self.blocker_update = true
		inst:ListenForEvent("playeractivated", OnPlayerActivated)
		inst:ListenForEvent("playerdeactivated", OnPlayerDeactivated)
	end
end)