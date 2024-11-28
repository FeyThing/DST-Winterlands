local ANNOUNCE = STRINGS.CHARACTERS.WINONA
local DESCRIBE = STRINGS.CHARACTERS.WINONA.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Come and throw paws!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Can't stop... won't stop... okay, stopping.",
		"I ain't slowin'... just pacing myself...",
		"Whew... I could use a breather outta there!",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Pfew! It's over. And it's... snowin'?"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Yeesh! I ain't dressed enough for that!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "And now to go through the wringer..."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Burn, baby tree, burn!",
		BURNT = "It's sprinklin' cinders in the snow.",
		CHOPPED = "It was more bark than... y'know.",
		GENERIC = "Looks sharp, but I've got sharper.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "I got no idea what it'd grow into."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Right. My hardhat!"
	DESCRIBE.POLAR_ICICLE_ROCK = "Sure hope I'm gettin' me hazard pay doing all this."
	DESCRIBE.ROCK_POLAR = "Don't mind if I do."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Whatever's under is anyone's guess."
	
--	Mobs
	
	DESCRIBE.POLARBEAR = {
		DEAD = "Down for the count!",
		ENRAGED = "Yeesh, we've got bear problems!",
		FOLLOWER = "So, uh, what's your favorite fish?",
		GENERIC = "Don't ya give me the cold shoulders.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "You get me rabbits, and I get you dinners, simple.",
		FRIEND = "Have I forgotten my part of our little engagement?",
		GENERIC = "Get over here, you little rascal!",
	}
	DESCRIBE.POLARWARG = "I've got no doubt about his minty breath."
	
--	Buildings
	
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Hm. Probably another wildfire.",
		GENERIC = "There something fishy about it.",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "In mint condition? It's practically cryopreserved!"
	DESCRIBE.ICEBURRITO = "Just what I needed to wrap up the day."
	
	--	Crafting
	DESCRIBE.POLAR_DRYICE = "Get it down the ice-embly line."
	DESCRIBE.POLARBEARFUR = "It's warm, and more importantly it's mine."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "This might prove useful."
	DESCRIBE.POLAR_SPEAR = "Pfft. Alright. Assuming you live in a freezer..."
	DESCRIBE.POLARMOOSEHAT = "Hey, Woodie. Do you still have all of your backside?"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Ha! Charlie loved these lil' things.",
		INUSE = "Oh you...",
		REFUEL = "Not sure how it leaked. But it's better that way.",
	}
	DESCRIBE.TURF_POLAR_CAVES = "That's a chunk of ground."
	DESCRIBE.TURF_POLAR_DRYICE = "That's a chunk of road."
	DESCRIBE.WALL_POLAR = "Yeah, that's pretty ice."
	DESCRIBE.WALL_POLAR_ITEM = "Assembly time."