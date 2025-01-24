local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldUpdateCampOccupied
local function UpdateCampOccupied(inst, ...)
	if not IsInPolar(inst) then
		return OldUpdateCampOccupied(inst, ...)
	end
end

local OldSetOccupied
local function SetOccupied(inst, occupied, ...)
	occupied = IsInPolar(inst) or occupied
	
	return OldSetOccupied(inst, occupied, ...)
end

local OldSpawnHuntingParty

local OldCheckSpawnHuntingParty
local function CheckSpawnHuntingParty(inst, target, houndsonly, ...)
	if not IsInPolar(inst) then
		return OldCheckSpawnHuntingParty(inst, target, houndsonly, ...)
	end
	
	if OldSpawnHuntingParty then
		OldSpawnHuntingParty(inst, target, houndsonly, ...)
	end
end

local function PolarInit(inst)
	if IsInPolar(inst) then
		SetOccupied(inst, true)
		
		if TheWorld.event_listeners.megaflare_detonated and TheWorld.event_listeners.megaflare_detonated[inst] then
			local OldOnMegaFlare = TheWorld.event_listeners.megaflare_detonated[inst][1]
			--	Don't TP MacTusk & Friends if it's a camp on the island !!
			TheWorld.event_listeners.megaflare_detonated[inst][1] = function(src, data, ...)
				if not IsInPolar(inst) and OldOnMegaFlare then
					OldOnMegaFlare(src, data, ...)
				end
			end
		end
	end
end

local function OnPolarstormChanged(inst, active)
	if active and TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst) then
		inst._leavestormtask = inst:DoPeriodicTask(1, function()
			local childrens = inst.data and inst.data.children
			
			if childrens and not IsTableEmpty(childrens) then
				for child in pairs(childrens) do
					if child:IsValid() and child.components.combat and child.components.combat.target == nil
						and child.components.health and not child.components.health:IsDead() then
						if child.components.entitytracker then
							child.components.entitytracker:ForgetEntity("leader")
						end
						
						if child:HasTag("walrus") then
							child:AddTag("taunt_attack")
							
							if child.components.leader then
								child.components.leader:RemoveAllFollowers()
							end
							if child.components.locomotor then
								local action = BufferedAction(child, inst, ACTIONS.GOHOME, nil, inst:GetPosition())
								
								child.components.locomotor:PushAction(action, true, true)
							end
						end
					end
				end
			end
		end)
	elseif inst._leavestormtask then
		inst._leavestormtask:Cancel()
		inst._leavestormtask = nil
	end
end

ENV.AddPrefabPostInit("walrus_camp", function(inst)
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "polarbearhouse._snowblockrange")
	inst._snowblockrange:set(5)
	
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.OnEntitySleep and OldUpdateCampOccupied == nil then
		OldUpdateCampOccupied = PolarUpvalue(inst.OnEntitySleep, "UpdateCampOccupied")
		OldCheckSpawnHuntingParty = PolarUpvalue(inst.OnEntitySleep, "CheckSpawnHuntingParty")
		
		if OldUpdateCampOccupied and OldSetOccupied == nil then
			OldSetOccupied = PolarUpvalue(OldUpdateCampOccupied, "SetOccupied")
			
			PolarUpvalue(inst.OnEntitySleep, "UpdateCampOccupied", UpdateCampOccupied)
			PolarUpvalue(inst.OnEntitySleep, "CheckSpawnHuntingParty", CheckSpawnHuntingParty)
		end
		
		if OldSetOccupied then
			PolarUpvalue(OldUpdateCampOccupied, "SetOccupied", SetOccupied)
		end
		
		if OldCheckSpawnHuntingParty then
			OldSpawnHuntingParty = PolarUpvalue(OldCheckSpawnHuntingParty, "SpawnHuntingParty")
		end
	end
	
	inst.onpolarstormchanged = function(src, data)
		if data and data.stormtype == STORM_TYPES.POLARSTORM then
			OnPolarstormChanged(inst, data.setting)
		end
	end
	
	inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	
	inst:DoTaskInTime(0, PolarInit)
end)