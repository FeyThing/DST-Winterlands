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
	
	local MOB_HEAD_TAGS = {"mobhead_combat"}
	local MOB_HEAD_NOT_TAGS = {"burnt", "constructionsite", "INLIMBO"}
	
	function Combat:CalcMobHeadsDamageMult(attacker, target, weapon)
		local mult = 1
		
		if attacker == nil or target == nil or not (attacker:HasTag("player") or target:HasTag("player")) then
			return 1
		end
		
		local mult_target = attacker:HasTag("player") and attacker or target
		
		local x, y, z = mult_target.Transform:GetWorldPosition()
		local heads = TheSim:FindEntities(x, y, z, TUNING.MOBHEADS_COMBAT_BUFF_RANGE, MOB_HEAD_TAGS, MOB_HEAD_NOT_TAGS)
		local stacks = 0
		
		for i, head in ipairs(heads) do
			local mods = head.mobhead_combat_mods
			local stacked = false
			
			if mods and mods.tags and not (mods.stacking and stacks >= mods.stacking) then
				if attacker == mult_target then
					if target:HasAnyTag(mods.tags) and not (mods.not_tags and target:HasAnyTag(mods.not_tags)) then
						mult = mult + (mods.damagemult)
						stacked = true
					end
				end
				
				if target == mult_target then
					if attacker:HasAnyTag(mods.tags) and not (mods.not_tags and attacker:HasAnyTag(mods.not_tags)) then
						mult = mult + (mods.armormult)
						stacked = true
					end
				end
				
				if stacked then
					stacks = stacks + 1
				end
			end
		end
		
		return math.max(mult, 0)
	end
	
	local OldCalcDamage = Combat.CalcDamage
	function Combat:CalcDamage(target, weapon, multiplier, ...)
		local damage, spdamage = OldCalcDamage(self, target, weapon, multiplier, ...)
		
		if damage and damage > 0 and target then
			local mobhead_mult = self:CalcMobHeadsDamageMult(self.inst, target, weapon)
			
			damage = damage * mobhead_mult
		end
		
		return damage, spdamage
	end
	
	local OldGetAttacked = Combat.GetAttacked
	function Combat:GetAttacked(attacker, damage, weapon, ...)
		if self.inst.components.health and self.inst.components.health:IsDead() then
			return OldGetAttacked(self, attacker, damage, weapon, ...)
		end
		
		if self.inst.components.frozenarmor then
			damage = self.inst.components.frozenarmor:ApplyFrozenArmor(attacker, damage, weapon)
		end
		
		return OldGetAttacked(self, attacker, damage, weapon, ...)
	end