local ANNOUNCE = STRINGS.CHARACTERS.WORMWOOD
local DESCRIBE = STRINGS.CHARACTERS.WORMWOOD.DESCRIBE

--	Announcements
	
	--	Actions
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Not like here...",
		"Cold! Cold!",
		"Not like cold!",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Oww oow oww!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Noo! Cold!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Ahhh. Snow is all gone"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Fire! Nooooo!",
		BURNT = "Snow not enough?",
		CHOPPED = "(sigh) Why fight?",
		GENERIC = "Why grow horns for?",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Chilly baby"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Growing?"
	DESCRIBE.POLAR_ICICLE_ROCK = "Big fall"
	DESCRIBE.ROCK_POLAR = "Cold Shiny trapped in ice? How?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Mmm?"
	
--	Mobs

	DESCRIBE.POLARBEAR = {
		DEAD = "Uh oh...",
		ENRAGED = "Need to chill!",
		FOLLOWER = "Cold Fuzzy good friend",
		GENERIC = "Oh. Cold Fuzzy!",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Shh... it's okay now",
		GENERIC = "Aww! Come, COME!",
	}
	DESCRIBE.POLARWARG = "Big chilly woofer"
	
--	Buildings
	
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Smells fishy",
		GENERIC = "Glub Glub house",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "Friend want big warm hug?"
	DESCRIBE.ICEBURRITO = "Glub Glub sleeping in roll"
	
	--	Crafting
	DESCRIBE.POLAR_DRYICE = "For fresh snack"
	DESCRIBE.POLARBEARFUR = "Warm"
	
	--	Equipments
	DESCRIBE.POLAR_SPEAR = "Spiky"
	DESCRIBE.POLARMOOSEHAT = "Axe friend?"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Hmm... Someone touched?",
		INUSE = "No no no. Go back inside!",
		REFUEL = "Finally sleeping?",
	}
	DESCRIBE.TURF_POLAR_CAVES = "Ice"
	DESCRIBE.TURF_POLAR_DRYICE = "Ice"
	DESCRIBE.WALL_POLAR = "Slippery"
	DESCRIBE.WALL_POLAR_ITEM = "Slurp"