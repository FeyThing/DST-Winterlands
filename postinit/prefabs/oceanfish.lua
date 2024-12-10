local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local FISH_DATA = require("prefabs/oceanfishdef")

local DIET = {OMNI = {caneat = {FOODGROUP.OMNI}}}

local SET_HOOK_TIME_SHORT = {base = 1, var = 0.5}
local SET_HOOK_TIME_MEDIUM = {base = 2, var = 0.5}

local BREACH_FX_SMALL = {"ocean_splash_small1", "ocean_splash_small2"}
local BREACH_FX_MEDIUM = {"ocean_splash_med1", "ocean_splash_med2"}

local SHADOW_SMALL = {1, 0.75}
local SHADOW_MEDIUM = {1.5, 0.75}

FISH_DATA.fish["oceanfish_medium_polar1"] = {
	prefab = "oceanfish_medium_polar1",
	bank = "oceanfish_medium",
	build = "oceanfish_medium_polar1",
	weight_min = 172.41,
	weight_max = 228.88,
	walkspeed = 2.5,
	runspeed = 2.5,
	stamina = {
		drain_rate = 		0.25,
		recover_rate = 		0.05,
		struggle_times = 	{low = 2, r_low = 0, high = 2, r_high = 1},
		tired_times = 		{low = 4, r_low = 1, high = 2, r_high = 1},
		tiredout_angles = 	{has_tention = 15, low_tention = 15},
	},
	schoolmin = 2,
	schoolmax = 5,
	schoolrange = 3,
	schoollifetimemin = 480,
	schoollifetimemax = 960,
	herdwandermin = 30,
	herdwandermax = 60,
	herdarrivedist = 8,
	herdwanderdelaymin = 30,
	herdwanderdelaymax = 60,
	set_hook_time = SET_HOOK_TIME_MEDIUM,
	breach_fx = BREACH_FX_MEDIUM,
	perish_product = "fishmeat_small",
	fishtype = "meat",
	lures = TUNING.OCEANFISH_LURE_PREFERENCE.MEAT,
	diet = DIET.MEAT,
	cooker_ingredient_value = {meat = 1, fish = 1, frozen = 1},
	edible_values = {health = TUNING.HEALING_MEDSMALL, hunger = TUNING.CALORIES_MED, sanity = 0, foodtype = FOODTYPE.MEAT},
	dynamic_shadow = SHADOW_MEDIUM,
}

--

FISH_DATA.school[SEASONS.AUTUMN][WORLD_TILES.OCEAN_POLAR] = {
	oceanfish_small_2 = 1,
	oceanfish_medium_polar1 = 4,
}

FISH_DATA.school[SEASONS.WINTER][WORLD_TILES.OCEAN_POLAR] = {
	oceanfish_medium_polar1 = 4,
}

FISH_DATA.school[SEASONS.SPRING][WORLD_TILES.OCEAN_POLAR] = {
	oceanfish_medium_polar1 = 4,
}

FISH_DATA.school[SEASONS.SUMMER][WORLD_TILES.OCEAN_POLAR] = {
	oceanfish_small_2 = 1,
	oceanfish_medium_polar1 = 4,
}

--

ENV.AddPrefabPostInit("oceanfish_medium_polar1_inv", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.tradable then
		inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.RAREMEAT
	end
end)