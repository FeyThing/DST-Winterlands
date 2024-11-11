local SnowWaver = Class(function(self, inst)
	self.inst = inst
	
	self.enabled = false
	self.lines = 30
	self.rows = 30
	self.spacing_x = 2.5
	self.spacing_y = 2.5
	
	self.waves = {}
	self.waves_data = {}
	
	self:WatchWorldState("temperature", self.OnTemperatureChanged)
	self:OnTemperatureChanged(TheWorld.state.temperature)
end)

function SnowWaver:OnRemoveFromEntity()
	self:StopWatchingWorldState("temperature", self.OnTemperatureChanged)
end

function SnowWaver:GetWavePosition(row, line, pt, cx, cy, cz)
	local x, y, z
	
	if pt then
		x, y, z = pt:Get()
	end
	if z == nil and cz then
		x, y, z = cx, cy, cz
	end
	
	local row_x = -(self.lines / 2 * self.spacing_x) + (line - 1) * self.spacing_x
	local row_z = -(self.rows / 2 * self.spacing_y) + (row - 1) * self.spacing_y - 1
	
	local heading = math.rad(TheCamera:GetHeadingTarget()) -- GetHeading would be smoother but causes bigger fps drop, so maybe after some optimization
	local heading_cos = math.cos(heading)
	local heading_sin = math.sin(heading)
	
	local rotated_x = row_x * heading_cos - row_z * heading_sin
	local rotated_z = row_x * heading_sin + row_z * heading_cos
	
	return x + rotated_x, 0, z + rotated_z, Vector3(x, y, z)
end

function SnowWaver:RemoveWaves()
	for k, wave in pairs(self.waves) do
		wave:Remove()
	end
	
	self.waves = {}
	self.waves_data = {}
end

function SnowWaver:SetWaves()
	local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(TheCamera.currentpos:Get())
	local i = 1
	
	for row = 1, self.rows do
		for line = 1, self.lines do
			local id = tostring(i)
			local wave = self.waves[id]
			
			local x, y, z, pt = self:GetWavePosition(row, line, self.waves_data[id], cx, cy, cz)
			local insnow = TheWorld.Map:GetTileAtPoint(x, 0, z) == WORLD_TILES.POLAR_SNOW and not TheWorld.Map:IsPolarSnowBlocked(x, 0, z)
			
			if wave == nil and insnow then
				wave = SpawnPrefab("snowwave")
				wave._id = id
				
				wave:DoWaveFade()
			end
			
			if wave and wave:IsValid() and insnow then
				wave.Transform:SetPosition(x, y, z)
				self.waves[id] = wave
				self.waves_data[id] = pt
			else
				if wave and wave:IsValid() then
					wave:DoWaveFade(true)
				end
			end
			
			i = i + 1
		end
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