local filters = terrain.filter

local function OnlyAllow(approved)
	local filter = {}
	
	for k, v in pairs(GetWorldTileMap()) do
		if not table.contains(approved, v) then
			table.insert(filter, v)
		end
	end
	
	return filter
end

local polar_filters = {
	antler_tree = OnlyAllow({WORLD_TILES.POLAR_SNOW}),
	antler_tree_burnt = OnlyAllow({WORLD_TILES.POLAR_SNOW}),
	antler_tree_stump = OnlyAllow({WORLD_TILES.POLAR_SNOW}),
	grass_polar = OnlyAllow({WORLD_TILES.POLAR_SNOW}),
	pillar_polar = OnlyAllow({WORLD_TILES.POLAR_CAVES, WORLD_TILES.POLAR_SNOW}),
	polar_icicle_rock = OnlyAllow({WORLD_TILES.POLAR_CAVES}),
	polarbearhouse = {WORLD_TILES.POLAR_ICE},
	rock_polar = OnlyAllow({WORLD_TILES.POLAR_CAVES}),
	snowwave_itemrespawner = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH, WORLD_TILES.ROCKY},
}

local polar_addedtiles = {
	evergreen = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	evergreen_normal = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	evergreen_short = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	evergreen_tall = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	evergreen_sparse = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	evergreen_sparse_normal = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	evergreen_sparse_short = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	evergreen_sparse_tall = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	evergreen_stump = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	grass = {WORLD_TILES.POLAR_ICE},
	sapling = {WORLD_TILES.POLAR_ICE},
	leif_sparse = {WORLD_TILES.POLAR_ICE},
	marsh_tree = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES},
	marsh_bush = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	twiggytree = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES, WORLD_TILES.PEBBLEBEACH},
	flint = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_SNOW},
	pond = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_CAVES},
	rocks = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_SNOW},
	rock1 = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_SNOW},
	rock2 = {WORLD_TILES.POLAR_ICE, WORLD_TILES.POLAR_SNOW},
	rock_flintless = {WORLD_TILES.POLAR_ICE},
	rock_ice = {WORLD_TILES.POLAR_ICE},
	skeleton_notplayer_1 = {WORLD_TILES.POLAR_ICE, WORLD_TILES.PEBBLEBEACH},
	skeleton_notplayer_2 = {WORLD_TILES.POLAR_ICE, WORLD_TILES.PEBBLEBEACH},
}

for terrain, tiles in pairs(polar_filters) do
	filters[terrain] = tiles
end

for terrain, tiles in pairs(polar_addedtiles) do
	if filters[terrain] == nil then
		filters[terrain] = {}
	end
	
	for _, tile in ipairs(tiles) do
		table.insert(filters[terrain], tile)
	end
end