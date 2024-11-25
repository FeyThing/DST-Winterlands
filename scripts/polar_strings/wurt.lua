local ANNOUNCE = STRINGS.CHARACTERS.WURT
local DESCRIBE = STRINGS.CHARACTERS.WURT.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Glorp, won't eat me!!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Can't run... can't swim... no can do...",
		"Grrrr... stupid big sea of snow!",
		"It not like water at all!",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Glr-rpp, leave ground alone!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Glurgh! Big sea of snow is wet AND cold!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Aaah... it good wet again."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Nice and cozy, florp.",
		BURNT = "Won't burn again.",
		CHOPPED = "It sinking in big sea of snow.",
		GENERIC = "Hm, you far friend of swamp tree?",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Put in ground!"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Glurp...? Was just wind."
	DESCRIBE.POLAR_ICICLE_ROCK = "This big droplet, florp!"
	DESCRIBE.ROCK_POLAR = "Oooh, shiny bits inside!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "What that thing, florp?"
	
--	Mobs
	
	DESCRIBE.POLARBEAR = {
		DEAD = "Good. Won't eat fishie now.",
		ENRAGED = "GLORPT! RUN!!",
		FOLLOWER = "Me n-not scared of you!",
		GENERIC = "Glorp...! Is Mermfolk eater...",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Aww, it too cute!",
		GENERIC = "It like swimming in big sea of snow, flort.",
	}
	DESCRIBE.POLARWARG = "Wanna help kill Bearfolk?"
	
--	Buildings
	
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Yesss, one less!",
		GENERIC = "Not wanna see what in here...",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "Is icy-cream growing in ground?!"
	DESCRIBE.ICEBURRITO = "Huh? Gluurrgh... poor fish in it."
	
	--	Crafting
	DESCRIBE.POLAR_DRYICE = "Why this ice not Eddy-bluh?"
	DESCRIBE.POLARBEARFUR = "Me could eat it as revenge... but won't."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Tree dropped this, but me keep it."
	DESCRIBE.POLAR_SPEAR = "But, Wicker-lady said not to play with food?"
	DESCRIBE.POLARMOOSEHAT = "Hee-hee, got your hat pbbbth!"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Haha! Winter trapped inside!",
		INUSE = "G-glurp! Didn't do it!",
		REFUEL = "Uh oh. Winter escaped?",
	}
	DESCRIBE.TURF_POLAR_CAVES = "Ground bit."
	DESCRIBE.TURF_POLAR_DRYICE = "Make ground walk-ier!"
	DESCRIBE.WALL_POLAR = "Brrr... don't want to live in ice castle!"
	DESCRIBE.WALL_POLAR_ITEM = "Will make big ice castle, flort."