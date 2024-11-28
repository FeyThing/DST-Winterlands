local ANNOUNCE = STRINGS.CHARACTERS.WARLY
local DESCRIBE = STRINGS.CHARACTERS.WARLY.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "You know what they say about selling bear fur?"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Aller... presque...",
		"Bon sang... oof...",
		"Hrrrr...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Brr! Who left the freezer door open?"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Q-quel froid! I need a bigger coat..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Aaahhh... what would we do without fire?"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "I'd better enjoy this fire while it lasts.",
		BURNT = "Crisp, no?",
		CHOPPED = "Clashed!",
		GENERIC = "Oh! I almost ran into it.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "It will grow some nice fresh vegetable."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "My thanks for the fresh reminder."
	DESCRIBE.POLAR_ICICLE_ROCK = "How will you get back up again?"
	DESCRIBE.ROCK_POLAR = "Shall we practice ice sculpting during the extraction?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Anything edible in here?"
	
--	Mobs
	
	DESCRIBE.POLARBEAR = {
		DEAD = "I can finally sell its fur.",
		ENRAGED = "It's hungry for a fight!",
		FOLLOWER = "It got quite the insatiable appetite.",
		GENERIC = "We're both eager to find out how the other taste like\n... or is it just me?",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "You simply can't say non to a good meal, non?",
		FRIEND = "What say you for a meal like old times?",
		GENERIC = "A cunning little renard.",
	}
	DESCRIBE.POLARWARG = "I'm all shivery, and it's not just the cold..."
	
--	Buildings
	
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Thought I smelled sardines.",
		GENERIC = "Would that really withstand a snowstorm?",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "Brr... could use dressing..."
	DESCRIBE.ICEBURRITO = "This is the last time I rely on Wilson to name my recipes."
	
	--	Crafting
	DESCRIBE.POLAR_DRYICE = "What big ice cubes!"
	DESCRIBE.POLARBEARFUR = "The coziest of snowballs."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Salut, vieille branche!"
	DESCRIBE.FROSTWALKERAMULET = "This takes frosting to the next level!"
	DESCRIBE.POLAR_SPEAR = "It's all fun until it starts dripping."
	DESCRIBE.POLARMOOSEHAT = "There better be no vinous hunter in these parts."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "This makes for a good feasting table decoration.",
		INUSE = "Well. I'd better prep some soup for everyone.",
		REFUEL = "Ah non! You aren't getting your snow back.",
	}
	DESCRIBE.TURF_POLAR_CAVES = "It's like an ingredient for the ground."
	DESCRIBE.TURF_POLAR_DRYICE = "It's like an ingredient for the ground."
	DESCRIBE.WALL_POLAR = "Aaah. Isn't that ice?"
	DESCRIBE.WALL_POLAR_ITEM = "I trust it won't melt anytime soon."