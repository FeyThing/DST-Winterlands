local function GenerateAndSpawnIceCavePillarShadePositions(inst)
	local self = inst.components.IceCavePillarShade
	if self == nil then
		return
	end
	
	self:GenerateIceCavePillarShadePositions()
	self:SpawnShadows()
end

local IceCavePillarShade = Class(function(self, inst)
	self.inst = inst
	
	self.range = math.floor(TUNING.SHADE_CANOPY_RANGE / 4)
	
	self.IceCavePillarShade_positions = {}
	self.spawned = false
	
	inst:DoTaskInTime(0, GenerateAndSpawnIceCavePillarShadePositions)
end)

function IceCavePillarShade:OnRemoveEntity()
	self:DespawnShadows(true)
	self:RemoveIceCavePillarShadePositions()
end

IceCavePillarShade.OnRemoveFromEntity = IceCavePillarShade.OnRemoveEntity

Global_IceCavePillarShade = {}
local IceCavePillarShades = Global_IceCavePillarShade

function IceCavePillarShade:GenerateIceCavePillarShadePositions()
	local x, y, z = self.inst.Transform:GetWorldPosition()
	
	for i = -self.range, self.range do
		for t = -self.range, self.range do
			if math.random() < 0.8 and ((t * t) + (i * i)) <= self.range * self.range then
				local newx = math.floor((x + i * 4) / 4) * 4 + 2
				local newz = math.floor((z + t * 4) / 4) * 4 + 2
				
				local shadetile_key = newx.."-"..newz
				local shadetile = IceCavePillarShades[shadetile_key]
				
				if not shadetile then
					table.insert(self.IceCavePillarShade_positions, {newx, newz})
					IceCavePillarShades[shadetile_key] = {refs = 1, spawnrefs = 0}
				else
					shadetile.refs = shadetile.refs + 1
				end
			end
		end
	end
end

function IceCavePillarShade:RemoveIceCavePillarShadePositions()
	for i, v in ipairs(self.IceCavePillarShade_positions) do
		local x, z = v[1], v[2]
		
		local shadetile_key = x.."-"..z
		local shadetile = IceCavePillarShades[shadetile_key]
		
		shadetile.refs = shadetile.refs - 1
		if shadetile.refs == 0 then
			IceCavePillarShades[shadetile_key] = nil
		end
	end
end

function IceCavePillarShade:OnEntitySleep()
	if not IsTableEmpty(self.IceCavePillarShade_positions) then
		self:DespawnShadows()
	end
end

function IceCavePillarShade:OnEntityWake()
	if not IsTableEmpty(self.IceCavePillarShade_positions) then
		self:SpawnShadows()
	end
end

function IceCavePillarShade:SpawnShadows()
	if self.spawned or not self.inst.entity:IsAwake() then
		return
	end
	
	for i, v in ipairs(self.IceCavePillarShade_positions) do
		local x, z = v[1], v[2]
		local shadetile = IceCavePillarShades[x.."-"..z]
		
		shadetile.spawnrefs = shadetile.spawnrefs + 1
		if shadetile.spawnrefs == 1 then
			shadetile.id = SpawnIceCavePillarShade(x, z)
		end
	end
	
	self.spawned = true
end

function IceCavePillarShade:DespawnShadows(ignore_entity_sleep)
	if not self.spawned or (not ignore_entity_sleep and self.inst.entity:IsAwake()) then
		return
	end
	
	for i, v in ipairs(self.IceCavePillarShade_positions) do
		local x, z = v[1], v[2]
		local shadetile = IceCavePillarShades[x.."-"..z]
		
		shadetile.spawnrefs = shadetile.spawnrefs - 1
		if shadetile.spawnrefs == 0 then
			DeSpawnIceCavePillarShade(shadetile.id)
			shadetile.id = nil
		end
	end
	
	self.spawned = false
end

return IceCavePillarShade