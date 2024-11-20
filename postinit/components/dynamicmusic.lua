local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local POLAR_BUSY_MUSIC = "polarsounds/music/music_work"

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
end)