local function OnSnowBlockRangeDirty(inst, data)
	local self = inst.components.snowwaver
	
	if self then
		self.blocker_update = true
	end
end

local function OnPlayerDespawn(inst)
	local self = inst.components.snowwaver
	
	if self and self.enabled then
		self:Enable(false)
		self:RemoveWaves()
	end
end

local function OnInPolar(inst, enable)
	local self = inst.components.snowwaver
	
	if self then
		--self:Enable(enable)
		self:OnTemperatureChanged()
	end
end

local SnowWaver = Class(function(self, inst)
	self.inst = inst
	
	self.enabled = false
	self.lines = 40
	self.rows = 40
	self.spacing_x = TILE_SCALE / 2
	self.spacing_y = TILE_SCALE / 2
	
	self.waves_positions = {}
	self.last_tile = {}
	
	if TUNING.POLAR_WAVES_ENABLED then
		self.blocker_update = true
		self.inst:ListenForEvent("setinpolar", OnInPolar)
	end
end)

function SnowWaver:OnRemoveFromEntity()
	if self.enabled then
		self:Enable(false)
	end
end

function SnowWaver:OnTemperatureChanged(temperature)
	temperature = temperature or TheWorld.state.temperature
	
	if temperature <= TUNING.POLAR_SNOW_MELT_TEMP and not self.enabled then
		self:Enable(true)
	elseif temperature > TUNING.POLAR_SNOW_MELT_TEMP and self.enabled then
		self:Enable(false)
	end
end

--	TODO: Angular positioning is disabled until SetWaves can recognize their old position under all camera angles, and spacing other than multiples of 2
function SnowWaver:GetWavePosition(row, line, x, y, z)
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

function SnowWaver:RemoveWaves()
	for pt_str, wave in pairs(self.waves_positions) do
		if wave and wave:IsValid() then
			wave:DoWaveFade(true, wave.Remove)
		end
	end
	
	self.waves_positions = {}
	self.last_tile = {}
end

function SnowWaver:SetWaves()
	local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(TheCamera.currentpos:Get())
	local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(cx, cy, cz)
	
	if self.blocker_update --[[ or TheCamera:GetHeadingTarget() ~= TheCamera:GetHeading() or tile_x ~= self.last_tile[1] or tile_y ~= self.last_tile[2] ]] then
		local valid_positions = {}
		for row = 1, self.rows do
			for line = 1, self.lines do
				local pt = self:GetWavePosition(row, line, cx, cy, cz)
				local pt_str = string.format("%.2f_%.2f", pt.x, pt.z)
				
				valid_positions[pt_str] = pt
			end
		end
		
		for pt_str, wave in pairs(self.waves_positions) do
			if not valid_positions[pt_str] then
				if wave and wave:IsValid() then
					wave:DoWaveFade(true, wave.Remove)
				end
				
				self.waves_positions[pt_str] = nil
			end
		end
		
		for row = 1, self.rows do
			for line = 1, self.lines do
				local pt = self:GetWavePosition(row, line, cx, cy, cz)
				local pt_str = string.format("%.2f_%.2f", pt.x, pt.z)
				
				local wave = self.waves_positions[pt_str]
				local insnow = TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z) == WORLD_TILES.POLAR_SNOW and not TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z)
				
				if wave == nil and valid_positions[pt_str] then
					wave = SpawnPrefab("snowwave")
					if insnow then
						wave:DoWaveFade()
					end
					self.waves_positions[pt_str] = wave
				end
				
				if wave and wave:IsValid() then
					wave.Transform:SetPosition(pt.x, pt.y, pt.z)
					
					if not insnow and not wave._fading then
						wave:DoWaveFade(true)
					elseif insnow and wave._fading then
						wave:DoWaveFade()
					end
				end
			end
		end
		
		self.last_tile = {tile_x, tile_y}
		self.blocker_update = nil
	end
end

function SnowWaver:SpawnWaves()
	self:RemoveWaves()
	self:SetWaves()
end

function SnowWaver:Enable(enabled)
	self.enabled = enabled or false
	
	if self.enabled then
		self:SpawnWaves()
		self.inst:StartUpdatingComponent(self)
		
		-- For fires or other blockers that don't update the client
		self.update_internal = self.inst:DoPeriodicTask(TUNING.POLAR_SNOW_UPDATE_RATE, function() self.blocker_update = true end)
		self.inst:ListenForEvent("snowwave_blockerupdate", OnSnowBlockRangeDirty)
		self.inst:ListenForEvent("onremove", OnPlayerDespawn)
	elseif self.update_internal then
		self.update_internal:Cancel()
		self.update_internal = nil
		self.inst:RemoveEventCallback("snowwave_blockerupdate", OnSnowBlockRangeDirty)
		self.inst:RemoveEventCallback("onremove", OnPlayerDespawn)
	end
end

function SnowWaver:OnUpdate(dt) -- TODO: Change to static updates so waves get replaced even when paused for camera rotations
	if not self.enabled then
		self:RemoveWaves()
		self.inst:StopUpdatingComponent(self)
		return
	end
	
	self:SetWaves()
end

return SnowWaver