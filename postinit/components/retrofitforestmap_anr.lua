local ENV = env
GLOBAL.setfenv(1, GLOBAL)

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

ENV.AddComponentPostInit("retrofitforestmap_anr", function(self)
	local OldOnPostInit = self.OnPostInit
	function self:OnPostInit(...)
		if TUNING.POLAR_RETROFIT == 1 then -- Retrofit full island
			local success = RetrofitPolarIsland()
			
			if success then
				TheWorld.Map:RetrofitNavGrid()
				ChangePolarConfigs("biome_retrofit", 0)
				self.requiresreset = true
			end
		end
		
		return OldOnPostInit(self, ...)
	end
end)