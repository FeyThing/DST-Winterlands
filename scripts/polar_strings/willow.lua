local ANNOUNCE = STRINGS.CHARACTERS.WILLOW
local DESCRIBE = STRINGS.CHARACTERS.WILLOW.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "I'll stuff Bernie with your fur!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Ugh... why did it have to be... snow.",
		"Get me out of here!",
		"Hmph...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Ah! I already hate it here!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Ack! Get this snow off me!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Ugh, better but not by much."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "YES! BURN!",
		BURNT = "Aaaand it's gone.",
		CHOPPED = "We'll meet again, tree.",
		GENERIC = "You better burn well.",
	}
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Huh?"
	DESCRIBE.POLAR_ICICLE_ROCK = "Ah! I could've gotten impaled!"
	DESCRIBE.ROCK_POLAR = "I can feel cold emanating from them."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Don't make me go in here."
	
--	Mobs
	DESCRIBE.POLARBEAR = {
		DEAD = "Hah, that's what you get, bear.",
		ENRAGED = "He's got fiery temper!",
		FOLLOWER = "Now, you bite for me!",
		GENERIC = "Oh you look very flammable.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Come with me, and you'll see...",
		GENERIC = "Hey there little guy!",
	}
	DESCRIBE.POLARWARG = "Get your fleas away from me."
	
--	Buildings
	
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ha ha! Your fish house stood no chance!",
		GENERIC = "Ugh, it smells like fish.",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "This is the opposite of good."
	DESCRIBE.ICEBURRITO = "I don't think any hot sauce can fix this."
	
	--	Crafting
	DESCRIBE.POLAR_DRYICE = "What's the point if it can't even melt?"
	DESCRIBE.POLARBEARFUR = "It keeps heat well."
	
	--	Equipments
	DESCRIBE.POLAR_SPEAR = "Keep your cool, if you must."
	DESCRIBE.POLARMOOSEHAT = "Smells fishy."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "What a dumb toy.",
		INUSE = "Why did you have to shake it, why?",
		REFUEL = "And don't come back!",
	}
	DESCRIBE.TURF_POLAR_CAVES = "The ground is boring and cold"
	DESCRIBE.TURF_POLAR_DRYICE = "The ground is boring and cold."
	DESCRIBE.WALL_POLAR = "I hate it."
	DESCRIBE.WALL_POLAR_ITEM = "Maybe I'll give it a chance."