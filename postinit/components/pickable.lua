local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Pickable = require("components/pickable")
	
	function Pickable:PolarPause(enable)
		self.polar_paused = enable and self.pause_in_polar
		
		if self.polar_paused then
			self:Pause()
		elseif self.paused and (not self.pause_in_polar or not TheWorld.state.iswinter) then
			self:Resume()
		end
	end
	
	local OldResume = Pickable.Resume
	function Pickable:Resume(...)
		if self.polar_paused then
			return
		end
		
		return OldResume(self, ...)
	end