local NAMES = STRINGS.NAMES
local RECIPE_DESC = STRINGS.RECIPE_DESC

--	Worldgen
	
	--	Plants
	NAMES.ANTLER_TREE = "Bullbark"
	NAMES.FARM_PLANT_ICELETTUCE = "Iceberg Lettuce"
	NAMES.ICELETTUCE_SEEDS = "Frigid Seed"
	NAMES.KNOWN_ICELETTUCE_SEEDS = "Iceberg Lettuce Seed"
	
	--	Rocks and stones
	NAMES.POLAR_ICICLE = "Icicle"
	NAMES.POLAR_ICICLE_ROCK = "Icicle"
	NAMES.ROCK_POLAR = "Ice Protuberance"
	
	--	Misc
	NAMES.POLARSNOW_MATERIAL = "In High Snow"
	NAMES.IN_POLARSNOW = "Snow?"
	
--	Mobs
	NAMES.POLAR_PENGUIN = NAMES.PENGUIN
	NAMES.POLARBEAR = "Polar Bear"
	NAMES.POLARFOX = "Frost Tail"
	NAMES.SHADOW_ICICLER = "Shadow Spine"
	NAMES.POLARWARG = "Ice Varg"
	
--	Buildings
	NAMES.POLARBEARHOUSE = "Bear Bothy"
	
--	Items
	
	--	Food
	NAMES.ICELETTUCE = "Iceberg Lettuce"
	NAMES.ICEBURRITO = "Brrito"
	
	--	Crafting
	NAMES.POLAR_DRYICE = "Dry Ice"
	NAMES.POLARBEARFUR = "Polar Fur"
	
	--	Equipments
	NAMES.FROSTWALKERAMULET = "Chillest Amulet"
	NAMES.POLAR_SPEAR = "Stalagspear"
	NAMES.POLARMOOSEHAT = "Moose Ushanka"
	
	--	Others
	NAMES.POLARGLOBE = "Strange Snowglobe"
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
	
	STRINGS.POLARBEAR_LOOKATWILSON = {"GOOD DAY FOR FISHING", "SNIFF", "BRR...", "ICE TO MEET YOU", "... EH?", "HA! SMALL LIKE PENGULL!", "YOU'RE NO WALRUS?", "WATCH THE SNOW"}
	STRINGS.POLARBEAR_ATTEMPT_TRADE = {"SNIFF SNIFF!", "OH OH WHAT IS IT?", "THAT SMELL..."}
	STRINGS.POLARBEAR_PLOWSNOW = {"GOODBYE SNOW", "SO MUCH SNOW...", "HUFF", "BRR...", "ALWAYS MORE SNOW...", "SNOWIER THAN BEFORE..."}
	STRINGS.POLARBEAR_FIGHT = {"RAAAAAAAAWRR", "RAAAWRRRRRRRR!", "GRRRRAAAWWW", "FIGHT, YOU MINNOW", "WILL TEAR YOU DOWN", "WILL SLICE YOU!", "COME BACK HERE"}
	STRINGS.POLARBEAR_FIND_MEAT = {"MMM... FOOD", "OH OH!", "WHAT NICE SMELL!"}
	STRINGS.POLARBEAR_REFUSE_FOOD = {"NUH HUH", "BLECH!", "THIS BEARLY A BITE"}
	STRINGS.POLARBEAR_GOHOME = {"YAAAWN!", "GETTING EEPY...", "CAN'T BEAR THE DARK!", "HIBERNATION TIME"}
	STRINGS.POLARBEAR_PANICHAUNT = {"ACK!", "EEP!", "POSSESSED SNOW!"}
	STRINGS.POLARBEAR_PANICFIRE = {"FIIIREEE!", "NOT COOL! NOT COOL!", "I MELT!"}
	STRINGS.POLARBEAR_PANICHOUSEFIRE = {"OH NO NO NO!", "ANYBODY COOKING FISH?", "MY HOME MELTING!"}
	
--	UI
	
	--	Actions
	STRINGS.ACTIONS.POLARPLOW = "Plow"
	STRINGS.ACTIONS.SNOWGLOBE = "Shake!"
	
	--	Scrapbook, Cookbook
	STRINGS.SCRAPBOOK.SPECIALINFO.ICELETTUCE = "Ingesting this will help you brave the highest snow with ease for a while."
	STRINGS.SCRAPBOOK.SPECIALINFO.WALL_POLAR = "Whoever messes with this wall better chill out."
	
	STRINGS.UI.PLANTREGISTRY.DESCRIPTIONS.ICELETTUCE = "A most capricious vegetable...\nbut don't give it the cold shoulders. -W"
	
	--	Recipes
	RECIPE_DESC.FROSTWALKERAMULET = "Water never was this cool before!"
	RECIPE_DESC.POLAR_DRYICE = "Winter, in brick shape."
	RECIPE_DESC.POLARBEARHOUSE = "This place bears a bear."
	RECIPE_DESC.TURF_POLAR_CAVES = "The chilly stone of the chillest cave."
	RECIPE_DESC.TURF_POLAR_DRYICE = "A road sure to keep your toes frosty."
	RECIPE_DESC.WALL_POLAR_ITEM = "The best defence is the coolest one."
	
	STRINGS.UI.CRAFTING.NEEDSTECH.POLARSNOW = "There's not enough snow!"
	
	--	Misc
	STRINGS.UI.SANDBOXMENU.WORLDSETTINGS_POLAR = "The Winterlands"
	STRINGS.UI.SANDBOXMENU.WORLDGENERATION_POLAR = "The Winterlands"
	
	STRINGS.UI.CUSTOMIZATIONSCREEN.POLAR_ICICLES = "Icicles"
	STRINGS.UI.CUSTOMIZATIONSCREEN.POLARBEARS = "Polar Bears"
	STRINGS.UI.CUSTOMIZATIONSCREEN.POLARFOXES = "Frost Tails"
	STRINGS.UI.CUSTOMIZATIONSCREEN.ROCKS_POLAR = "Ice Protuberances"
	
	STRINGS.UI.CUSTOMIZATIONSCREEN.ANTLER_TREES = "Bullbarks"
	STRINGS.UI.CUSTOMIZATIONSCREEN.POLARBEARHOUSES = "Bear Bothies"