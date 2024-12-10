local PolarPlower = Class(function(self, inst)
	self.inst = inst
	
	self.plow_range = 4
end)

local SNOWBLOCKER_TAGS = {"snowblocker"}
local MIN_SNOWBLOCKER_DIST = 2

function PolarPlower:CanPlow(doer, pos)
	if self.canplowfn then
		return self.canplowfn(self.inst, doer, pos)
	end
	
	return true
end

function PolarPlower:DoPlow(doer, pos)
	local blockers = TheSim:FindEntities(pos.x, pos.y, pos.z, self.plow_range, SNOWBLOCKER_TAGS)
	local dist = self.plow_range
	
	for i, v in ipairs(blockers) do
		if v.ExtendSnowBlocker then
			v:ExtendSnowBlocker(self.inst, doer)
		end
		
		local blocker_dist = v:GetDistanceSqToPoint(pos.x, pos.y, pos.z)
		if blocker_dist <= MIN_SNOWBLOCKER_DIST / 2 and v.SetSnowBlockRange and v._snowblockrange and v._snowblockrange:value() < self.plow_range then
			v:SetSnowBlockRange(self.plow_range)
		end
		
		dist = blocker_dist < dist and blocker_dist or dist
	end
	
	local blocker
	if dist >= MIN_SNOWBLOCKER_DIST then
		blocker = SpawnPrefab("snowwave_blocker")
		blocker.Transform:SetPosition(pos.x, pos.y, pos.z)
		
		if TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(blocker)
			and blocker.components.timer and blocker.components.timer:TimerExists("plowcycle") then
			
			local blizzard = TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(blocker)
			local timeleft = blocker.components.timer:GetTimeLeft("plowcycle")
			
			blocker.components.timer:SetTimeLeft("plowcycle", timeleft * (blizzard and TUNING.POLARPLOW_BLOCKER_STORMCUT or 1))
		end
		
		if blocker.SetSnowBlockRange then
			blocker:SetSnowBlockRange(self.plow_range)
		end
	end
	
	local fx = SpawnPrefab("polar_splash_large")
	fx.Transform:SetPosition(pos.x, pos.y, pos.z)
	
	if doer and doer.SoundEmitter then
		doer.SoundEmitter:PlaySound(self.plow_sound or "polarsounds/common/snow_plow")
	end
	
	if self.onplowfn then
		self.onplowfn(self.inst, doer, pos, blocker, blockers)
	end
	
	return true, blocker, blockers
end

return PolarPlower