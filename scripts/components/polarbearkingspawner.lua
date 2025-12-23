local BEAR_HOUSE_TAGS = {"bearhouse"}
local BEAR_HOUSE_NOT_TAGS = {"INLIMBO", "fire", "burnt"}

local CLEAR_TAGS = {"plant", "rock", "structure"}
local CLEAR_NOT_TAGS = {"antlion_sinkhole_blocker", "INLIMBO", "irreplaceable"}

local PolarBearKingSpawner = Class(function(self, inst)
	assert(TheWorld.ismastersim, "Polar Bear King Spawner should not exist on client")
	
	self.inst = inst
	
	self.king_decor = {
		polar_brazier = 2,
		mermhead = 1,
		polarwalrushead = HasPassedCalendarDay(23) and 1 or 0,
	}
end)

local function SqDist(x1, z1, x2, z2)
	local dx = x1 - x2
	local dz = z1 - z2
	
	return dx * dx + dz * dz
end

local function CheckDensity(ent, others)
	local x, y, z = ent.Transform:GetWorldPosition()
	local total_dist = 0
	local count = 0
	
	for i, v in ipairs(others) do
		if v ~= ent and v:IsValid() then
			local ox, oy, oz = v.Transform:GetWorldPosition()
			
			total_dist = total_dist + SqDist(x, z, ox, oz)
			count = count + 1
		end
	end
	
	if count == 0 then
		return math.huge
	end
	
	return total_dist / count
end

function PolarBearKingSpawner:GetKingPlace()
	local ents = TheSim:FindEntities(0, 0, 0, 999, BEAR_HOUSE_TAGS, BEAR_HOUSE_NOT_TAGS)
	
	if #ents < 2 then
		return nil
	end
	
	local the_place_to_be = nil
	local best_density = math.huge
	
	for i, v in ipairs(ents) do
		if v:IsValid() then
			local density = CheckDensity(v, ents)
			
			if density < best_density then
				best_density = density
				the_place_to_be = v:GetPosition()
			end
		end
	end
	
	return the_place_to_be
end

function PolarBearKingSpawner:TryPlaceKing()
	if TheSim:FindFirstEntityWithTag("bear_major") then
		return
	end
	
	local pt = self:GetKingPlace()
	
	if pt then
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 2, nil, CLEAR_NOT_TAGS, CLEAR_TAGS)
		for i, v in ipairs(ents) do
			v:Remove()
		end
		
		local king = SpawnPrefab("polarbearking")
		king.Transform:SetPosition(pt:Get())
		
		local DECOR_OFFSETS = {
			{4 + math.random(), 0, 4 + math.random()},
			{-4 - math.random(), 0, 4 + math.random()},
			{4 + math.random(), 0, -4 - math.random()},
			{-4 - math.random(), 0, -4 - math.random()},
		}
		
		for i = 1, 4 do
			local offset = DECOR_OFFSETS[i]
			local _pt = Vector3(pt.x + offset[1], pt.y + offset[2], pt.z + offset[3])
			
			if TheWorld.Map:IsPassableAtPoint(_pt:Get()) and TheWorld.Map:IsDeployPointClear(_pt, nil, 1.5) then
				local ent = SpawnPrefab(weighted_random_choice(self.king_decor))
				ent.Transform:SetPosition(pt.x + offset[1], pt.y + offset[2], pt.z + offset[3])
			end
		end
	end
end

function PolarBearKingSpawner:OnPostInit()
	self.inst:DoTaskInTime(1, function()
		self:TryPlaceKing()
	end)
end

return PolarBearKingSpawner