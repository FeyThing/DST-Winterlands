local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Combat_Replica = require("components/combat_replica")
	
	local OldCanTarget = Combat_Replica.CanTarget
	function Combat_Replica:CanTarget(target, ...)
		if self.inst:HasTag("penguin") and target and target.prefab == "wall_polar" then
			return false -- We don't want Pengulls to break their castle...
		end

		if self.inst:HasTag("player_trial_participator") and target and target:HasTag("trial_spectator") and not target:HasTag("trial_participator") then
			return false -- Don't target trial spectators if we're participating
		end
		
		return OldCanTarget(self, target, ...)
	end
	
	local OldIsAlly = Combat_Replica.IsAlly
	function Combat_Replica:IsAlly(guy, ...)
		local inventory = self.inst.replica.inventory or self.inst.components.inventory
		
		if guy and inventory then
			if guy:HasTag("flea") and not guy:HasTag("epic") and inventory:EquipHasTag("fleapack") then
				return guy.replica.combat == nil or guy.replica.combat:GetTarget() ~= self.inst
			elseif (guy:HasTag("walrus") or guy:HasTag("hound")) and self.inst:HasTag("walruspal") then -- Bagpipes buffed
				return guy.replica.combat == nil or guy.replica.combat:GetTarget() ~= self.inst
			end
		end
		
		return OldIsAlly(self, guy, ...)
	end


local Combat = require("components/combat")
local old_Combat_GetAttacked = Combat.GetAttacked
Combat.GetAttacked = function(self, attacker, damage, weapon, ...)
    if self.inst.components.health and self.inst.components.health:IsDead() then
        return old_Combat_GetAttacked(self, attacker, damage, weapon, ...)
    end

	if self.inst.components.frozenarmor then
		damage = self.inst.components.frozenarmor:ApplyFrozenArmor(attacker, damage, weapon)
	end

	return old_Combat_GetAttacked(self, attacker, damage, weapon, ...)
end