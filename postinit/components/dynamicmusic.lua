local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local POLAR_BUSY_MUSIC = "polarsounds/music/music_work"
local SEASON_BUSY_MUSIC = {
	autumn = "dontstarve/music/music_work",
	winter = "dontstarve/music/music_work_winter",
	spring = "dontstarve_DLC001/music/music_work_spring",
	summer = "dontstarve_DLC001/music/music_work_summer",
}

ENV.AddComponentPostInit("dynamicmusic", function(self)
	function self:UpdatePolarMusic(self, ignore)
		if ignore then
			return
		end
		
		local setpolar = IsInPolar(ThePlayer)
		if self._polar ~= setpolar then
			local isplaying = TheFocalPoint.SoundEmitter:PlayingSound("busy")
			TheFocalPoint.SoundEmitter:KillSound("busy")
			
			for k, v in pairs(SEASON_BUSY_MUSIC) do
				ENV.RemoveRemapSoundEvent(v)
				
				if setpolar then
					ENV.RemapSoundEvent(v, POLAR_BUSY_MUSIC)
				end
			end
			
			if isplaying then
				TheFocalPoint.SoundEmitter:PlaySound(SEASON_BUSY_MUSIC[TheWorld.state.season] or SEASON_BUSY_MUSIC["autumn"], "busy")
				TheFocalPoint.SoundEmitter:SetParameter("busy", "intensity", 1)
			end
			self._polar = setpolar
		end
	end
	
	self._polartask = self.inst:DoPeriodicTask(1, self.UpdatePolarMusic, nil, self)
end)