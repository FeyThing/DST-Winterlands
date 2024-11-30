local MIN_RATE = 0.75
local MAX_RATE = 2

local function GetMistRate(self, inst)
	local rate = self.rate or 0.44
	
	self.maxmist = 2
	
	return rate * GetRandomMinMax(MIN_RATE, MAX_RATE)
end

local PolarMistEmitter = Class(function(self, inst)
	self.inst = inst
end)

local LIGHT_TAGS = {"lightsource"}
local LIGHT_NOT_TAGS = {"spawnlight"}

local MIST_TAGS = {"polarmist"}
local MIST_NOT_TAGS = {"spoiled"}

function PolarMistEmitter:GetMistOffset()
	if self.inst:IsInLimbo() or TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(self.inst) then
		return nil, false
	end
	
	local pt = self.inst:GetPosition()
	local radius = FunctionOrValue(self.radius, self.inst, self.radius) or 1 * math.random()
	
	local fan_offset = FindValidPositionByFan(math.random() * TWOPI, radius, 12, function(offset)
		local x = pt.x + offset.x
		local z = pt.z + offset.z
		local lights = TheSim:FindEntities(x, pt.y, z, TUNING.DAYLIGHT_SEARCH_RANGE, LIGHT_TAGS, LIGHT_NOT_TAGS)
		local mists = TheSim:FindEntities(x, pt.y, z, self.maxmist_range or 1.5, MIST_TAGS, MIST_NOT_TAGS)
		
		for i, v in ipairs(lights) do
			local lightrad = v.Light and v.Light:GetCalculatedRadius() * 0.75
			if v ~= self.inst and v:GetDistanceSqToPoint(x, pt.y, z) < lightrad * lightrad then
				return
			end
		end
		
		return TheWorld.Map:IsPassableAtPoint(x, pt.y, z, true) and #mists <= self.maxmist
	end)
	
	if fan_offset then
		return pt + fan_offset, true
	end
	
	return pt, false
end

function PolarMistEmitter:DoMist()
	local pt, valid_pos = self:GetMistOffset()
	
	if valid_pos then
		local mist = SpawnPrefab("polar_mist")
		local scale = FunctionOrValue(self.scale, self.inst, self.scale)
		
		mist.Transform:SetPosition(pt.x, pt.y, pt.z)
		mist:SetEmitter(self.inst, scale, self.speed)
	end
	
	if math.random() < 0.2 then
		self:StartMisting()
	end
end

function PolarMistEmitter:StartMisting()
	self:StopMisting()
	
	local rate = GetMistRate(self, self.inst)
	self.mist_task = self.inst:DoPeriodicTask(rate, function() self:DoMist() end)
end

function PolarMistEmitter:StopMisting()
	if self.mist_task then
		self.mist_task:Cancel()
		self.mist_task = nil
	end
end

return PolarMistEmitter