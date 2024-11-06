return Class(function(self, inst)
	assert(TheWorld.ismastersim, "Polar Penguin spawner should not exist on client")
	self.inst = inst
	
	local BORDER_SCALE = 0.85
	
	local SHORE_CHECK_ATTEMPTS = 20
	
	local SPAWN_POINT_ATTEMPTS = 20
	
	local _herds = {}
	local _spawntask
	
	local function GetMaxHerds()
		return math.min(3, TUNING.PENGUINS_MAX_COLONIES)
	end
	
	local function IsPenguinBeach(pt)
		return IsInPolarAtPoint(pt.x, 0, pt.z, 0)
	end
	
	local function GetHerdSpawnPos()
		local radius = TheWorld.Map:GetSize() * 2 * BORDER_SCALE
		local attemps = 0
		local pt
		
		while attemps < SPAWN_POINT_ATTEMPTS and pt == nil do
			pt = FindWalkableOffset(Vector3(0, 0, 0), math.random() * TWOPI, radius, SHORE_CHECK_ATTEMPTS, false, true, IsPenguinBeach)
			
			if pt and not FindSwimmableOffset(pt, math.random() * TWOPI, TUNING.POLAR_PENGUIN_SHORE_DIST, SHORE_CHECK_ATTEMPTS) then
				attemps = attemps + 1
				pt = nil
			end
		end
		
		return pt
	end
	
	local function OnHerdRemoved(herd)
		_herds[herd] = nil
		
		inst:RemoveEventCallback("onremove", OnHerdRemoved, herd)
	end
	
	local function OnRegisterHerd(inst, herd)
		_herds[herd] = true
		
		inst:ListenForEvent("onremove", OnHerdRemoved, herd)
	end
	
	local function RespawnHerd(inst)
		local pt = GetHerdSpawnPos()
		
		if pt then
			local herd = SpawnPrefab("polar_penguinherd")
			herd.Transform:SetPosition(pt:Get())
			
			if herd.components.herd and herd.components.herd.membercount == 0 then
				herd:DoClubPenguin()
			end
		end
		
		_spawntask = nil
	end
	
	local function OnDayComplete(inst, delay)
		local num_herds = 0
		delay = delay or GetRandomMinMax(TUNING.POLAR_PENGUIN_HERD_SPAWN_TIMES.min, TUNING.POLAR_PENGUIN_HERD_SPAWN_TIMES.max)
		
		for herd in pairs(_herds) do
			if herd:IsValid() then
				num_herds = num_herds + 1
			end
		end
		
		if TheWorld.has_ocean and num_herds < GetMaxHerds() and _spawntask == nil then
			_spawntask = inst:DoTaskInTime(delay, RespawnHerd)
		end
	end
	
	function self:OnPostInit()
		if TUNING.PENGUINS_MAX_COLONIES > 0 and TheWorld.has_ocean then
			inst:WatchWorldState("cycles", OnDayComplete)
			OnDayComplete(inst, 1)
		end
	end
	
	function self:DebugRespawn()
		RespawnHerd()
	end
	
	inst:ListenForEvent("ms_registerpolarpenguinherd", OnRegisterHerd)
end)