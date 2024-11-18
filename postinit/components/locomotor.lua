local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local LocoMotor = require("components/locomotor")
	
	function LocoMotor:StopUnderPolarIce()
		return self.inst:HasTag("swimming") and TheWorld.Map:GetTileAtPoint(self.inst.Transform:GetWorldPosition()) == WORLD_TILES.POLAR_ICE
	end
	
	local OldSetMotorSpeed = LocoMotor.SetMotorSpeed
	function LocoMotor:SetMotorSpeed(speed, ...)
		if self:StopUnderPolarIce() then
			speed = 0
		end
		
		return OldSetMotorSpeed(self, speed, ...)
	end