local PolarFleaMotherSpawner = Class(function(self, inst)
	self.inst = inst
	
	self.fleakill_inc = TUNING.POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL
	self.fleakill_decay = TUNING.POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY
	
	self.findgrass_dist = 12
	self.findgrass_min = 6
	
	self.spawnchance = TUNING.POLARFLEA_MOTHER_SPAWN_CHANCE
	self.spawnchance_min = TUNING.POLARFLEA_MOTHER_SPAWN_CHANCE_MIN -- Gonna want AT LEAST some violance first
	
	self.inst:ListenForEvent("megaflare_detonated", function(src, data)
		self:OnMegaFlare(data)
	end)
	self.inst:ListenForEvent("motherflea_triggered", function(src, data)
		self:OnEntityKilled(data)
	end)
	self.inst:WatchWorldState("cycles", function() self:OnNewDay() end)
end)

local GRASS_TAGS = {"fleahosted", "plant"}
local SPAWN_OFFSET = 2
local SPAWN_OFFSET_ATTEMPTS = 12

local YOUR_MOM_TAGS = {"epic", "flea"}

function PolarFleaMotherSpawner:ShouldTrigger(pt, data) -- Tests both fleakill spawn increment and spawn validity
	if not GetClosestPolarTileToPoint(pt.x, 0, pt.z, 32) then
		return false
	end
	
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, self.findgrass_dist, GRASS_TAGS)
	local your_mother = FindEntity(inst, 20, nil, YOUR_MOM_TAGS)
	local spawn_pos
	
	if #ents >= self.findgrass_min and your_mother == nil then
		local sx, sy, sz = 0, 0, 0
		
		for i, v in ipairs(ents) do
			local ex, ey, ez = v.Transform:GetWorldPosition()
			sx = sx + ex
			sy = sy + ey
			sz = sz + ez
		end
		
		local x, y, z = sx / #ents, sy / #ents, sz / #ents
		spawn_pos = Vector3(x, y, z)
		
		for i = 1, SPAWN_OFFSET_ATTEMPTS do
			local angle = math.random() * TWOPI
			local dist = math.random() * SPAWN_OFFSET
			local ox = x + math.cos(angle) * dist
			local oz = z + math.sin(angle) * dist
			
			if TheWorld.Map:IsPassableAtPoint(ox, y, oz) and TheWorld.Map:IsAboveGroundAtPoint(ox, y, oz) then
				spawn_pos = Vector3(ox, y, oz)
				break
			end
		end
	end
	
	return true, spawn_pos
end

function PolarFleaMotherSpawner:OnMegaFlare(data)
	if data and data.sourcept then
		local triggered, trigger_pos = self:ShouldTrigger(data.sourcept, data)
		
		if trigger_pos then
			self.inst:DoTaskInTime(1 + math.random() * 3, function()
				self:TrySpawn(trigger_pos, true)
			end)
		end
	end
end

function PolarFleaMotherSpawner:OnEntityKilled(data)
	if not data or not data.victim or not data.victim.Transform or data.victim.babyflea or data.victim:HasTag("INLIMBO") then
		return
	end
	
	local pos = data.victim:GetPosition()
	local triggered, trigger_pos = self:ShouldTrigger(pos, data)
	
	if triggered then
		self.spawnchance = math.min(self.spawnchance + self.fleakill_inc, 1)
	end
	if trigger_pos then
		self:TrySpawn(trigger_pos)
	end
end

function PolarFleaMotherSpawner:TrySpawn(pt, force_spawn)
	if not force_spawn and (pt == nil or self.spawnchance <= self.spawnchance_min) then
		return
	end
	
	if force_spawn or math.random() < self.spawnchance then
		local mom = SpawnPrefab("polarflea_mother")
		mom.Transform:SetPosition(pt.x, pt.y, pt.z)
		
		if mom.sg then
			mom.sg:GoToState("emerge")
		end
		
		self.spawnchance = TUNING.POLARFLEA_MOTHER_SPAWN_CHANCE
		-- TODO: Add minimum cooldown. Also fleas spawned from mother shouldn't increase count
	end
end

function PolarFleaMotherSpawner:OnNewDay()
	self.spawnchance = math.max(self.spawnchance * (1 - self.fleakill_decay), 0)
end

function PolarFleaMotherSpawner:OnSave()
	return {
		spawnchance = self.spawnchance,
	}
end

function PolarFleaMotherSpawner:OnLoad(data)
	self.spawnchance = data.spawnchance or 0
end

return PolarFleaMotherSpawner