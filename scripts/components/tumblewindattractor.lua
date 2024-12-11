local function OnBlizzardLevelChanged(inst, data)
	local self = inst.components.tumblewindattractor
	local in_storm = TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst)
	
	if self then
		if in_storm and not self.enabled then
			self:Enable(true)
		elseif not in_storm and self.enabled then
			self:Enable(false)
		end
	end
end

local TumbleWindAttractor = Class(function(self, inst)
	self.inst = inst
	
	self.enabled = false
	self.spawndist = 40
	
	if TUNING.TUMBLEWIND_ENABLED then
		inst:ListenForEvent("blizzardstormlevel", OnBlizzardLevelChanged)
	end
end)

function TumbleWindAttractor:GetSpawnRate()
	return GetRandomMinMax(TUNING.TUMBLEWIND_SPAWNRATE_EARLY, TUNING.TUMBLEWIND_SPAWNRATE_LATER)
end

local TUMBLER_TAGS = {"tumblewind"}

function TumbleWindAttractor:CanSpawnTumbler(pt)
	return GetClosestPolarTileToPoint(pt.x, 0, pt.z, 32) ~= nil and not TheWorld.Map:IsPointNearHole(pt) and #FindPlayersInRange(pt.x, pt.y, pt.z, self.spawndist) == 0
		and #TheSim:FindEntities(pt.x, pt.y, pt.z, self.spawndist + 1, TUMBLER_TAGS) < TUNING.TUMBLEWIND_MAX_DENSITY
end

function TumbleWindAttractor:SpawnTumbler()
	local pt = self.inst:GetPosition()
	local offset = FindWalkableOffset(pt, math.random() * TWOPI, self.spawndist, 8, true, false, function(pt) return self:CanSpawnTumbler(pt) end)
	
	if offset then
		local tumbler = SpawnPrefab("tumbleweed_polar")
		tumbler.Transform:SetPosition((pt + offset):Get())
	end
	
	if self.enabled then
		if TheWorld.components.polarstorm and not TheWorld.components.polarstorm:IsInPolarStorm(self.inst) then
			self:Enable(false)
			return
		end
		
		local spawntime = self:GetSpawnRate()
		self._spawntask = self.inst:DoTaskInTime(spawntime, function()
			self:SpawnTumbler()
		end)
	end
end

function TumbleWindAttractor:Enable(enabled)
	self.enabled = enabled
	
	if not self.enabled and self._spawntask then
		self._spawntask:Cancel()
		self._spawntask = nil
	elseif self.enabled and self._spawntask == nil then
		if self.enabled then
			local spawntime = self:GetSpawnRate()
			
			self._spawntask = self.inst:DoTaskInTime(spawntime, function()
				self:SpawnTumbler()
			end)
		end
	end
end

return TumbleWindAttractor