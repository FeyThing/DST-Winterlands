local ENV = env
local _GLOBAL = GLOBAL
_GLOBAL.modname = modname -- To fix the crashing issue for people using EnableModError() in their modsettings.lua
GLOBAL.setfenv(1, _GLOBAL)

--	Import

local modimport = ENV.modimport

modimport("init/init_tuning")
modimport("init/init_tiles")

require("map/polar_terrain")
require("polar_strings/strings")

local translation = ENV.GetModConfigData("language")

if translation then
	require("polar_strings/"..translation.."/strings")
end

--	Setpieces

local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")

local polar_layouts = {
	["BearTown1"] = 			{},
	["BearTown2"] = 			{},
	["BearTown3"] = 			{},
	["BearTown4"] = 			{
		defs = {
			tree = {"evergreen", "evergreen_sparse"},
		},
	},
	["BearTown5"] = 			{
		defs = {
			tree = {"evergreen", "evergreen_sparse"},
		},
	},
	
	["BearOnIce"] = 			{},
	["PolarTuskTown"] = 		{},
	["PolarAmulet_Shack"] = 	{},
	["PolarThrone"] = 			{},
	
	["Polar_Lake"] = 			{
		defs = {
			fishingitem = {"ocean_trawler_kit", "oceanfishingrod"},
			fishingrecipe = {"oceanfishingbobber_ball_tacklesketch", "oceanfishingbobber_robin_winter_tacklesketch", "oceanfishinglure_hermit_snow_tacklesketch"},
		},
	},
	["PolarFox_Duo"] = 			{},
	["PolarFox_Solo"] = 		{},
	["PolarFlea_Farm"] = 		{},
	["PolarFlea_House"] = 		{},
	["polarflea_grass"] = 		{},
	
	["BlueGem_Shards"] = 		{},
	["BlueGem_Shards_Ice"] = 	{},
	["PolarCave_Pillar"] = 		{},
	["PolarCave_SmallPillar"] = {},
	["PolarStaff_Rink"] = 		{
		defs = {
			polarstaff = {"iciclestaff", "polaricestaff"},
		},
	},
	
	["PolarSnowman"] = 			{},
	["skeleton_icicle"] = 		{},
	["skeleton_polar"] = 		{},
	
	["PolarStart"] = 			{
		name = "polar_start",
		layout_position = LAYOUT_POSITION.CENTER,
		defs = {
			welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"marsh_bush"},
		},
	},
}

for k, v in pairs(polar_layouts) do
	Layouts[k] = StaticLayout.Get("map/static_layouts/"..(v.name or string.lower(k)), {
		layout_position = v.layout_position,
		defs = v.defs,
	})
	Layouts[k].ground_types = POLAR_GROUND_TYPES
end

--	Retrofit

local retrofit_islands = {"retrofit_polarisland"}

for i, layout in ipairs(retrofit_islands) do
	Layouts[layout] = StaticLayout.Get("map/static_layouts/"..layout, {
		start_mask = PLACE_MASK.IGNORE_IMPASSABLE,
		fill_mask = PLACE_MASK.IGNORE_IMPASSABLE,
		add_topology = {room_id = "StaticLayoutIsland:Polar Lands", tags = {"RoadPoison", "polararea", "not_mainland"}},
		min_dist_from_land = 0,
	})
	Layouts[layout].ground_types = POLAR_GROUND_TYPES
	
	if WORLD_TILES.OCEAN_SHALLOW then -- SW requires different water tiles in retrofit
		Layouts[layout.."_sw"] = Layouts[layout]
		Layouts[layout.."_sw"].ground_types = POLAR_GROUND_TYPES_SW
	end
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
		self.map_tags.TagData["PolarBearTown"] = true
		self.map_tags.TagData["PolarFleas"] = true
		
		--
		
		self.map_tags.Tag["polararea"] = function(tagdata)
			return "TAG", "polararea"
		end
		
		self.map_tags.Tag["PolarBearTown"] = function(tagdata)
			if tagdata["PolarBearTown"] == false then
				return
			end
			tagdata["PolarBearTown"] = false
			
			-- 1: Merm BBQ
			-- 2: Fishing Docks
			-- 3: Praise-o-Meter
			-- 4: Grassy Walkway
			-- 5: Isolated Village
			return "STATIC", "BearTown"..math.random(5)
		end
		
		self.map_tags.Tag["PolarFleas"] = function(tagdata)
			if tagdata["PolarFleas"] == false then
				return
			end
			local setpiece = tagdata["PolarFleas"] == "extra_setpiece" and (math.random() < 0.5 and "polarflea_grass" or "PolarFlea_House") or "PolarFlea_Farm"
			tagdata["PolarFleas"] = (setpiece == "PolarFlea_Farm" and math.random() < 0.33) and "extra_setpiece" or false
			
			return "STATIC", setpiece
		end
	end
end)

--	Island Gen

WINTERLANDS_TYPE = ENV.GetModConfigData("biome_type") or "island"

function Polar_CompatibleShard(location)
	location = location or "forest"
	
	if location == TUNING.POLAR_SHARD then
		return true
	elseif TUNING.POLAR_SHARD == "all" and (location == "forest" or location == "shipwrecked") then
		return true
	end
	
	return false
end

modimport("init/init_worldgen")