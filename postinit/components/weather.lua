local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Weather = require("components/weather")

local old_Weather_ctor = Weather._ctor
Weather._ctor = function(self, ...)
	old_Weather_ctor(self, ...)
	
	local old_OnUpdate = self.OnUpdate
	self.OnUpdate = function(...)
		old_OnUpdate(...)
		
		if ThePlayer and ThePlayer.player_classified.polarsnowlevel:value() ~= 0 then
			if TheWorld.SoundEmitter:PlayingSound("rain") then
				-- TheWorld.SoundEmitter:SetParameter("rain", "intensity", 0) -- Does "rain" even have the intensity parameter???
				TheWorld.SoundEmitter:SetVolume("rain", 0)
			end
			
			if TheFocalPoint.SoundEmitter:PlayingSound("treerainsound") then
				TheFocalPoint.SoundEmitter:SetParameter("treerainsound", "intensity", 0)
			end
			
			if TheFocalPoint.SoundEmitter:PlayingSound("umbrellarainsound") then
				TheFocalPoint.SoundEmitter:SetVolume("umbrellarainsound", 0)
			end
			
			if TheFocalPoint.SoundEmitter:PlayingSound("barriersound") then
				TheFocalPoint.SoundEmitter:SetVolume("barriersound", 0)
			end
		else
			if TheWorld.SoundEmitter:PlayingSound("rain") then
				TheWorld.SoundEmitter:SetVolume("rain", 1)
			end
			
			if TheFocalPoint.SoundEmitter:PlayingSound("umbrellarainsound") then
				TheFocalPoint.SoundEmitter:SetVolume("umbrellarainsound", 1)
			end
			
			if TheFocalPoint.SoundEmitter:PlayingSound("barriersound") then
				TheFocalPoint.SoundEmitter:SetVolume("barriersound", 1)
			end
		end
	end
end