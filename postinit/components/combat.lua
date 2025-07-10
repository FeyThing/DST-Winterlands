local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Combat_Replica = require("components/combat_replica")
	
	local OldCanTarget = Combat_Replica.CanTarget
	function Combat_Replica:CanTarget(target, ...)
		if self.inst:HasTag("penguin") and target and target.prefab == "wall_polar" then
			return false -- We don't want Pengulls to break their castle...
		end
		
		return OldCanTarget(self, target, ...)
	end
	
	local OldIsAlly = Combat_Replica.IsAlly
	function Combat_Replica:IsAlly(guy, ...)
		if guy and guy:HasTag("flea") then
			if self.inst.replica.inventory and self.inst.replica.inventory:EquipHasTag("fleapack") then
				return guy.replica.combat == nil or guy.replica.combat:GetTarget() ~= self.inst
			elseif self.inst.components.inventory and self.inst.components.inventory:EquipHasTag("fleapack") then
				return guy.components.combat == nil or guy.components.combat:GetTarget() ~= self.inst
			end
		end
		
		return OldIsAlly(self, guy, ...)
	end