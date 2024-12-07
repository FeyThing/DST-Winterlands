local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local ExpertSailor = require("components/expertsailor")
	
	local function GetAmuletHorns(inst)
		local amulet = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		if amulet and amulet.GetAmuletParts then
			return amulet:GetAmuletParts("gnarwail_horn")
		end
		
		return 0
	end
	
	--
	
	local OldGetRowForceMultiplier = ExpertSailor.GetRowForceMultiplier
	function ExpertSailor:GetRowForceMultiplier(...)
		local mult = OldGetRowForceMultiplier(self, ...)
		
		local gnarwail_horns = GetAmuletHorns(self.inst)
		if gnarwail_horns > 0 then
			mult = (mult or 1) + (gnarwail_horns * TUNING.POLARAMULET.GNARWAIL_HORN.ROW_FORCE_MULT)
		end
		
		return mult
	end
	
	local OldGetRowExtraMaxVelocity = ExpertSailor.GetRowExtraMaxVelocity
	function ExpertSailor:GetRowExtraMaxVelocity(...)
		local vel = OldGetRowExtraMaxVelocity(self, ...)
		
		local gnarwail_horns = GetAmuletHorns(self.inst)
		if gnarwail_horns > 0 then
			vel = (vel or 1) + (gnarwail_horns * TUNING.POLARAMULET.GNARWAIL_HORN.ROW_MAX_VELOCITY)
		end
		
		return vel
	end
	
	local OldGetAnchorRaisingSpeed = ExpertSailor.GetAnchorRaisingSpeed
	function ExpertSailor:GetAnchorRaisingSpeed(...)
		local speed = OldGetAnchorRaisingSpeed(self, ...)
		
		local gnarwail_horns = GetAmuletHorns(self.inst)
		if gnarwail_horns > 0 then
			speed = (speed or 1) + (gnarwail_horns * TUNING.POLARAMULET.GNARWAIL_HORN.ANCHOR_RAISE_MULT)
		end
		
		return speed
	end
	
	local OldGetLowerSailStrength = ExpertSailor.GetLowerSailStrength
	function ExpertSailor:GetLowerSailStrength(...)
		local strength = OldGetLowerSailStrength(self, ...)
		
		local gnarwail_horns = GetAmuletHorns(self.inst)
		if gnarwail_horns > 0 then
			strength = (strength or TUNING.DEFAULT_SAIL_BOOST_STRENGTH) + (gnarwail_horns * TUNING.POLARAMULET.GNARWAIL_HORN.SAIL_STRENGTH_SPEED)
		end
		
		return strength
	end