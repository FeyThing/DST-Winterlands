local SnowWaver = Class(function(self, inst)
	self.inst = inst
	
	self.enabled = false
	self.lines = 30
	self.rows = 30
	self.spacing_x = TILE_SCALE
	self.spacing_y = TILE_SCALE
	
	self.waves = {}
	self.waves_positions = {}
	self.last_tile = {}
	
	--self:WatchWorldState("temperature", self.OnTemperatureChanged)
	--self:OnTemperatureChanged(TheWorld.state.temperature)
end)

function SnowWaver:OnRemoveFromEntity()
	--self:StopWatchingWorldState("temperature", self.OnTemperatureChanged)
end

function SnowWaver:GetWavePosition(row, line, x, y, z)
	local row_x = -((self.lines - 1) * self.spacing_x) / 2 + (line - 1) * self.spacing_x
	local row_z = -((self.rows - 1) * self.spacing_y) / 2 + (row - 1) * self.spacing_y
	
	local heading = math.rad(TheCamera:GetHeadingTarget())
	local heading_cos = math.cos(heading)
	local heading_sin = math.sin(heading)
	
	local rotated_x = row_x * heading_cos - row_z * heading_sin
	local rotated_z = row_x * heading_sin + row_z * heading_cos
	
	return Vector3(x + rotated_x, 0, z + rotated_z)
end

function SnowWaver:GetWaveRefreshPosition(positions)
	for str, pt in pairs(positions) do
		return pt, str
	end
end

function SnowWaver:RemoveWaves()
	for k, wave in pairs(self.waves) do
		if wave:IsValid() then
			wave:Remove()
		end
	end
	
	self.waves = {}
	self.waves_positions = {}
	self.last_tile = {}
end

function SnowWaver:SetWaves()
	local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(TheCamera.currentpos:Get())
	local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(cx, cy, cz)
	
	if TheCamera:GetHeadingTarget() ~= TheCamera:GetHeading() or tile_x ~= self.last_tile[1] or tile_y ~= self.last_tile[2] then
		local valid_positions = {}
		local i = 1
		
		for row = 1, self.rows do
			for line = 1, self.lines do
				local id = tostring(i)
				local pt = self:GetWavePosition(row, line, cx, cy, cz)
				
				if self.waves_positions[id] == nil then
					self.waves_positions[id] = pt
				end
				
				local pos_str = string.format("%.2f_%.2f", pt.x, pt.z)
				valid_positions[pos_str] = pt
				i = i + 1
			end
		end
		
		for id, pt in pairs(self.waves_positions) do
			local pos_str = string.format("%.2f_%.2f", pt.x, pt.z)
			
			if not valid_positions[pos_str] then
				local wave = self.waves[id]
				if wave and wave:IsValid() then
					wave:Remove()
				end
				
				self.waves[id] = nil
				self.waves_positions[id] = nil
			else
				valid_positions[pos_str] = nil
			end
		end
		
		i = 1
		for row = 1, self.rows do
			for line = 1, self.lines do
				local id = tostring(i)
				local pt = self.waves_positions[id]
				
				if pt == nil then
					local str
					pt, str = self:GetWaveRefreshPosition(valid_positions)
					valid_positions[str] = nil
				end
				
				local wave = self.waves[id]
				local insnow = TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z) == WORLD_TILES.POLAR_SNOW and not TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z)
				
				if not wave then
					wave = SpawnPrefab("snowwave")
					wave:DoWaveFade(not insnow)
					self.waves[id] = wave
				end
				
				wave.Transform:SetPosition(pt.x, pt.y, pt.z)
				i = i + 1
			end
		end
		
		self.last_tile = {tile_x, tile_y}
	end
end

function SnowWaver:SpawnWaves()
	self:RemoveWaves()
	self:SetWaves()
end

function SnowWaver:OnTemperatureChanged(temperature)
	
end

function SnowWaver:Enable(enabled)
	self.enabled = enabled or false
	
	if self.enabled then
		self:SpawnWaves()
		self.inst:StartUpdatingComponent(self)
	end
end

function SnowWaver:OnUpdate(dt)
	if not self.enabled then
		self:RemoveWaves()
		self.inst:StopUpdatingComponent(self)
		return
	end
	
	self:SetWaves()
end

return SnowWaver