if not STRINGS.CHARACTERS.WIRLYWINGS then
	return
end

local ANNOUNCE = STRINGS.CHARACTERS.WIRLYWINGS
local DESCRIBE = STRINGS.CHARACTERS.WIRLYWINGS.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "Waack!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "What big teeth you have!"
	ANNOUNCE.BATTLECRY.WALRUS = "MEEK! Go away! I'm not food!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Oh, well... that explains a few things."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"...Are we there yet...?",
		"Could we stop to do snow angels?",
		"Mmmmm-mm...!",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "Pfew... and don't waddle back here!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Meek! What's happening?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "MEEK! SHE GOT ME!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Wouldn't it be dangerous, here?"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Thank you very much, whoever!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Wanna play hide and seek with the forest animals?"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Where are they...? Oh well, you win!"
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Eep! Some snow's getting in my hood!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Brr... I just need a bit more clothing."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Hey at least we can warm up!",
		BURNT = "It was once white like snow itself.",
		CHOPPED = "It sure isn't, now.",
		GENERIC = "This tree looks like it was never alive.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Wow! The dead tree! It's growing back!"
	DESCRIBE.FLOWER_POLAR = "I had no idea flowers could grow here!"
	DESCRIBE.ICELETTUCE_SEEDS = "A lettuce seed."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "MEEK...! That gave me a fright!"
	DESCRIBE.POLAR_ICICLE_ROCK = "It was up there, some time ago."
	DESCRIBE.ROCK_POLAR = "It's either a mirror, or my twin sister is stuck inside. Hehe!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "It's snow. Or is it? Mmm."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "No thank you, anyway." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Wow. Waaw even.",
		PENGUIN = "How unfair! Come back down!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "C'mon! Someone! Catch it!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Hello. Mmm. Waah?",
		HOSTILE = "Don't throw me in the dungeon!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Well met, bird with the helmet."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Who's coming next? Grandpa? The goldfish?"
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Lesson learned, mm?",
		GENERIC = "They're bigger than I thought...",
	}
	DESCRIBE.MOOSE_SPECTER = "Wow. Fairy moose!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "What a pretty fish! Can we put it in a fishbowl?"
	DESCRIBE.POLARBEAR = {
		DEAD = "C'mon, wake up...",
		ENRAGED = "Meek! Watch out!",
		FOLLOWER = "We'll go fishing if you promise to not bite me. Okay?",
		GENERIC = "They look abnormally friendly.",
	}
	DESCRIBE.POLARBEARKING = "Having no enemies isn't an excuse for not having any good friends."
	DESCRIBE.POLARFLEA = {
		GENERIC = "Friend shaped. But not a friend.",
		HELD_INV = "MEEK! I'm not sharing my blood!",
		HELD_BACKPACK = "Better in here than under my hood.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Best to shut all my pockets... just in case."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Hehe! What will you find next?",
		FRIEND = "Mm! Hi there! I missed you!",
		GENERIC = "Hello- no! Don't run off, we can be friends!",
	}
	DESCRIBE.POLARWARG = "That's one big ice bomb!"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Mm. Nevermind."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "I should practice my juggling again when Wes is around."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "I want to pose for an ice statue too!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Can I get a status of myself next?"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Is that burnt fur, in the bowl?",
		ON = "Just the warmth I needed.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Poof! Now I can carry it!"
	DESCRIBE.POLAR_THRONE = "I'm not sitting here!"
	DESCRIBE.POLAR_THRONE_GIFTS = "So many presents! There must be one for me, mm?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "It must get lonely in here.",
		OPEN = "What's in store for today, Mister-y?",
	}
	DESCRIBE.POLARBEAR_RUG = "The other bears probably won't like much..."
	DESCRIBE.POLARBEARHEAD = "How rude!"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "This home has seen better days.",
		GENERIC = "This door has seen better days.",
	}
	DESCRIBE.POLARHEADSTICK = "Why not set a welcome sign instead?"
	DESCRIBE.POLARICE_PLOW = "Watch out, the ground is cracking open!"
	DESCRIBE.POLARICE_PLOW_ITEM = "What could hide under the ice?"
	DESCRIBE.POLARWALRUSHEAD = "I don't feel nearly as bad about this one, curious."
	DESCRIBE.TOWER_POLAR_FLAG = "Hehe, it's waving at me!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "I'll take you with me, before the wind does."
	DESCRIBE.RAINOMETER.POLARSTORM = "Mr. Wilson, your machine is acting weird again!"
	DESCRIBE.WINTEROMETER.POLARSTORM = "Stop it! You're making me shiver too!"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "It's so cold it burns a bit..."
	DESCRIBE.FILET_O_FLEA = "So that's where it went. Oh well!"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Best shared with an evil monster."
	DESCRIBE.ICELETTUCE = "My paper boat's worst enemy."
	DESCRIBE.ICELETTUCE_OVERSIZED = "You're welcome..."
	DESCRIBE.ICEBURRITO = "I'll try a cherrito next time."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Got your nose, in a plate."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Got your nose, in a plate."
	DESCRIBE.POLARCRABLEGS = "Mmm... crunchy... wait, no. That's shell!"
	DESCRIBE.POLARFLEAEGGSACK = "That could be ew-seful."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "VERY fancy icecube!"
	DESCRIBE.BLUEGEM_SHARDS = "I think these two pieces go together. But this one..."
	DESCRIBE.EMPEROR_EGG = "Be careful not to drop the baby."
	DESCRIBE.MOOSE_POLAR_ANTLER = "What do I even do with these?"
	DESCRIBE.PETALS_POLAR = "We had some of those growing at home."
	DESCRIBE.PETALS_POLAR_DRIED = "Tiny spices."
	DESCRIBE.POLAR_DRYICE = "It's like cut stone but, made of air?"
	DESCRIBE.POLARBEARFUR = "It's made out of coziness."
	DESCRIBE.POLARWARGSTOOTH = "A piece of that big monster's mouth."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "You can do a lot with a good stick."
	DESCRIBE.ARMORPOLAR = "Now I feel twice as safe!"
	DESCRIBE.COMPASS_POLAR = "It's not pointing toward home."
	DESCRIBE.EMPEROR_PENGUINHAT = "To dress like an empress."
	DESCRIBE.FLOWER_POLARHAT = "I'll make some for my friends too."
	DESCRIBE.FROSTWALKERAMULET = "Hope it'll last me for another walk or two."
	DESCRIBE.ICICLESTAFF = "I wouldn't go play under that rain..."
	DESCRIBE.POLAR_SPEAR = "Not a cherry flavored popsicle. It's blood on it."
	DESCRIBE.POLARAMULET = "Would you tell me what it does, Mister-y?"
	DESCRIBE.POLARBEARHAT = "Being in someone's mouth is nothing new to me."
	DESCRIBE.POLARCROWNHAT = "Don't pop my personal bubble."
	DESCRIBE.POLARFLEA_SACK = "I prefer giving them their own space over taking my own."
	DESCRIBE.POLARICESTAFF = "My stick got an upgrade!"
	DESCRIBE.POLARMOOSEHAT = "Can you see much with this, hood face?"
	DESCRIBE.WALRUS_BAGPIPE = "One, two, and one two three! (Inhale)"
	DESCRIBE.WALRUS_BEARTRAP = "Evil metal things."
	DESCRIBE.WINTERS_FISTS = "Now I can hear the wind howl as I wave..."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "A sick joke to play on friends."
	DESCRIBE.BOAT_ICE_ITEM = "This should be safe, for a few seconds."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "What a fancy clock! Very pretty, Ms. Wanda.",
		RECHARGING = "Maybe it's the wrong time for it?",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "I don't even need to shake it.",
		INUSE = "Why did we shake it?",
		REFUEL = "Now nothing wrong would happen from shaking it.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Can we help it out?"
	DESCRIBE.POLARICEPACK = "I wish it would fit in my lunch box."
	DESCRIBE.POLARTRINKET_1 = "You look snug in that scarf!"
	DESCRIBE.POLARTRINKET_2 = "You look snug in that hood!"
	DESCRIBE.TRAP_POLARTEETH = "Not a place to do snow angels."
	DESCRIBE.TURF_POLAR_CAVES = "Food for moleworms."
	DESCRIBE.TURF_POLAR_DRYICE = "Not like the road to school."
	DESCRIBE.TURF_POLAR_GRASS = "Food for plants and worms."
	DESCRIBE.WALL_POLAR = "This one might stand a chance, in tale of three pigs."
	DESCRIBE.WALL_POLAR_ITEM = "We could make some igloo, but, without a roof."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "The perfect ornament doesn- ooh!"
	DESCRIBE.WX78MODULE_NAUGHTY = "Robot candies of my metal friend."