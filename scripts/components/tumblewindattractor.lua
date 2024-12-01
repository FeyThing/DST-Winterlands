local function OnBlizzardLevelChanged(inst, data)
	local level = data and data.level or 0
	local self = inst.components.tumblewindattractor
	
	if self then
		if self.enabled and level <= 0 then
			self:Enable(false)
		elseif not self.enabled and level >= TUNING.SANDSTORM_FULL_LEVEL then
			self:Enable(true)
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
	return not TheWorld.Map:IsPointNearHole(pt) and #FindPlayersInRange(pt.x, pt.y, pt.z, self.spawndist) == 0
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