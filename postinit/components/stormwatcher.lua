local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local StormWatcher = require("components/stormwatcher")

local old_StormWatcher_ctor = StormWatcher._ctor
StormWatcher._ctor = function(self, ...)
	old_StormWatcher_ctor(self, ...)

	local old_onstormtype = self._.currentstorm[2] -- Accessing the prop function for currentstorm
	self._.currentstorm[2] = function(self, ...)
		old_onstormtype(self, ...)
		if self.inst.player_classified then
			self.inst.player_classified.stormtypechange:push()
		end
	end

	if TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsPolarStormActive() then
		self:UpdateStorms({ stormtype = STORM_TYPES.POLARSTORM, setting = true })
	end
end

local old_StormWatcher_UpdateStormLevel = StormWatcher.UpdateStormLevel
StormWatcher.UpdateStormLevel = function(self, ...)
    self:CheckStorms() -- LukaS: Doubled up unfortunately but shouldn't cause any problems

	if self.currentstorm ~= STORM_TYPES.NONE then
		if self.currentstorm == STORM_TYPES.POLARSTORM then
			self.stormlevel = math.floor(TheWorld.components.polarstorm:GetPolarStormLevel(self.inst) * 7 + 0.5) / 7
			self.inst.components.polarstormwatcher:UpdatePolarStormLevel()
		end
	else
		if self.laststorm ~= STORM_TYPES.NONE then
			if self.laststorm == STORM_TYPES.POLARSTORM then
				self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "polarstorm")
			end
		end
	end

	old_StormWatcher_UpdateStormLevel(self, ...)
end

local old_StormWatcher_GetCurrentStorm = StormWatcher.GetCurrentStorm
StormWatcher.GetCurrentStorm = function(self, ...)
	local currentstorm = old_StormWatcher_GetCurrentStorm(self, ...)
	if TheWorld.components.polarstorm:IsInPolarStorm(self.inst) then
		assert(currentstorm == STORM_TYPES.NONE,"CAN'T BE IN TWO STORMS AT ONCE")
		currentstorm = STORM_TYPES.POLARSTORM
	end
	
	return currentstorm
end