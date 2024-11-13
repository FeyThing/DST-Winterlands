local function GenerateAndSpawnPolarCaveShadePositions(inst)
	local self = inst.components.polarcaveshade
	if self == nil then
		return
	end
	
	self:GeneratePolarCaveShadePositions()
	self:SpawnShadows()
end

local PolarCaveShade = Class(function(self, inst)
	self.inst = inst
	
	self.range = TUNING.SHADE_POLAR_RANGE / 4
	
	self.PolarCaveShade_positions = {}
	self.spawned = false
	
	inst:DoTaskInTime(0, GenerateAndSpawnPolarCaveShadePositions)
end)

function PolarCaveShade:OnRemoveEntity()
	self:DespawnShadows(true)
	self:RemovePolarCaveShadePositions()
end

PolarCaveShade.OnRemoveFromEntity = PolarCaveShade.OnRemoveEntity

Global_PolarCaveShade = {}
local PolarCaveShades = Global_PolarCaveShade

function PolarCaveShade:GeneratePolarCaveShadePositions()
	local x, y, z = self.inst.Transform:GetWorldPosition()
	
	for i = -self.range, self.range do
		for t = -self.range, self.range do
			if math.random() < 0.8 and ((t * t) + (i * i)) <= self.range * self.range then
				local newx = math.floor((x + i * 4) / 4) * 4 + 2
				local newz = math.floor((z + t * 4) / 4) * 4 + 2
				
				local shadetile_key = newx.."-"..newz
				local shadetile = PolarCaveShades[shadetile_key]
				
				if not shadetile then
					table.insert(self.PolarCaveShade_positions, {newx, newz})
					PolarCaveShades[shadetile_key] = {refs = 1, spawnrefs = 0}
				else
					shadetile.refs = shadetile.refs + 1
				end
			end
		end
	end
end

function PolarCaveShade:RemovePolarCaveShadePositions()
	for i, v in ipairs(self.PolarCaveShade_positions) do
		local x, z = v[1], v[2]
		
		local shadetile_key = x.."-"..z
		local shadetile = PolarCaveShades[shadetile_key]
		
		shadetile.refs = shadetile.refs - 1
		if shadetile.refs == 0 then
			PolarCaveShades[shadetile_key] = nil
		end
	end
end

function PolarCaveShade:OnEntitySleep()
	if not IsTableEmpty(self.PolarCaveShade_positions) then
		self:DespawnShadows()
	end
end

function PolarCaveShade:OnEntityWake()
	if not IsTableEmpty(self.PolarCaveShade_positions) then
		self:SpawnShadows()
	end
end

function PolarCaveShade:SpawnShadows()
	if self.spawned or not self.inst.entity:IsAwake() then
		return
	end
	
	for i, v in ipairs(self.PolarCaveShade_positions) do
		local x, z = v[1], v[2]
		local shadetile = PolarCaveShades[x.."-"..z]
		
		shadetile.spawnrefs = shadetile.spawnrefs + 1
		if shadetile.spawnrefs == 1 then
			shadetile.id = SpawnPolarCaveShade(x, z)
		end
	end
	
	self.spawned = true
end

function PolarCaveShade:DespawnShadows(ignore_entity_sleep)
	if not self.spawned or (not ignore_entity_sleep and self.inst.entity:IsAwake()) then
		return
	end
	
	for i, v in ipairs(self.PolarCaveShade_positions) do
		local x, z = v[1], v[2]
		local shadetile = PolarCaveShades[x.."-"..z]
		
		shadetile.spawnrefs = shadetile.spawnrefs - 1
		if shadetile.spawnrefs == 0 then
			DespawnPolarCaveShade(shadetile.id)
			shadetile.id = nil
		end
	end
	
	self.spawned = false
end

return PolarCaveShade