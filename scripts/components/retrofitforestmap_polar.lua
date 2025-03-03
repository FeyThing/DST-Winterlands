return Class(function(self, inst)
	assert(TheWorld.ismastersim, "RetrofitForestMap_Polar should not exist on client")
	
	self.inst = inst
	
	--	Island
	
	local MAX_PLACEMENT_ATTEMPTS = 99

	local function RetrofitPolarIsland()
		local node_indices = {}
		for k, v in ipairs(TheWorld.topology.ids) do
			if string.find(v, "Polar Lands") then
				table.insert(node_indices, k)
			end
		end
		if #node_indices == 0 then
			return false
		end
		
		local tags = {"RoadPoison", "polararea", "not_mainland"}
		for k, v in ipairs(node_indices) do
			if TheWorld.topology.nodes[v].tags == nil then
				TheWorld.topology.nodes[v].tags = {}
			end
			for i, tag in ipairs(tags) do
				if not table.contains(TheWorld.topology.nodes[v].tags, tag) then
					table.insert(TheWorld.topology.nodes[v].tags, tag)
				end
			end
		end
		for i, node in ipairs(TheWorld.topology.nodes) do
			if table.contains(node.tags, "polararea") then
				TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
			end
		end
		
		return true
	end
	
	--	Throne
	
	local function PolarThrone_Retrofitting()
		local candidtate_nodes = {}
		
		for i, v in ipairs(TheWorld.topology.ids) do
			if string.find(v, "Polar Lands") then
				table.insert(candidtate_nodes, TheWorld.topology.nodes[i])
			end
		end
		
		if #candidtate_nodes > 0 then
			local attempt = 0
			while attempt <= MAX_PLACEMENT_ATTEMPTS do
				local area = candidtate_nodes[math.random(#candidtate_nodes)]
				local points_x, points_y = TheWorld.Map:GetRandomPointsForSite(area.x, area.y, area.poly, 1)
				
				if #points_x == 1 and #points_y == 1 then
					local x = points_x[1]
					local z = points_y[1]
					
					if TheWorld.Map:CanPlacePrefabFilteredAtPoint(x, 0, z, "polar_throne") then
						local ents = TheSim:FindEntities(x, 0, z, 7)
						if #ents == 0 then
							local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, 0, z)
							
							for dx = -1, 1 do
								for dy = -1, 1 do
									TheWorld.Map:SetTile(tx + dx, ty + dy, WORLD_TILES.POLAR_SNOW)
								end
							end
							local throne = SpawnPrefab("polar_throne")
							throne.Transform:SetPosition(x, 0, z)
							
							break
						end
					end
				end
				attempt = attempt + 1
			end
			print("Retrofitting for The Winterlands - "..(attempt <= MAX_PLACEMENT_ATTEMPTS and ("Found space for Naughty Throne!") or "Failed to find space for Naughty Throne!"))
		else
			print("Retrofitting for The Winterlands - Failed to find island for Naughty Throne!")
			return false
		end
	end
	
	--	Initialize Retrofit
	
	function self:OnPostInit()
		local isforest = Polar_CompatibleShard(TheWorld.worldprefab)
		local iscave = TheWorld.worldprefab == "cave"
		
		if isforest then
			if TUNING.POLAR_RETROFIT == 1 then -- Retrofit full island
				local success = RetrofitPolarIsland()
				
				if success then
					TheWorld.Map:RetrofitNavGrid()
					ChangePolarConfigs("biome_retrofit", 0)
					
					self.requiresreset = true
				end
			elseif TheSim:FindFirstEntityWithTag("polarthrone") == nil then -- Introduce Throne, auto added if missing
				PolarThrone_Retrofitting()
			end
		end
		
		if self.requiresreset and not (TheWorld.components.retrofitforestmap_anr and TheWorld.components.retrofitforestmap_anr.requiresreset) and
			not (TheWorld.components.retrofitcavemap_anr and TheWorld.components.retrofitcavemap_anr.requiresreset) then
			
			print("Retrofitting for The Winterlands - Worldgen retrofitting requires the server to save and restart to fully take effect.")
			print("Restarting server in 30 seconds...")
			
			inst:DoTaskInTime(5,  function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 25})) end)
			inst:DoTaskInTime(10, function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 20})) end)
			inst:DoTaskInTime(15, function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 15})) end)
			inst:DoTaskInTime(20, function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 10})) end)
			inst:DoTaskInTime(22, function() TheWorld:PushEvent("ms_save") end)
			inst:DoTaskInTime(25, function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 5})) end)
			inst:DoTaskInTime(29, function() TheNet:Announce(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT_NOW) end)
			inst:DoTaskInTime(30, function() TheNet:SendWorldRollbackRequestToServer(0) end)
		end
	end
	
	function self:OnSave()
		return {}
	end
	
	function self:OnLoad(data)
		
	end
end)