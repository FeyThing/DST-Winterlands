local ANNOUNCE = STRINGS.CHARACTERS.WENDY
local DESCRIBE = STRINGS.CHARACTERS.WENDY.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Let's put you to sleep."
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Cold chains... pulling me down...",
		"Each step is slower than the last...",
		"I don't find it funny... Abigail...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Is it the end yet?"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "The cold seeps into my very soul."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "The cold snow bled out."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Even in flames, it stands with dignity.",
		BURNT = "Don't crumble, let me end you.",
		CHOPPED = "It's met its end at our hands.",
		GENERIC = "I think it's... pretty.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "It's a plant that's waiting to be."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "It will try to take another life in its fall."
	DESCRIBE.POLAR_ICICLE_ROCK = "Oh. I was too late."
	DESCRIBE.ROCK_POLAR = "Some pieces are colder than others."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Come out."
	
--	Mobs
	
	DESCRIBE.POLARBEAR = {
		DEAD = "You will be missed, perhaps.",
		ENRAGED = "I knew this was too easy.",
		FOLLOWER = "It's my stuffy now.",
		GENERIC = "A predator born of the ice.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Would you like to take me somewhere?",
		FRIEND = "Oh. Did I leave you to starve?",
		GENERIC = "A sly shade in the snow.",
	}
	DESCRIBE.POLARWARG = "The champion of the tundra."
	
--	Buildings
	
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "No longer a refuge from the biting cold.",
		GENERIC = "They made their graves here.",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "This year's harvest was most disappointing."
	DESCRIBE.ICEBURRITO = "My frozen heart won't feel the change."
	
	--	Crafting
	DESCRIBE.POLAR_DRYICE = "Ghostly."
	DESCRIBE.POLARBEARFUR = "It carries the weight of its loss, and vermins."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Another tree bone."
	DESCRIBE.POLAR_SPEAR = "It will eventually fall apart."
	DESCRIBE.POLARMOOSEHAT = "Even I don't know who it's made of."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "This looks so fragile...",
		INUSE = "I see. Breaking it would have lasting consequences.",
		REFUEL = "I can't shake it no more. What a pity.",
	}
	DESCRIBE.TURF_POLAR_CAVES = "Some ground."
	DESCRIBE.TURF_POLAR_DRYICE = "Cold stone beneath my feet."
	DESCRIBE.WALL_POLAR = "Alas, they won't melt easily."
	DESCRIBE.WALL_POLAR_ITEM = "Parts of an icy prison to lock myself away."