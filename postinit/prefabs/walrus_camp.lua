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

local WALRUS_SUPPORT_TAGS = {"walrus_support"}

local OldCanSpawn
local function CanSpawn(inst, prefab, ...)
	local test = OldCanSpawn(inst, prefab, ...)
	
	if test and prefab == "girl_walrus" then
		local min_chance = TUNING.GIRL_WALRUS_SPAWN_CHANCES.min
		local max_chance = TUNING.GIRL_WALRUS_SPAWN_CHANCES.max
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local has_support = #TheSim:FindEntities(x, y, z, 30, WALRUS_SUPPORT_TAGS) > 0
		
		local years = TheWorld.state.cycles / (
			((TheWorld.state.autumnlength ~= 0 and TheWorld.state.autumnlength) or TUNING.AUTUMN_LENGTH) +
			((TheWorld.state.winterlength ~= 0 and TheWorld.state.winterlength) or TUNING.WINTER_LENGTH) +
			((TheWorld.state.springlength ~= 0 and TheWorld.state.springlength) or TUNING.SPRING_LENGTH) +
			((TheWorld.state.summerlength ~= 0 and TheWorld.state.summerlength) or TUNING.SUMMER_LENGTH)
		)
		
		-- Can't spawn if there is already nearby support, Min-chance on first year. Doubles each year until maxed out...
		local support_chance = has_support and 0 or (min_chance * (years < 1 and 1 or (2 ^ math.floor(years))))
		
		return math.random() < math.min(support_chance, max_chance)
	end
	
	return test
end

_CanSpawn = CanSpawn

local GetMember
local GetSpawnPoint
local SpawnMember

local OldSpawnHuntingParty
local function SpawnHuntingParty(inst, target, houndsonly, ...)
	if OldSpawnHuntingParty then
		local leader = GetMember(inst, "walrus")
		
		OldSpawnHuntingParty(inst, target, houndsonly, ...)
		if leader then
			return -- Support has only once chance to spawn, party must be cleared before retries...
		end
		
		local support = GetMember(inst, "girl_walrus")
		if not houndsonly and not support and CanSpawn(inst, "girl_walrus") then
			support = SpawnMember(inst, "girl_walrus")
			
			if support then
				local x, y, z = GetSpawnPoint(inst)
				support.Transform:SetPosition(x, y, z)
				
				leader = GetMember(inst, "walrus")
				if leader and support.components.follower then
					support.components.follower:SetLeader(leader)
				end
				
				if target and support.components.combat then
					support.components.combat:SuggestTarget(target)
				end
			end
		end
	end
end

local OldCheckSpawnHuntingParty
local function CheckSpawnHuntingParty(inst, target, houndsonly, ...)
	if not IsInPolar(inst) then
		return OldCheckSpawnHuntingParty(inst, target, houndsonly, ...)
	end
	
	SpawnHuntingParty(inst, target, houndsonly, ...)
end

local function PolarInit(inst)
	if IsInPolar(inst) then
		SetOccupied(inst, true)
	end
	
	if TheWorld.event_listeners.megaflare_detonated and TheWorld.event_listeners.megaflare_detonated[inst] then
		local OnMegaFlare = TheWorld.event_listeners.megaflare_detonated[inst][1]
		
		--	TP only the MacTusk & Friends from the current region !!
		TheWorld.event_listeners.megaflare_detonated[inst][1] = function(src, data, ...)
			local flare_inpolar = (data and data.sourcept) and IsInPolarAtPoint(data.sourcept.x, data.sourcept.y, data.sourcept.z)
			
			if ((not IsInPolar(inst) and not flare_inpolar) or IsInPolar(inst) and flare_inpolar) and OnMegaFlare then
				OnMegaFlare(src, data, ...)
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
	
	if inst.components.worldsettingstimer then
		inst.components.worldsettingstimer:AddTimer("girl_walrus", TUNING.WALRUS_REGEN_PERIOD, TUNING.WALRUS_REGEN_ENABLED) -- TODO: Custom worldsetting ?
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
			
			OldCanSpawn = PolarUpvalue(OldSpawnHuntingParty, "CanSpawn")
			GetMember = PolarUpvalue(OldSpawnHuntingParty, "GetMember")
			GetSpawnPoint = PolarUpvalue(OldSpawnHuntingParty, "GetSpawnPoint")
			SpawnMember = PolarUpvalue(OldSpawnHuntingParty, "SpawnMember")
			
			PolarUpvalue(OldSpawnHuntingParty, "CanSpawn", CanSpawn)
			PolarUpvalue(OldCheckSpawnHuntingParty, "SpawnHuntingParty", SpawnHuntingParty)
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