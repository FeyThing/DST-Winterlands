local ANNOUNCE = STRINGS.CHARACTERS.WOODIE
local DESCRIBE = STRINGS.CHARACTERS.WOODIE.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Rrraaargh!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"I'm used... to this...",
		"Grrmmmph...",
		"It's just a bit of snow...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Guess we'll need more firewood, eh?"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "I could use a big, warm fur right aboot now."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "That's better."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "No! You won't get away without a fight, bud.",
		BURNT = "Coward.",
		CHOPPED = "That will show 'em.",
		GENERIC = "Not now Luce, I'll butt with this one personally!",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Maybe I could plant it?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "They get bigger here than over the ol' cabin."
	DESCRIBE.POLAR_ICICLE_ROCK = "It won't get any lower, eh?"
	DESCRIBE.ROCK_POLAR = "Lick it, and you're stuck for good."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "I know a {name} when I see one."
	
--	Mobs
	
	DESCRIBE.POLARBEAR = {
		DEAD = "You would make a fine rug.",
		ENRAGED = "Now we're fightin'!",
		FOLLOWER = "Always down for a fishing trip, eh?",
		GENERIC = "Sounds like someone got a little cold.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Go get'em birds!",
		FRIEND = "That's my old chum.",
		GENERIC = "A rare sight even up in the North.",
	}
	DESCRIBE.POLARWARG = "It could pull a sled on its own."
	
--	Buildings
	
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Guess it was only built to withstand the cold.",
		GENERIC = "I used to say: you live in what you eat, eh.",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "Like biting ice cubes in a drink."
	DESCRIBE.ICEBURRITO = "It's better to eat fresh."
	
	--	Crafting
	DESCRIBE.POLAR_DRYICE = "Building blocks for the cool kids."
	DESCRIBE.POLARBEARFUR = "I should stuff my plaid with it."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "I'll just take that, eh!"
	DESCRIBE.POLAR_SPEAR = "Ice suppose that would hurt a little."
	DESCRIBE.POLARMOOSEHAT = "That's more my kind of headwear!"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "I kinda want to go in here, eh.",
		INUSE = "C'mon, I didn't mean it seriously.",
		REFUEL = "No snow on the horizon.",
	}
	DESCRIBE.TURF_POLAR_CAVES = "Just more ground, eh?"
	DESCRIBE.TURF_POLAR_DRYICE = "Now to find ice skates in here..."
	DESCRIBE.WALL_POLAR = "Anyone's feelin' like breaking the ice?"
	DESCRIBE.WALL_POLAR_ITEM = "How aboot we build some igloo, eh Lucy?"