local NAMES = STRINGS.NAMES
local RECIPE_DESC = STRINGS.RECIPE_DESC

--	Worldgen
	
	--	Plants
	NAMES.ANTLER_TREE = "Bullbark"
	NAMES.FARM_PLANT_ICELETTUCE = "Iceberg Lettuce"
	NAMES.GRASS_POLAR = "Tundra Grass"
	NAMES.ICELETTUCE_SEEDS = "Frigid Seed"
	NAMES.KNOWN_ICELETTUCE_SEEDS = "Iceberg Lettuce Seed"
	
	--	Rocks and stones
	NAMES.POLAR_ICICLE = "Icicle"
	NAMES.POLAR_ICICLE_ROCK = "Icicle"
	NAMES.ROCK_POLAR = "Ice Protuberance"
	
	--	Misc
	NAMES.POLARSNOW_MATERIAL = "In High Snow"
	NAMES.IN_POLARSNOW = "Snow?"
	NAMES.TUMBLEWEED_POLAR = "Tumblewind"
	
--	Mobs
	
	NAMES.MOOSE_POLAR = "Moose"
	NAMES.POLAR_PENGUIN = NAMES.PENGUIN
	NAMES.POLARBEAR = "Polar Bear"
	NAMES.POLARFOX = "Frost Tail"
	NAMES.POLARWARG = "Ice Varg"
	NAMES.SHADOW_ICICLER = "Shadow Spine"
	
--	Buildings
	
	NAMES.POLARBEARHOUSE = "Bear Bothy"
	
--	Items
	
	--	Food
	NAMES.ICELETTUCE = "Iceberg Lettuce"
	NAMES.ICEBURRITO = "Brrito"
	
	--	Crafting
	NAMES.BLUEGEM_OVERCHARGED = "Overcharged Blue Gem"
	NAMES.BLUEGEM_SHARDS = "Blue Gem Shards"
	NAMES.POLAR_DRYICE = "Dry Ice"
	NAMES.POLARBEARFUR = "Polar Fur"
	NAMES.POLARWARGSTOOTH = "Ice Fang"
	
	--	Equipments
	NAMES.ANTLER_TREE_STICK = "Bullbranch"
	NAMES.FROSTWALKERAMULET = "Chillest Amulet"
	NAMES.POLAR_SPEAR = "Stalagspear"
	NAMES.POLARMOOSEHAT = "Ushanka"
	
	--	Others
	NAMES.DUG_GRASS_POLAR = "Tundra Tuft"
	NAMES.POLARGLOBE = "Strange Snowglobe"
	NAMES.POLARICEPACK = "Icepack"
	NAMES.TURF_POLAR_CAVES = "Ice Cave Turf"
	NAMES.TURF_POLAR_DRYICE = "Cobbled Dry Ice"
	NAMES.WALL_POLAR = "Dry Ice Wall"
	NAMES.WALL_POLAR_ITEM = "Dry Ice Wall"
	
--	Skins
	
	--	Names
	STRINGS.SKIN_NAMES.ms_polarmoosehat_white = "Hornamented Ushanka"
	
	--	Desc
	STRINGS.SKIN_DESCRIPTIONS.ms_polarmoosehat_white = "Bears say they look sick with all the sticks tucked in!"
	
--	Speech, etc
	STRINGS.POLARCOLD_SNUFFING = {"(huff) ", "(sniff) ", "(sniffff) ", "(snort) ", "(snurf) ", "(snuffle) "}
	
	STRINGS.POLARBEARNAMES = {
		--	cold foods
		"Banana",
		"Ceviche",
		"Chicken Salad",
		"Gelato",
		"Granita",
		"Macaroni",
		"Mint",
		"Popsicle",
		"Sandwich",
		"Strawberry",
		"Sundae",
		"Tiramisu",
		--	mountains
		"Aconcagua",
		"Andes",
		"Blanc",
		"Chimborazo",
		"Cotopaxi",
		"Denali",
		"Eiger",
		"Elbrus",
		"Eureka",
		"Everest",
		"Fuji",
		"Kazbek",
		"Mam Tor",
		"Matterhorn",
		"Olympus",
		"Oymyakon",
		"Pyrenees",
		"Rainier",
		"Snag",
		"Tatra",
		"Ulaanbaatar",
		"Verkhoyansk",
		--	pitbulls
		"Cupcake",
		"Fluffball",
		"Jellybean",
		"Marshmallow",
		"Milkshake",
		"Princess",
		"Snowflake",
		"Sugarbean",
		--	warriors
		"Alfonso",
		"Alexander",
		"Bellantrix",
		"Cahira",
		"Igor",
		"Koa",
		"Ragnar",
		"Viggo",
	}
	
	STRINGS.POLARBEAR_LOOKATWILSON = {"GOOD DAY FOR FISHING", "SNIFF", "BRR...", "ICE TO MEET YOU", "... EH?", "HA! SMALL LIKE PENGULL!", "YOU'RE NO WALRUS?", "WATCH THE SNOW", "IS COLD OUTSIDE", "IS COLD INSIDE TOO"}
	STRINGS.POLARBEAR_FOLLOWWILSON = {"LET'S GO FISHING", "WHERE WE GOING?", "SNIFF SNIFFFF", "YOU'RE SMALL, BUT GOOD", "OH HO HO!", "I AM RIGHT BEHIND YOU", "ARE YOU NOT COLD?", "EH? COMING!"}
	STRINGS.POLARBEAR_ATTEMPT_TRADE = {"SNIFF SNIFF!", "HO HO WHAT IS IT?", "THAT SMELL..."}
	STRINGS.POLARBEAR_PLOWSNOW = {"GOODBYE SNOW", "SO MUCH SNOW...", "HUFF", "BRR...", "ALWAYS MORE SNOW...", "SNOWIER THAN BEFORE..."}
	STRINGS.POLARBEAR_FIGHT = {"RAAAAAAAAWRR", "RAAAWRRRRRRRR!", "GRRRRAAAWWW", "FIGHT, YOU MINNOW", "WILL TEAR YOU DOWN", "WILL SLICE YOU!", "COME BACK HERE", "FIGHT! FIGHT!", "YOU COME HERE"}
	STRINGS.POLARBEAR_FIND_FOOD = {"MMM... FOOD", "HO HO!", "WHAT NICE SMELL!", "THIS LOOK'S GOOD", "SLURP... FOOD", "OH HO HO YES!"}
	STRINGS.POLARBEAR_REFUSE_FOOD = {"NUH HUH", "BLECH!", "THIS BEARLY A BITE"}
	STRINGS.POLARBEAR_GOHOME = {"YAAAWN!", "GETTING EEPY...", "CAN'T BEAR THE DARK!", "HIBERNATION TIME", "SO LATE...", "NIGHT SO COLD..."}
	STRINGS.POLARBEAR_BLIZZARD = {"BBBRRRRR", "BRR... TOO COLD!", "NOT AGAIN", "IT'S COOOMING!", "THERE'S NO PLOWING THIS", "NO FISHING TODAY"}
	STRINGS.POLARBEAR_PANICHAUNT = {"ACK!", "EEP!", "POSSESSED SNOW!", "OH HO OOOOO"}
	STRINGS.POLARBEAR_PANICFIRE = {"FIIIREEE!", "NOT COOL! NOT COOL!", "I MELT!", "AAAAAA", "OH HO HO NOOO"}
	STRINGS.POLARBEAR_PANICHOUSEFIRE = {"OH NO NO NO!", "ANYBODY COOKING FISH?", "MY HOME MELTING!", "HOME TOO HOT!"}
	STRINGS.POLARBEAR_RESCUE = {"NEED A PAW?", "COMING, COMING!", "HO HO!"}
	
--	UI
	
	--	Actions
	STRINGS.ACTIONS.POLARPLOW = "Plow"
	STRINGS.ACTIONS.SNOWGLOBE = "Shake!"
	
	--	Scrapbook, Cookbook
	STRINGS.SCRAPBOOK.SPECIALINFO.ANTLER_TREE = "This tree has robust branches that could prove to be useful.\nHowever, axes won't cut it to take them off properly..."
	STRINGS.SCRAPBOOK.SPECIALINFO.ANTLER_TREE_STICK = "Improves movement in high snow and speed by 25% when held."
	STRINGS.SCRAPBOOK.SPECIALINFO.ICELETTUCE = "Ingesting this will help you brave the highest snow with ease for a while."
	STRINGS.SCRAPBOOK.SPECIALINFO.POLARICEPACK = "Slows the spoilage of carried or stored items by 25%. Can be stacked multiplicatively."
	STRINGS.SCRAPBOOK.SPECIALINFO.TUMBLEWEED_POLAR = "These bounce around in the blizzard and collect junk along the way.\n\nAll sorts of crazy junk.\n\nYou'd be surprised."
	STRINGS.SCRAPBOOK.SPECIALINFO.WALL_POLAR = "Whoever messes with this wall better chill out."
	
	STRINGS.UI.PLANTREGISTRY.DESCRIPTIONS.ICELETTUCE = "A most capricious vegetable...\nbut don't give it the cold shoulders. -W"
	
	--	Recipes
	RECIPE_DESC.FROSTWALKERAMULET = "Never was water this cool before!"
	RECIPE_DESC.POLAR_DRYICE = "Winter, in brick shape."
	RECIPE_DESC.POLARBEARHOUSE = "This place bears a bear."
	RECIPE_DESC.POLARICEPACK = "Make things in your pockets or storages a little cooler."
	RECIPE_DESC.SHARDS_BLUEGEM = "Shard work pays off."
	RECIPE_DESC.TURF_POLAR_CAVES = "The chilly stone of the chillest cave."
	RECIPE_DESC.TURF_POLAR_DRYICE = "A road sure to keep your toes frosty."
	RECIPE_DESC.WALL_POLAR_ITEM = "The best defence is the coolest one."
	
	STRINGS.UI.CRAFTING.NEEDSTECH.POLARSNOW = "There's not enough snow!"
	
	--	Misc
	STRINGS.UI.SANDBOXMENU.WORLDSETTINGS_POLAR = "The Winterlands"
	STRINGS.UI.SANDBOXMENU.WORLDGENERATION_POLAR = "The Winterlands"
	
	STRINGS.UI.CUSTOMIZATIONSCREEN.MOOSE_POLAR = "Mooses"
	STRINGS.UI.CUSTOMIZATIONSCREEN.POLAR_ICICLES = "Icicles"
	STRINGS.UI.CUSTOMIZATIONSCREEN.POLARBEARS = "Polar Bears"
	STRINGS.UI.CUSTOMIZATIONSCREEN.POLARFOXES = "Frost Tails"
	STRINGS.UI.CUSTOMIZATIONSCREEN.TUMBLEWEED_POLAR = "Tumblewinds"
	
	STRINGS.UI.CUSTOMIZATIONSCREEN.ANTLER_TREES = "Bullbarks"
	STRINGS.UI.CUSTOMIZATIONSCREEN.GRASS_POLAR = "Tundra Grass"
	STRINGS.UI.CUSTOMIZATIONSCREEN.POLARBEARHOUSES = "Bear Bothies"
	STRINGS.UI.CUSTOMIZATIONSCREEN.ROCKS_POLAR = "Ice Protuberances"
	