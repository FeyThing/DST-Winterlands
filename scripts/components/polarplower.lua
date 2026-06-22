local PolarPlower = Class(function(self, inst)
	self.inst = inst
	
	self.plow_range = 4
end)

function PolarPlower:CanPlow(doer, pos)
	if self.canplowfn then
		return self.canplowfn(self.inst, doer, pos)
	end
	
	return true
end

function PolarPlower:DoPlow(doer, pos)
	local duration = GetPolarPlowDuration(doer, nil, "shovel")
	local dist = self.plow_range
	
	local blocker, blockers = SpawnPolarSnowBlocker(pos, self.plow_range, duration, doer, "shovel")
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