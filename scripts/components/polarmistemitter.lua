local ACTIVE_MISTS = {}

--[[local LIGHT_TAGS = {"lightsource"}
local LIGHT_NOT_TAGS = {"spawnlight"}

local function IsNearLight(x, y, z)
	local lights = TheSim:FindEntities(x, y, z, TUNING.DAYLIGHT_SEARCH_RANGE, LIGHT_TAGS, LIGHT_NOT_TAGS)
	
	for i, v in ipairs(lights) do
		if v.Light then
			local radius = v.Light:GetCalculatedRadius() * 0.75
			
			if v:GetDistanceSqToPoint(x, y, z) < radius * radius then
				return true
			end
		end
	end
	
	return false
end]]

local function UpdateMist(mist, dt)
	if not mist:IsValid() then
		ACTIVE_MISTS[mist] = nil
		return
	end
	
	local x, y, z = mist.Transform:GetWorldPosition()
	x = x + mist.vx * dt
	z = z + mist.vz * dt
	
	mist.Transform:SetPosition(x, y, z)
	
	--[[mist._light_check_cd = (mist._light_check_cd or 0.5) - dt
	
	if mist._light_check_cd <= 0 then
		mist._light_check_cd = 0.5
		
		if IsNearLight(x, y, z) then
			-- Mist used to evaporates quicker when entering light, but we should keep updates lightweight
		end
	end]]
	
	local age = mist:GetTimeAlive()
	local alpha
	
	if age < mist.fadein_time then
		alpha = age / mist.fadein_time
	elseif age > (mist.lifetime - mist.fadeout_time) then
		alpha = 1 - ((age - (mist.lifetime - mist.fadeout_time)) / mist.fadeout_time)
	else
		alpha = 1
	end
	
	mist.AnimState:SetMultColour(1, 1, 1, math.clamp(alpha, 0, 1) * 0.5)
	
	if alpha <= 0 or mist:GetTimeAlive() >= mist.lifetime then
		ACTIVE_MISTS[mist] = nil
		mist:Remove()
	end
end

local MIST_VARS = 5

local function CreateMist(x, y, z, scale, speed, direction, lifetime, fadein, fadeout)
	local mist = CreateEntity()
	
	mist:AddTag("FX")
	mist:AddTag("polarmist")
	
	mist.entity:SetCanSleep(false)
	mist.persists = false
	
	mist.entity:AddTransform()
	mist.entity:AddAnimState()
	
	mist.Transform:SetPosition(x, y, z)
	mist.Transform:SetRotation(direction * RADIANS)
	
	mist.AnimState:SetBank("polar_mist")
	mist.AnimState:SetBuild("polar_mist")
	mist.AnimState:PlayAnimation("pre")
	mist.AnimState:PushAnimation("loop", true)
	mist.AnimState:OverrideSymbol("mist0", "polar_mist", "mist"..math.random(MIST_VARS) - 1)
	mist.AnimState:SetMultColour(1, 1, 1, 0)
	mist.AnimState:SetLightOverride(0.07)
	mist.AnimState:SetScale(scale, scale)
	mist.AnimState:SetSortOrder(2)
	mist.AnimState:SetForceSinglePass(true)
	
	mist.heading = direction
	mist.speed = speed
	mist.vx = math.cos(direction) * speed
	mist.vz = math.sin(direction) * speed
	
	mist.lifetime = lifetime or TUNING.POLAR_MIST_LIFETIME
	mist.fadein_time = fadein or 6
	mist.fadeout_time = fadeout or 6
	
	mist.UpdateMist = UpdateMist
	
	ACTIVE_MISTS[mist] = true
	
	return mist
end

local function GetFlowDirection(x, z, radius)
	local dir_x, dir_z = 0, 0
	local count = 0
	
	for mist in pairs(ACTIVE_MISTS) do
		if mist:IsValid() then
			local mx, my, mz = mist.Transform:GetWorldPosition()
			local dx, dz = mx - x, mz - z
			local dsq = dx * dx + dz * dz
			
			if dsq < radius * radius then
				dir_x = dir_x - math.cos(mist.heading)
				dir_z = dir_z - math.sin(mist.heading)
				
				count = count + 1
			end
		end
	end
	
	return count > 0 and math.atan2(dir_z, dir_x) + GetRandomMinMax(-0.5, 0.5)
		or math.random() * TWOPI
end

local function StartGlobalUpdater(inst)
	if TheWorld._polarmist_updater then
		return
	end
	
	TheWorld._polarmist_updater = TheWorld:DoPeriodicTask(FRAMES, function(_, dt)
		for mist in pairs(ACTIVE_MISTS) do
			mist:UpdateMist(dt or FRAMES)
		end
	end)
end

local PolarMistEmitter = Class(function(self, inst)
	self.inst = inst
	
	self.enabled = false
	self.ismastersim = TheWorld.ismastersim
	
	local item = inst:HasTag("_inventoryitem")
	
	self.maxdist = 4 -- Scan range, to know if there's too much mist (maxmist) around us already by ourselve & other emitter friends
	self.maxmist = 8
	self.radius = 1.5
	self.rate = 1
	self.scale = item and 1.5 or 2
	self.speed = item and 0.06 or 0.12
	
	self._enabled = net_bool(inst.GUID, "polarmistemitter.enabled", "polarmist_enableddirty")
	
	if not TheNet:IsDedicated() then
		StartGlobalUpdater(inst)
		
		if self._enabled:value() then
			self:Start()
		end
		
		inst:ListenForEvent("polarmist_enableddirty", function() self:OnEnabledDirty() end)
		inst:ListenForEvent("onremove", function()
			if inst:HasTag("dryice_sunk") then
				for i = 1, 12 do
					self:SpawnMist(true)
				end
			end
		end)
	end
end)

function PolarMistEmitter:SetEnabled(enabled)
	if self.ismastersim then
		self._enabled:set(enabled)
	end
end

function PolarMistEmitter:OnEnabledDirty()
	if self._enabled:value() then
		self:Start()
	else
		self:Stop()
	end
end

function PolarMistEmitter:OnEntitySleep()
	self:Stop()
end

function PolarMistEmitter:OnEntityWake()
	if not TheNet:IsDedicated() and self._enabled:value() then
		self:Start()
	end
end

--

function PolarMistEmitter:GetSpawnPosition(forced)
	if not forced and self.inst:IsInLimbo() then
		return
	end
	
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local angle = math.random() * TWOPI
	local radius = math.random() * self.radius
	
	local px = x + (math.cos(angle) * radius)
	local pz = z + (math.sin(angle) * radius)
	
	if forced then
		return px, y, pz
	end
	
	--[[if IsNearLight(px, y, pz) then
		return
	end]]
	
	local nearby = 0
	for mist in pairs(ACTIVE_MISTS) do
		if mist:IsValid() then
			local mx, my, mz = mist.Transform:GetWorldPosition()
			local dx, dz = mx - px, mz - pz
			
			if dx * dx + dz * dz < self.maxdist * self.maxdist then
				nearby = nearby + 1
			end
		end
	end
	
	if nearby >= self.maxmist then
		return
	end
	
	return px, y, pz
end

function PolarMistEmitter:SpawnMist(forced)
	local x, y, z = self:GetSpawnPosition(forced)
	
	if x == nil then
		return
	end
	
	local direction = GetFlowDirection(x, z, 5)
	local scale = FunctionOrValue(self.scale, self.inst, self.scale) or 1
	local speed = FunctionOrValue(self.speed, self.inst, self.speed) or 0.1
	
	return CreateMist(x, y, z, scale, speed, direction, self.lifetime, self.fadein, self.fadeout)
end

function PolarMistEmitter:GetNextSpawnDelay()
	local rate = FunctionOrValue(self.rate, self.inst) or 1
	
	return rate * GetRandomMinMax(0.75, 1.25)
end

function PolarMistEmitter:ScheduleNext()
	local delay = self:GetNextSpawnDelay()
	
	self.task = self.inst:DoTaskInTime(delay, function()
		self:SpawnMist()
		
		if self.enabled then
			self:ScheduleNext()
		end
	end)
end

function PolarMistEmitter:Start()
	if self.inst:IsAsleep() or self.inst:IsInLimbo() then
		self:Stop()
		return
	elseif self.enabled then
		return
	end
	
	self.enabled = true
	self:ScheduleNext()
end

function PolarMistEmitter:Stop()
	self.enabled = false
	
	if self.task then
		self.task:Cancel()
		self.task = nil
	end
end

return PolarMistEmitter