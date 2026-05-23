local ENV = env
GLOBAL.setfenv(1, GLOBAL)

function PolarRecipe(name, ingredients, tech, config, filters, order)
	if config == nil then
		config = {}
	end
	
	ENV.AddRecipe2(name, ingredients, tech, config, filters)
	ENV.AddRecipeToFilter(name, CRAFTING_FILTERS.MODS.name)
	
	if order then
		for i, filter in ipairs(filters) do
			if filter ~= "CRAFTING_STATION" then
				local FILTER = CRAFTING_FILTERS[filter]
				local resort = true
				for j, recipe in ipairs(FILTER.recipes) do
					if recipe == order[i] and resort then
						table.insert(FILTER.recipes, j + 1, name)
						resort = false
					elseif recipe == name and resort then
						table.remove(FILTER.recipes, j)
					else
						resort = true
					end
				end
			end
		end
	end
end

--	[ 	Station 	Defs	]	--

local POLAR_CRAFTING_ATLAS = "images/crafting_menu_polar.xml"

PROTOTYPER_DEFS["polaramulet_station"] = {icon_atlas = POLAR_CRAFTING_ATLAS, icon_image = "polaramulet_station.tex", action_str = "TRADE", is_crafting_station = true, filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.POLARAMULET_STATION}
PROTOTYPER_DEFS["polarbearking"] = {icon_atlas = POLAR_CRAFTING_ATLAS, icon_image = "polarbearking.tex", action_str = "URSATALK", is_crafting_station = true, filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.POLARBEARKING_TRIALS}
PROTOTYPER_DEFS["walrus"] = PROTOTYPER_DEFS["walrus"] or {icon_atlas = POLAR_CRAFTING_ATLAS, icon_image = "station_walrustrader.tex", action_str = "TRADE", is_crafting_station = true, filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.WANDERINGWALRUSSHOP}
PROTOTYPER_DEFS["girl_walrus"] = {icon_atlas = POLAR_CRAFTING_ATLAS, icon_image = "station_girl_walrustrader.tex", action_str = "TRADE", is_crafting_station = true, filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.WANDERINGWALRUSSHOP}
PROTOTYPER_DEFS["little_walrus"] = PROTOTYPER_DEFS["little_walrus"] or {icon_atlas = POLAR_CRAFTING_ATLAS, icon_image = "station_little_walrustrader.tex", action_str = "TRADE", is_crafting_station = true, filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.WANDERINGWALRUSSHOP}

local POLAR_TECHING = {
	"polarsnow_material",
	"polarbear_material"
}

local OldIsTechIngredient = IsTechIngredient
function IsTechIngredient(ingredienttype, ...)
	if table.contains(POLAR_TECHING, ingredienttype) then
		return true
	end
	
	return OldIsTechIngredient(ingredienttype, ...)
end

--	[ 		Recipes			]	--

--	Refine
PolarRecipe("shards_bluegem", 		{Ingredient("bluegem_shards", 3)}, 														TECH.SCIENCE_TWO, 	{product = "bluegem", description = "shards_bluegem"}, 	{"REFINE"}, {"purplegem"})
PolarRecipe("polar_dryice", 		{Ingredient("ice", 6), Ingredient(TECH_INGREDIENT.POLARSNOW, 2)}, 						TECH.LOST, 			nil, 													{"REFINE"}, {"bearger_fur"})

--	Tools / Weapons
PolarRecipe("polar_spear", 			{Ingredient("ice", 3), Ingredient("twigs", 2)}, 										TECH.LOST, 			nil, 		{"WEAPONS"}, {"spear_wathgrithr_lightning"})
PolarRecipe("trap_polarteeth", 		{Ingredient("ice", 1), Ingredient("cutstone", 1), Ingredient("polarwargstooth", 1)}, 	TECH.SCIENCE_TWO, 	nil, 		{"WEAPONS"}, {"trap_teeth"})
PolarRecipe("winters_fists", 		{Ingredient("emperor_egg", 2), Ingredient("polar_dryice", 2)}, 							TECH.LOST, 			nil, 		{"WEAPONS", "SUMMER"}, {"wathgrithr_shield", "icehat"})

--	Armor / Clothing
PolarRecipe("armorpolar", 			{Ingredient("polarbearfur", 3), Ingredient("pigskin", 1)}, 								TECH.SCIENCE_TWO, 	nil, 		{"ARMOUR", "WINTER"}, {"armor_bramble", "raincoat"})
PolarRecipe("flower_polarhat", 		{Ingredient("petals_polar", 12)}, 														TECH.MAGIC_TWO, 	nil, 		{"CLOTHING", "MAGIC"}, {"flowerhat", "antlionhat"})
PolarRecipe("polarbearhat", 		{Ingredient("polarbearfur", 1), Ingredient("meat", 1)}, 								TECH.SCIENCE_ONE, 	nil, 		{"CLOTHING", "WINTER"}, {"beefalohat", "beefalohat"})
PolarRecipe("polarflea_sack", 		{Ingredient("polarbearfur", 2), Ingredient("polarflea", 2), Ingredient("cutreeds", 6)}, TECH.SCIENCE_TWO, 	nil, 		{"CONTAINERS", "WINTER"}, {"spicepack", "beargervest"})

--	Cooking / Food
PolarRecipe("polaricepack", 		{Ingredient("polar_dryice", 1), Ingredient("bluegem_shards", 2), Ingredient("mosquitosack", 1)}, 	TECH.SCIENCE_TWO, 	nil, 	{"COOKING"}, {"icepack"})

--	Boating / Fishing
PolarRecipe("boat_ice_item", 		{Ingredient("polar_dryice", 1)}, 											TECH.SEAFARING_ONE, 	{numtogive = 8}, 	{"SEAFARING"}, {"flotationcushion"})
PolarRecipe("polarice_plow_item", 	{Ingredient("log", 3), Ingredient("cutstone", 1), Ingredient("mole", 1)}, 	TECH.SEAFARING_ONE, 	nil, 				{"FISHING", "SEAFARING", "WINTER"}, {"ocean_trawler_kit", "flotationcushion", "winterometer"})

--	Decor / Structure
local BEAR_RUG_PLACER_TAGS = {"polarbearrug", "antlion_sinkhole_blocker", "polarbearrug_blocker"}
local BEAR_RUG_PLACER_NOT_TAGS = {"boat"}

function BearRugFn(pt)
	local rug_rad = TUNING.POLARBEAR_RUG_RADIUS
	
	for theta = 0, TWOPI, PI / 4 do
		if not TheWorld.Map:IsPassableAtPoint(pt.x + rug_rad * math.cos(theta), 0, pt.z + rug_rad * math.sin(theta)) then
			return false
		end
	end
	
	return not TheWorld.Map:IsPointNearHole(pt, rug_rad + 0.25)
		and #TheSim:FindEntities(pt.x, pt.y, pt.z, rug_rad + 0.25, nil, BEAR_RUG_PLACER_NOT_TAGS, BEAR_RUG_PLACER_TAGS) == 0
end

PolarRecipe("polar_brazier_item", 	{Ingredient("boneshard", 2), Ingredient("cutstone", 1), Ingredient("rope", 1)}, 			TECH.LOST, 				nil, 																							{"LIGHT", "STRUCTURES", "WINTER"}, {"dragonflyfurnace", "dragonflyfurnace", "dragonflyfurnace"})
PolarRecipe("polarbear_rug", 		{Ingredient("sewing_kit", 0), Ingredient("polarbearfur", 2)}, 								TECH.LOST, 				{placer = "polarbear_rug_placer", min_spacing = 0, testfn = BearRugFn}, 						{"DECOR", "WINTER"}, {"sewing_mannequin", "tent"})
PolarRecipe("polarbearhouse", 		{Ingredient("boards", 4), Ingredient("polar_dryice", 3), Ingredient("polarbearfur", 4)}, 	TECH.SCIENCE_TWO, 		{placer = "polarbearhouse_placer"}, 															{"STRUCTURES"}, {"rabbithouse"})
PolarRecipe("turf_polar_caves", 	{Ingredient("ice", 2), Ingredient("rocks", 1)}, 											TECH.TURFCRAFTING_TWO, 	{numtogive = 4}, 																				{"DECOR"}, {"turf_vent"})
PolarRecipe("turf_polar_dryice", 	{Ingredient("polar_dryice", 1), Ingredient("bluegem", 1)}, 									TECH.SCIENCE_TWO, 		{numtogive = 4}, 																				{"DECOR"}, {"turf_dragonfly"})
PolarRecipe("turf_polar_grass", 	{Ingredient("petals_polar", 6)}, 															TECH.TURFCRAFTING_TWO, 	{numtogive = 4}, 																				{"DECOR"}, {"turf_polar_caves"})
PolarRecipe("wall_polar_item", 		{Ingredient("polar_dryice", 2), Ingredient("bluegem", 1)}, 									TECH.SCIENCE_TWO, 		{numtogive = 6}, 																				{"STRUCTURES", "DECOR"}, {"wall_moonrock_item", "wall_moonrock_item"})
PolarRecipe("polarheadstick", 		{Ingredient("twigs", 4)}, 																	TECH.LOST, 				{placer = "polarheadstick_placer", min_spacing = 0.9}, 											{"DECOR"}, {"sewing_mannequin"})

PolarRecipe("chesspiece_emperor_penguin_fruity_builder", 	{Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, 	{nounlock = true, actionstr = "SCULPTING", image = "chesspiece_emperor_penguin_fruity.tex"}, 	{"CRAFTING_STATION"}, {"chesspiece_sharkboi_builder"})
PolarRecipe("chesspiece_emperor_penguin_juggle_builder", 	{Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, 	{nounlock = true, actionstr = "SCULPTING", image = "chesspiece_emperor_penguin_juggle.tex"}, 	{"CRAFTING_STATION"}, {"chesspiece_sharkboi_builder"})
PolarRecipe("chesspiece_emperor_penguin_magestic_builder", 	{Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, 	{nounlock = true, actionstr = "SCULPTING", image = "chesspiece_emperor_penguin_magestic.tex"}, 	{"CRAFTING_STATION"}, {"chesspiece_sharkboi_builder"})
PolarRecipe("chesspiece_emperor_penguin_spin_builder", 		{Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, 	{nounlock = true, actionstr = "SCULPTING", image = "chesspiece_emperor_penguin_spin.tex"}, 		{"CRAFTING_STATION"}, {"chesspiece_sharkboi_builder"})

--	Events
PolarRecipe("arctic_fool_fish", 			{Ingredient("papyrus", 1)}, 											TECH.ARCTIC_FOOLS, 				{numtogive = 4, hint_msg = "NEEDSARCTIC_FOOL"}, 													{"SPECIAL_EVENT"})
PolarRecipe("snowball_item_polar", 			{Ingredient("ice", 1), Ingredient(TECH_INGREDIENT.POLARSNOW, 2)}, 		TECH.WINTERS_FEAST, 			{product = "snowball_item", description = "snowball_item_polar", hint_msg = "NEEDSWINTERS_FEAST"}, 	{"SPECIAL_EVENT"}, {"giftwrap"})
PolarRecipe("wintercooking_polarcrablegs", 	{Ingredient("wintersfeastfuel", 1), Ingredient("polarflea", 2)}, 		TECH.WINTERSFEASTCOOKING_ONE, 	{nounlock = true, manufactured = true, actionstr = "COOK", image = "polarcrablegs.tex"}, 			{"CRAFTING_STATION"}, {"wintercooking_tourtiere"})

--	Survivors
local function pocketwatch_nodecon(inst) return not inst:HasTag("pocketwatch_inactive") end

PolarRecipe("pocketwatch_polar", 		{Ingredient("pocketwatch_parts", 2), Ingredient("bluegem_shards", 6), Ingredient("polarwargstooth", 2)}, 	TECH.SCIENCE_TWO, 			{builder_tag = "clockmaker", no_deconstruction = pocketwatch_nodecon}, 	{"CHARACTER", "ARMOUR"}, {"pocketwatch_portal", "wathgrithr_shield"})
PolarRecipe("wx78module_naughty", 		{Ingredient("scandata", 4), Ingredient("charcoal", 2)}, 													TECH.ROBOTMODULECRAFT_ONE, 	{builder_tag = "upgrademoduleowner", nounlock = false}, 				{"CHARACTER", "MAGIC"}, {"wx78module_stacksize", "leif_idol"})

--	[ 	Crafting Station	]	--

--	Shack

PolarRecipe("polaramulet_builder", 			{Ingredient("rope", 3)}, 									TECH.POLARAMULET_STATION, 	{image = "polaramulet.tex", manufactured = true, nounlock = true, sg_state = "give"}, 	{"CRAFTING_STATION"})
PolarRecipe("polar_fishingrod",				{Ingredient("smallmeat", 2)}, 								TECH.POLARAMULET_STATION, 	{product = "fishingrod", nounlock = true, image = "fishingrod.tex", actionstr = "POLAREXCHANCESHOP", sg_state = "give"}, 					{"CRAFTING_STATION"})
PolarRecipe("polar_oceanfishingrod",		{Ingredient("fishingrod", 1), Ingredient("meat", 4)}, 		TECH.POLARAMULET_STATION, 	{product = "oceanfishingrod", nounlock = true, image = "oceanfishingrod.tex", actionstr = "POLAREXCHANCESHOP", sg_state = "give"}, 			{"CRAFTING_STATION"})
PolarRecipe("winters_fists_blueprint", 		{Ingredient("papyrus", 1), Ingredient("emperor_egg", 1)}, 	TECH.POLARAMULET_STATION, 	{nounlock = true, image = "blueprint_rare.tex", actionstr = "POLAREXCHANCESHOP", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, {"CRAFTING_STATION"})

PolarRecipe("polarcrownhat", 				{Ingredient("ice", 200), Ingredient("bluegem_overcharged", 1)}, 											TECH.LOST, 					{nounlock = true, actionstr = "POLAREXCHANCESHOP", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})--{"ARMOUR", "MAGIC"}, {"dreadstonehat", "dreadstonehat"})
PolarRecipe("frostwalkeramulet", 			{Ingredient("bluegem_shards", 3), Ingredient("bluegem_overcharged", 1)}, 									TECH.LOST, 					{nounlock = true, actionstr = "POLAREXCHANCESHOP", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"blueamulet"})
PolarRecipe("iciclestaff", 					{Ingredient("polar_dryice", 1), Ingredient("bluegem_overcharged", 1), Ingredient("deerclops_eyeball", 1)}, 	TECH.LOST, 					{nounlock = true, actionstr = "POLAREXCHANCESHOP", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"icestaff"})
PolarRecipe("polaricestaff", 				{Ingredient("antler_tree_stick", 1), Ingredient("bluegem_overcharged", 1)}, 								TECH.LOST, 					{nounlock = true, actionstr = "POLAREXCHANCESHOP", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})--{"MAGIC"}, {"icestaff"})
PolarRecipe("polar_lavae_tooth", 			{Ingredient("lavae_egg", 1), Ingredient("redgem", 1)}, 														TECH.LOST, 					{product = "lavae_tooth", description = "polar_lavae_tooth", nounlock = true, actionstr = "POLAREXCHANCESHOP", sg_state = "give", hint_msg = "NEEDSPOLARAMULET_STATION"}, 	{"CRAFTING_STATION"})

PolarRecipe("bluegem_overcharged", 			{Ingredient("moose_polar_antler", 1), Ingredient("bluegem", 1)}, 											TECH.POLARAMULET_STATION, 	{nounlock = true, sg_state = "give"}, 	{"CRAFTING_STATION"})

for phase, phase_data in pairs(POLARAMULET_STATION_MOONPHASE_TRADEDATA) do
	for i, recipe_data in ipairs(phase_data) do
		local recipe_name = string.format("polar_trade_%s_%d", phase, i)
		PolarRecipe(recipe_name, recipe_data.ingredients, TECH.LOST, {product = recipe_data.product, description = recipe_data.description or "polar_trade_"..i, numtogive = recipe_data.numtogive, limitedamount = true, nounlock = true, sg_state = "give", nameoverride = recipe_data.nameoverride, image = recipe_data.image, hint_msg = "NEEDSPOLARAMULET_STATION"}, {"CRAFTING_STATION"})
	end
end

--	Ursa Major

PolarRecipe("trial_fist_fight", 			{Ingredient(TECH_INGREDIENT.POLARBEAR, 1)}, 	TECH.POLARBEARKING_TRIALS, 	{nounlock = true, actionstr = "URSATRIALS", sg_state = "challenge_bearking"}, 	{"CRAFTING_STATION"})
PolarRecipe("trial_endurence_fight", 		{Ingredient(TECH_INGREDIENT.POLARBEAR, 2)}, 	TECH.POLARBEARKING_TRIALS, 	{nounlock = true, actionstr = "URSATRIALS", sg_state = "challenge_bearking"}, 	{"CRAFTING_STATION"})
PolarRecipe("trial_all_out_rumble", 		{Ingredient(TECH_INGREDIENT.POLARBEAR, 7)}, 	TECH.POLARBEARKING_TRIALS, 	{nounlock = true, actionstr = "URSATRIALS", sg_state = "challenge_bearking"}, 	{"CRAFTING_STATION"})

--	Walrus

for walrus, walrus_data in pairs(POLARWALRUS_TRADEDATA) do
	local product_counts = {}
	
	for i, recipe_data in ipairs(walrus_data) do
		product_counts[recipe_data.product] = (product_counts[recipe_data.product] or 0) + 1
		
		local recipe_name = string.format(walrus.."_trade_%s%d", recipe_data.product, product_counts[recipe_data.product])
		local base_name = STRINGS.NAMES[string.upper(recipe_data.product)]
		
		if recipe_data.numtogive then
			STRINGS.NAMES[string.upper(recipe_name)] = string.format("%s x%d", base_name, recipe_data.numtogive)
		end
		
		PolarRecipe(recipe_name, recipe_data.ingredients, TECH.LOST, {product = recipe_data.product, description = recipe_data.description or "walrustrade_"..recipe_data.product, numtogive = recipe_data.numtogive, limitedamount = true, nounlock = true, actionstr = "WALRUSSHOP", sg_state = "give", nameoverride = recipe_data.nameoverride, image = recipe_data.image, hint_msg = "NEEDSWANDERINGWALRUSSHOP"}, {"CRAFTING_STATION"})
	end
end

-- Tea Teas

local NUM_TEASHOP_LEVELS = 3
local NUM_COMMON_PETALS_FOR_TEASHOP_LEVEL = {8, 6, 4}
local NUM_RARE_PETALS_FOR_TEASHOP_LEVEL = {6, 4, 2}

for i = 1, NUM_TEASHOP_LEVELS do
	local num_common_petals = NUM_COMMON_PETALS_FOR_TEASHOP_LEVEL[i]
	local num_rare_petals = NUM_RARE_PETALS_FOR_TEASHOP_LEVEL[i]
	
	PolarRecipe("hermitcrabtea_petals_polar_"..i, {Ingredient("messagebottleempty", 1), Ingredient("petals_polar_dried", num_common_petals)}, TECH.LOST, {product = "hermitcrabtea_petals_polar", nounlock = true, sg_state = "give", manufactured = true, actionstr = "HERMITCRABSHOP", hint_msg = "NEEDSHERMITCRAB_TEASHOP"})
end

--	[ 	Deconstruction		]	--

local AddDeconstructRecipe = ENV.AddDeconstructRecipe

AddDeconstructRecipe("compass_polar", 			{Ingredient("compass", 1), Ingredient("ice", 3)})
AddDeconstructRecipe("emperor_penguinhat", 		{Ingredient("fishmeat_small", 4), Ingredient("ice", 20)})
AddDeconstructRecipe("polar_brazier", 			{Ingredient("boneshard", 3), Ingredient("cutstone", 1), Ingredient("rope", 1)})
AddDeconstructRecipe("polaramulet", 			{Ingredient("rope", 3), Ingredient("nightmarefuel", 1)})
AddDeconstructRecipe("polarbearhead", 			{Ingredient("polarbearfur", 4), Ingredient("twigs", 4)})
AddDeconstructRecipe("polarmoosehat", 			{Ingredient("cutgrass", 6), Ingredient("boneshard", 4), Ingredient("polarflea", 2)})
AddDeconstructRecipe("polarwalrushead", 		{Ingredient("walrus_tusk", 2), Ingredient("walrushat", 1), Ingredient("twigs", 4)})
AddDeconstructRecipe("tower_polar_flag", 		{Ingredient("tower_polar_flag_item", 1)})

--	[ 	Construction Plans	]	--

CONSTRUCTION_PLANS["polarheadstick"] = 			{Ingredient("polarbearfur", 2), Ingredient("meat", 1)}
CONSTRUCTION_PLANS["polarheadstick_merm"] = 	{Ingredient("froglegs", 2), Ingredient("pondfish", 1)}
CONSTRUCTION_PLANS["polarheadstick_pig"] = 		{Ingredient("pigskin", 2), Ingredient("meat", 1)}
CONSTRUCTION_PLANS["polarheadstick_walrus"] = 	{Ingredient("walrus_tusk", 2), Ingredient("walrushat", 1)}