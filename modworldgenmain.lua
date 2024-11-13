local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	Import

local modimport = ENV.modimport

modimport("init/init_tiles")
require("map/polar_terrain")

--	Setpieces

local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

local polar_layouts = {
	"IcicleSkeleton", "PolarCave_Pillar", "PolarCave_SmallPillar", "PolarFlea_Farm", "PolarTuskTown",
}

for _, layout in ipairs(polar_layouts) do
	Layouts[layout] = StaticLayout.Get("map/static_layouts/"..string.lower(layout))
	Layouts[layout].ground_types = POLAR_GROUND_TYPES
end

--	Tags, Keys

require("map/lockandkey")

local POLAR_KEYS = {
	ISLAND_TIERPOLAR = {"ISLAND_TIERPOLAR"},
}

for key, v in pairs(POLAR_KEYS) do
	table.insert(KEYS_ARRAY, key)
	table.insert(LOCKS_ARRAY, key)
	
	local i = #KEYS_ARRAY
	local locks = {}
	
	KEYS[key] = i
	LOCKS[key] = i
	
	for _, lock in ipairs(v) do
		table.insert(locks, KEYS[lock])
	end
	
	LOCKS_KEYS[LOCKS[key]] = locks
end

ENV.AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
	if self.map_tags then
		self.map_tags.TagData["PolarFleas"] = true
		
		self.map_tags.Tag["polararea"] = function(tagdata) return "TAG", "polararea" end
		
		self.map_tags.Tag["PolarFleas"] = function(tagdata) if tagdata["PolarFleas"] == false then return end
			tagdata["PolarFleas"] = false
			
			return "STATIC", "PolarFlea_Farm" -- TODO: more random results
		end
	end
end)

--	Island Gen

modimport("init/init_worldgen")