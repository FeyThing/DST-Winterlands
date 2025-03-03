local FISH_DATA = require("prefabs/oceanfishdef")


return Class(function(self, inst)
	assert(TheWorld.ismastersim, "OceanFish_In_Ice_Spawner should not exist on client")
	self.inst = inst
	
	self.fishies_in_ice = {}
	self.num_in_ice = 0
	
	self.max_in_ice = 3
	self.spawn_chance = TUNING.OCEANFISH_IN_ICE_SPAWN_CHANCE
	
	--
	
	self.onicecubepickedup = function(icecube, owner)
		self.fishies_in_ice[icecube] = nil
		self.num_in_ice = self.num_in_ice - 1
		
		icecube.persists = true
		
		self.inst:RemoveEventCallback("onputininventory", self.onicecubepickedup, icecube)
		self.inst:RemoveEventCallback("entitysleep", self.onicecubesleep, icecube)
	end
	
	self.onicecubesleep = function(icecube)
		self.fishies_in_ice[icecube] = nil
		self.num_in_ice = self.num_in_ice - 1
		
		self.inst:RemoveEventCallback("onputininventory", self.onicecubepickedup, icecube)
		self.inst:RemoveEventCallback("entitysleep", self.onicecubesleep, icecube)
		
		icecube:Remove() -- TODO: Maybe only after a minute.
	end
	
	--	All fishies should be possible, so we use a random depth but only allow fish of the current season.
	
	function self:GetRandomFish()
		local season_data = FISH_DATA.school[TheWorld.state.season]
		
		if season_data then
			local depths = GetTableSize(season_data)
			local chosen_depth = math.random(depths)
			
			local i = 1
			for k, depth_data in pairs(season_data) do
				if i == chosen_depth then
					local fish_name = weighted_random_choice(depth_data)
					local fish_data = fish_name and FISH_DATA.fish[fish_name]
					
					return fish_data and fish_data.prefab
				end
				
				i = i + 1
			end
		end
	end
	
	function self:CanSpawnIceCube(x, y, z)
		if z == nil or FindClosestPlayerInRange(x, y, z, 15) == nil then
			return false
		end
		
		return math.random() <= self.spawn_chance and self.num_in_ice < self.max_in_ice
	end
	
	function self:SpawnIceCubeAt(x, y, z, fish_data)
		fish_data = fish_data or {}
		
		if fish_data.name == nil then
			fish_data.name = self:GetRandomFish()
		end
		
		if fish_data.name then
			local icecube = SpawnPrefab("oceanfish_in_ice")
			icecube:SetTrappedFish(fish_data.name)
			icecube.persists = false
			
			icecube.Transform:SetPosition(x, y, z)
			
			self.inst:ListenForEvent("onputininventory", self.onicecubepickedup, icecube)
			self.inst:ListenForEvent("entitysleep", self.onicecubesleep, icecube)
			
			self.fishies_in_ice[icecube] = fish_data.name
			self.num_in_ice = self.num_in_ice + 1
			
			return icecube
		end
	end
end)