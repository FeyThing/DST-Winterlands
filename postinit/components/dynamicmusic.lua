local ENV = env
GLOBAL.setfenv(1, GLOBAL)

if ENV.GetModConfigData("misc_music") == false then
	return
end

local POLAR_BUSY_MUSIC = "polarsounds/music/music_work"

local POLAR_TRIGGERED_DANGER_MUSIC = {
	emperor_penguin = {"polarsounds/music/music_epicfight_emperor_penguin"},
}

--

local SEASON_BUSY_MUSIC = {
	autumn = "dontstarve/music/music_work",
	winter = "dontstarve/music/music_work_winter",
	spring = "dontstarve_DLC001/music/music_work_spring",
	summer = "dontstarve_DLC001/music/music_work_summer",
}

local SEASON_DANGER_MUSIC = {
	autumn = "dontstarve/music/music_danger",
	winter = "dontstarve/music/music_danger_winter",
	spring = "dontstarve_DLC001/music/music_danger_spring",
	summer = "dontstarve_DLC001/music/music_danger_summer",
}

local SEASON_EPICFIGHT_MUSIC = {
	autumn = "dontstarve/music/music_epicfight",
	winter = "dontstarve/music/music_epicfight_winter",
	spring = "dontstarve_DLC001/music/music_epicfight_spring",
	summer = "dontstarve_DLC001/music/music_epicfight_summer",
}

ENV.AddComponentPostInit("dynamicmusic", function(self)
	--	Work Music
	
	function self:UpdatePolarMusic(self, ignore)
		if ThePlayer == nil then
			return
		end

		if ignore then
			return
		end
		
		local x, y, z = ThePlayer.Transform:GetWorldPosition()
		local setpolar = GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil
		if self._polar ~= setpolar then
			local isplaying = TheFocalPoint.SoundEmitter:PlayingSound("busy")
			
			TheFocalPoint.SoundEmitter:KillSound("busy")
			
			for k, v in pairs(SEASON_BUSY_MUSIC) do
				ENV.RemoveRemapSoundEvent(v)
				
				if setpolar then
					ENV.RemapSoundEvent(v, POLAR_BUSY_MUSIC)
				end
			end
			
			for k, v in pairs(SEASON_DANGER_MUSIC) do
				ENV.RemoveRemapSoundEvent(v)
				
				if setpolar then
					ENV.RemapSoundEvent(v, SEASON_DANGER_MUSIC.winter)
				end
			end
			
			for k, v in pairs(SEASON_EPICFIGHT_MUSIC) do
				ENV.RemoveRemapSoundEvent(v)
				
				if setpolar then
					ENV.RemapSoundEvent(v, SEASON_EPICFIGHT_MUSIC.winter)
				end
			end
			
			if isplaying then
				TheFocalPoint.SoundEmitter:PlaySound(SEASON_BUSY_MUSIC[TheWorld.state.season] or SEASON_BUSY_MUSIC["autumn"], "busy")
				--TheFocalPoint.SoundEmitter:SetParameter("busy", "intensity", 1)
			end
			
			self._polar = setpolar
		end
	end
	
	self._polartask = self.inst:DoPeriodicTask(1, self.UpdatePolarMusic, nil, self)
	
	--	Boss Music
	
	local StartPlayerListeners
	
	if self.inst.event_listening and self.inst.event_listening["playeractivated"] then
		for i, v in ipairs(self.inst.event_listening["playeractivated"][self.inst]) do
			StartPlayerListeners = PolarUpvalue(v, "StartPlayerListeners")
			if StartPlayerListeners then
				break
			end
		end
	end
	
	local StartTriggeredDanger = PolarUpvalue(StartPlayerListeners, "StartTriggeredDanger")
	local TRIGGERED_DANGER_MUSIC = PolarUpvalue(StartTriggeredDanger, "TRIGGERED_DANGER_MUSIC")
	
	if TRIGGERED_DANGER_MUSIC then
		for boss, data in pairs(POLAR_TRIGGERED_DANGER_MUSIC) do
			TRIGGERED_DANGER_MUSIC[boss] = data
		end
	end
end)