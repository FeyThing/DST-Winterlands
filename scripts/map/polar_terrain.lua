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
	pillar_polar = OnlyAllow({WORLD_TILES.POLAR_CAVES, WORLD_TILES.POLAR_SNOW}),
	polarbearhouse = OnlyAllow({WORLD_TILES.POLAR_DRYICE, WORLD_TILES.POLAR_ROCKY, WORLD_TILES.POLAR_SNOW}),
}

local polar_addedtiles = {
	evergreen = {WORLD_TILES.POLAR_ICE},
	evergreen_normal = {WORLD_TILES.POLAR_ICE},
	evergreen_short = {WORLD_TILES.POLAR_ICE},
	evergreen_tall = {WORLD_TILES.POLAR_ICE},
	evergreen_sparse = {WORLD_TILES.POLAR_ICE},
	evergreen_sparse_normal = {WORLD_TILES.POLAR_ICE},
	evergreen_sparse_short = {WORLD_TILES.POLAR_ICE},
	evergreen_sparse_tall = {WORLD_TILES.POLAR_ICE},
	grass = {WORLD_TILES.POLAR_ICE},
	marsh_tree = {WORLD_TILES.POLAR_ICE},
	marsh_bush = {WORLD_TILES.POLAR_ICE},
	rock1 = {WORLD_TILES.POLAR_ICE},
	rock2 = {WORLD_TILES.POLAR_ICE},
	rock_flintless = {WORLD_TILES.POLAR_ICE},
	rock_ice = {WORLD_TILES.POLAR_SNOW},
}

for terrain, tiles in pairs(polar_filters) do
	filters[terrain] = tiles
end

for terrain, tiles in pairs(polar_addedtiles) do
	for _, tile in ipairs(tiles) do
		table.insert(filters[terrain], tile)
	end
end