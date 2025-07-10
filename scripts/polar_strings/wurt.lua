local ANNOUNCE = STRINGS.CHARACTERS.WURT
local DESCRIBE = STRINGS.CHARACTERS.WURT.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Glorp, won't eat me!!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Glurgh?! Grrr, won't get me next time..."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Can't run... can't swim... no can do...",
		"Grrrr... stupid big sea of snow!",
		"It not like water at all!",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "Swamp {wins}, Snow 0!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Glr-rpp, leave ground alone!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Maybe not here."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Best day ever, florp!"
	
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
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Can't go in cave under cave yet." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Oooh big castle, like in story books!",
		PENGUIN = "Grrr! Come back down!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Heehee, will catch you!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Should join forces and conquer Pigfolk!",
		HOSTILE = "Why can't get along?",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Is protecting Snowfolk, florp!"
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Me want horn bit to grow back too, florp.",
		ANTLER = "Would like have big horns like this...",
	}
	DESCRIBE.MOOSE_SPECTER = "Oooh! It like in book of not-real-things!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "It sooo prettyyy!"
	DESCRIBE.POLARBEAR = {
		DEAD = "Good. Won't eat fishie now.",
		ENRAGED = "GLORPT! RUN!!",
		FOLLOWER = "Me n-not scared of you!",
		GENERIC = "Glorp...! Is Mermfolk eater...",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Glurgh, it everywhere!",
		HELD = "Go away! Go awaaaay!",
		HELD_BACKPACK = "Got big plans for you.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Aww, it too cute!",
		FRIEND = "Why not following anymore, florp?",
		GENERIC = "It like swimming in big sea of snow, flort.",
	}
	DESCRIBE.POLARWARG = "Wanna help kill Bearfolk?"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "What fruity, florp? Where fruit?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Clown man can do it better!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Did to you what you did to fishies."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Hmm. Maybe me should make Merm King statues..."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Toss wood in it.",
		ON = "It a bit tall but still feel warm.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Stole it from Bearfolk!"
	DESCRIBE.POLAR_THRONE = "Can make better one with own two claws."
	DESCRIBE.POLAR_THRONE_GIFTS = "Mine! It all mine!!"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Probably... safe.",
		OPEN = "Hello? You not Bearfolk?",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Yesss, one less!",
		GENERIC = "Not wanna see what in here...",
	}
	DESCRIBE.POLARICE_PLOW = "Can't wait! Seriously, florp."
	DESCRIBE.POLARICE_PLOW_ITEM = "Want to see the deep fishes!"
	DESCRIBE.TOWER_POLAR_FLAG = "Hee-hee, is little flying fish."
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Is emblem of Mermfolk kingdom now, flort."
	DESCRIBE.RAINOMETER.POLARSTORM = "Something coming but it not rain..."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Glurph! What that mean?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Glurr- tonguh-- stuuucc!"
	DESCRIBE.ICELETTUCE = "Is icy-cream growing in ground?!"
	DESCRIBE.ICEBURRITO = "Huh? Gluurrgh... poor fish in it."
	DESCRIBE.POLARCRABLEGS = "Want to eat all lemon slices!"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Ooooooooooooo!"
	DESCRIBE.BLUEGEM_SHARDS = "Glorp, can put them back together?"
	DESCRIBE.EMPEROR_EGG = "Left shiny behind!"
	DESCRIBE.MOOSE_POLAR_ANTLER = "Me did do it. Sorry."
	DESCRIBE.POLAR_DRYICE = "Why this ice not Eddy-bluh?"
	DESCRIBE.POLARBEARFUR = "Me could eat it as revenge... but won't."
	DESCRIBE.POLARWARGSTOOTH = "Want some like that too, florp!"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Tree dropped this, but me keep it."
	DESCRIBE.ARMORPOLAR = "Turned Mermfolk enemies into shirt!"
	DESCRIBE.COMPASS_POLAR = "Metal fishie want me go this way."
	DESCRIBE.EMPEROR_PENGUINHAT = "Glurp... should release poor fishies in water."
	DESCRIBE.FROSTWALKERAMULET = "Close enough from swimming, flort."
	DESCRIBE.ICICLESTAFF = "Makes super heavy rain drops."
	DESCRIBE.POLAR_SPEAR = "But, Wicker-lady said not to play with food?"
	DESCRIBE.POLARAMULET = "Yay! Dead folk make me fancy!"
	DESCRIBE.POLARBEARHAT = "Not funny."
	DESCRIBE.POLARCROWNHAT = "Wurt rules all over sea of snow!!"
	DESCRIBE.POLARFLEA_SACK = "Guess they friends now, flort."
	DESCRIBE.POLARICESTAFF = "Got all of winter in a stick, florp."
	DESCRIBE.POLARMOOSEHAT = "Hee-hee, got your hat pbbbth!"
	DESCRIBE.WINTERS_FISTS = "Snow is weapon? Me been eating weapons all that time!"
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "Ooooh, fishie! Clown man has fun games!"
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Haha! Winter trapped inside!",
		INUSE = "G-glurp! Didn't do it!",
		REFUEL = "Uh oh. Winter escaped?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Will free you, don't move!"
	DESCRIBE.POLARICEPACK = "Tada! Made a friend for chilly box."
	DESCRIBE.POLARTRINKET_1 = "Weirder tiny man."
	DESCRIBE.POLARTRINKET_2 = "Weirder tiny lady."
	DESCRIBE.TRAP_POLARTEETH = "And now me watch. Hee-hee!"
	DESCRIBE.TURF_POLAR_CAVES = "Ground bit."
	DESCRIBE.TURF_POLAR_DRYICE = "Make ground walk-ier!"
	DESCRIBE.WALL_POLAR = "Brrr... don't want to live in ice castle!"
	DESCRIBE.WALL_POLAR_ITEM = "Will make big ice castle, flort."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Want to keep it!"
	DESCRIBE.WX78MODULE_NAUGHTY = "Crunchy."