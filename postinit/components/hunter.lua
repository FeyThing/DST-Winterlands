local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("hunter", function(self)
	local OldSpawnHuntedBeast = PolarUpvalue(self.OnDirtInvestigated, "SpawnHuntedBeast")
	local OldGetHuntedBeast = PolarUpvalue(OldSpawnHuntedBeast, "GetHuntedBeast")
	local ALTERNATE_BEASTS = PolarUpvalue(OldGetHuntedBeast, "ALTERNATE_BEASTS")
	
	self._beastsnopolaroverride = {"claywarg", "yots_worm_lantern_spawner"} -- Beasts that are allowed to spawn, bypassing Winterlands ruleset
	
	local function GetHuntedBeast(hunt, spawn_pt, ...)
		local beast = OldGetHuntedBeast(hunt, spawn_pt, ...)
		
		if beast and not self._overridepolar and not table.contains(self._beastsnopolaroverride, beast)
			and spawn_pt and GetClosestPolarTileToPoint(spawn_pt.x, 0, spawn_pt.z, 32) ~= nil then
			
			-- Specter Moose always appear when there's a blizzard
			if TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsPolarStormActive() then
				return "moose_specter"
			end
			
			-- Ice Vargs spawn logic is solved from StartDirt under
			if hunt.monster_track_num then
				return "polarwarg"
			end
			
			-- Mooses always spawn in Summer, other times it can be either with Winter Koalefants...
			local season = POLARRIFY_MOD_SEASONS[TheWorld.state.season] or "autumn"
			
			return (season ~= "summer" and math.random() < TUNING.HUNT_KOALEFANT_POLAR_CHANCE) and "koalefant_winter" or "moose_polar"
		end
		
		return beast
	end
	
	PolarUpvalue(OldSpawnHuntedBeast, "GetHuntedBeast", GetHuntedBeast)
	
	--
	
	local _activehunts = PolarUpvalue(self.OnDirtInvestigated, "_activehunts")
	
	local OldOnDirtInvestigated = self.OnDirtInvestigated
	function self:OnDirtInvestigated(pt, doer, ...)
		local hunt
		for i, v in ipairs(_activehunts or {}) do
			if v.lastdirt then
				local x, y, z = v.lastdirt.Transform:GetWorldPosition()
				if x == pt.x and z == pt.z then
					hunt = v
					break
				end
			end
		end
		
		OldOnDirtInvestigated(self, pt, doer, ...)
		
		local buff = doer and doer:GetDebuff("buff_huntmoar")
		
		if hunt and buff then
			if not hunt.moarhunt_buffed then
				local buff_mode = buff and buff.mode or "normal"
				
				-- Players need to do less tracks if they have the Snoot Platter buff
				hunt.numtrackstospawn = math.max(2, math.floor(hunt.numtrackstospawn * TUNING.MOARHUNT_BUFF_NUMTRACKS_MULT))
				
				-- Outside of the Lunar Rifts exception, surprise chases shouldn't (normally?) happen if using Summer Platter
				if buff_mode == "normal" and hunt.monster_track_num and hunt.monster_track_num > 0 then
					hunt.monster_track_num = nil
				end
				
				-- With Winter Platter, monster tracks always show up, and quicker
				if buff_mode == "monster" then
					hunt.monster_track_num = hunt.trackspawned + 1
				end
				
				hunt.moarhunt_buffed = true
			end
			
			doer:PushEvent("huntmoartracking", {hunt = hunt, pt = pt})
		end
	end
	
	--	Ice Vargs spawn and animal trakcs logic fix. High chances in winter, kinda-low in Spring / Autumn, still guaranteed with Lunar Rifts
	
	local OnCooldownEnd = PolarUpvalue(self.LongUpdate, "OnCooldownEnd")
	local BeginHunt = PolarUpvalue(OnCooldownEnd, "BeginHunt")
	local OnUpdateHunt = PolarUpvalue(BeginHunt, "OnUpdateHunt")
	local OldStartDirt = PolarUpvalue(OnUpdateHunt, "StartDirt")
	
	local function StartDirt(hunt, position, ...)
		OldStartDirt(hunt, position, ...)
		
		if hunt and position and GetClosestPolarTileToPoint(position.x, 0, position.z, 32) ~= nil then
			local season = POLARRIFY_MOD_SEASONS[TheWorld.state.season] or "autumn"
			local surprise_chance = (season == "winter" and TUNING.HUNT_ALTERNATE_POLAR_CHANCE_MAX)
				or (season == "summer" and TUNING.HUNT_ALTERNATE_POLAR_CHANCE_MIN)
				or TUNING.HUNT_ALTERNATE_POLAR_CHANCE
			
			if TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsPolarStormActive() then
				hunt.monster_track_num = nil
			else
				hunt.monster_track_num = (hunt.monster_track_num == 0 and 0)
					or (math.random() < surprise_chance and (hunt.monster_track_num or math.random(math.floor(hunt.numtrackstospawn / 2), hunt.numtrackstospawn - 2)))
					or nil
			end
		end
	end
	
	PolarUpvalue(OnUpdateHunt, "StartDirt", StartDirt)
end)