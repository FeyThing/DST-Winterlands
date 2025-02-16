local SnowwaveMelter = Class(function(self, inst)
	self.inst = inst
	
	self.melt_range = TUNING.SNOW_BLOCK_RANGES.FIRE -- same as default _snowblockrange
	self.melt_rate = 0.5
	self.melt_time = TUNING.POLARPLOW_BLOCKER_DURATION_FIRE
	self.min_dist = 4
	
	self.melting = false
end)

local SNOWBLOCKER_TAGS = {"snowblocker"}
local MIN_SNOWBLOCKER_DIST = 2

function SnowwaveMelter:CanMelt()
	return (self.canmeltfn and self.canmeltfn(self.inst)) or not self.inst:HasTag("INLIMBO")
end

function SnowwaveMelter:Melt()
	if not self:CanMelt() then
		return
	end
	
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local blockers = TheSim:FindEntities(x, y, z, MIN_SNOWBLOCKER_DIST, SNOWBLOCKER_TAGS)
	
	local should_melt = true
	for i, v in ipairs(blockers) do
		if v.ExtendSnowBlocker then
			should_melt = false
			
			local range = v._snowblockrange and v._snowblockrange:value() or 0
			if v.SetSnowBlockRange and range < self.melt_range then			
				v:SetSnowBlockRange(range, self.inst)
			end
			v:ExtendSnowBlocker(self.inst)
		end
	end
	
	if should_melt then
		local blocker = SpawnPrefab("snowwave_blocker")
		blocker.Transform:SetPosition(x, y, z)
		
		blocker._gradual_time = self.melt_time
		blocker:ExtendSnowBlocker(self.inst, true, self.melt_time)
		if blocker.SetSnowBlockRange then
			blocker:SetSnowBlockRange(self.melt_range)
		end
		
		return blocker
	end
end

function SnowwaveMelter:StartMelting()
	self.melting = true
	
	if self.melt_task == nil then
		self.melt_task = self.inst:DoPeriodicTask(self.melt_rate, function() self:Melt() end, 0)
	end
end

function SnowwaveMelter:StopMelting()
	if self.melt_task then
		self.melt_task:Cancel()
		self.melt_task = nil
	end
	
	self.melting = false
end

return SnowwaveMelter