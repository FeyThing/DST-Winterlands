local ANNOUNCE = STRINGS.CHARACTERS.WALTER
local DESCRIBE = STRINGS.CHARACTERS.WALTER.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "I'll be fine, they're fightless birds."
	ANNOUNCE.BATTLECRY.POLARBEAR = "Watch Woby! I'm fighting a big, scary bear!"
	ANNOUNCE.BATTLECRY.WALRUS = "Ha! You feel right into my trap!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Darnit... they can't keep getting away with it!"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Wobes! Where- ah, there you are!",
		"We should head North... no, South!",
		"Brrr...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "Guess that's my ice castle now!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "That was... cool! Chilly even!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "Hang on! Bugs can catch humans too?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Let's try somewhere more stable."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Neat! Almost what I wanted."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Sniff, sniff... can you smell this, Woby? Cause I do!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "You know. I kind of miss old school hunting."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "T-that demands for a-adequate clothing...!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "My hairs are thawed out at least."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "A tree on fire? Here? Of all places?",
		BURNT = "Huh. Well I wonder how that happened.",
		CHOPPED = "The axe won the clash.",
		GENERIC = "The specter m- ah, it's a tree. Still cool though.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Aww, you're so small!"
	DESCRIBE.ICELETTUCE_SEEDS = "Where should we plant them, Woby?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "I wonder when it will fall."
	DESCRIBE.POLAR_ICICLE_ROCK = "Woah! Did you see it fall?"
	DESCRIBE.ROCK_POLAR = "Look at how many Wobies there's in it!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Huh? Woby... what's in here?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "What's that...? \"Work in... progress\"-- Haha, that handwritting is awful!" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Would they let us go on top if we ask?",
		PENGUIN = "Your Majesty could use some target practice!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "The abominable snowflake! I finally found it!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Seems to me he's just a big show-off.",
		HOSTILE = "Uh oh... I think we just started a war, Woby.",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Think a whole regiment could take down a Deerclops?"
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Hey, no littering!"
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "How it lost its antlers? Well it's a tragic tale, really.",
		GENERIC = "Hm. Not too mysterious looking! But maybe if it was white and hiding in a blizzard...",
	}
	DESCRIBE.MOOSE_SPECTER = "I-I knew! I knew it... all along! Haha!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Hey, look at those creepy eyes!"
	DESCRIBE.POLARBEAR = {
		DEAD = "Sir? Sir I think you need our help!",
		ENRAGED = "What big fangs you have!",
		FOLLOWER = "You're easier to tame than they said on that radio show.",
		GENERIC = "I was right. Those three dark dots were, in fact, a polar bear."
	}
	DESCRIBE.POLARBEARKING = "They say he sold the bear fur before hunting it. Woah... can you believe that?!"
	DESCRIBE.POLARFLEA = {
		GENERIC = "Look at this-- uh, THESE cool bugs!",
		HELD_INV = "My handbook says... that it's too late to remove it.",
		HELD_BACKPACK = "Nothing can stop me and my bugs!",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Gee Wobers! Remind me to brush you after this."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "I think he likes us!",
		FRIEND = "He could use another snack.",
		GENERIC = "Get'em, girl!",
	}
	DESCRIBE.POLARWARG = "The poor thing must be lost."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "So that's what they call art? Huh."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "What's wrong, Wobers? She can't stop staring at it!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Cool, cool. But how many badges does that make you?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "I hope it doubles as a weather vane."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "A portable pit for fire.",
		ON = "Uh... did anyone bring the portable marshmallow sack?",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "One day Woby, you will transport a whole base!"
	DESCRIBE.POLAR_THRONE = "Doesn't it get boring after a while, Mr. Maxwell?"
	DESCRIBE.POLAR_THRONE_GIFTS = "Maybe they're lost."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Oooh, this gotta be that dental museum I've heard about!",
		OPEN = "Hi! Are you open to visitors?",
	}
	DESCRIBE.POLARBEARHEAD = "Is it too late to return it to its owner?"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "That's a frostburn if I ever saw one. Heh.",
		GENERIC = "You think they make furnitures out of snow?",
	}
	DESCRIBE.POLARHEADSTICK = "That's a cool stick."
	DESCRIBE.POLARICE_PLOW = "Don't worry, I know the drill."
	DESCRIBE.POLARICE_PLOW_ITEM = "Maybe Woby could locate the fish by smell?"
	DESCRIBE.POLARWALRUSHEAD = "Darnit! I missed the monocle again!"
	DESCRIBE.TOWER_POLAR_FLAG = "In this base, we salute the flag!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "I can't say I've heard of this nation before."
	DESCRIBE.RAINOMETER.POLARSTORM = "Must be something in the air."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Ha! It's still shaking from yesterday's story."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Ice cream, sparkling water edition."
	DESCRIBE.FILET_O_FLEA = "This won't get me to quit outdoor cooking, but yikes!"
	DESCRIBE.ICELETTUCE = "Would it lettuce freeze? Get it? Because... forget it..."
	DESCRIBE.ICELETTUCE_OVERSIZED = "I knew this seed wouldn't lettuce dow- okay I'll stop now."
	DESCRIBE.ICEBURRITO = "It won't fall apart one bit."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Wow, Warly's got some serious competition with MaTusk around!"
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Wow, Warly's got some serious competition with MaTusk around!"
	DESCRIBE.POLARCRABLEGS = "Mmmm! Hey, anybody wants to listen to my crab horror stories?"
	DESCRIBE.POLARFLEAEGGSACK = "It's full of jelly, and beans."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "From a magic blue gem to... I don't know... a cursed blue gem, surely?"
	DESCRIBE.BLUEGEM_SHARDS = "I bet I can piece this mystery together."
	DESCRIBE.EMPEROR_EGG = "This thing's sturdy! Not sure how a chick could get free of it."
	DESCRIBE.MOOSE_POLAR_ANTLER = "It didn't have to come to this."
	DESCRIBE.POLAR_DRYICE = "Let's build a snow golem!"
	DESCRIBE.POLARBEARFUR = "Woah, check out all the fleas in it!"
	DESCRIBE.POLARWARGSTOOTH = "Reminds me, I'll have to brush your teeth soon, girl."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "A good stick to play fetch and... for a few other things."
	DESCRIBE.ARMORPOLAR = "Armors might as well protect from other things, heh?"
	DESCRIBE.COMPASS_POLAR = "Err... give me a sec, I just have to average where it points."
	DESCRIBE.EMPEROR_PENGUINHAT = "...Is this really indispensable to be a king? Oh well."
	DESCRIBE.FROSTWALKERAMULET = "Oh, uh... I should maybe have made a dog collar from it."
	DESCRIBE.ICICLESTAFF = "How about we sling a shot? Heh. Good one, Walter."
	DESCRIBE.POLAR_SPEAR = "Sorry Wobers, you can't have this stick."
	DESCRIBE.POLARCROWNHAT = "So, when are we building my ice castle?"
	DESCRIBE.POLARFLEA_SACK = "Better watch out while you're in range of my pocket bugs."
	DESCRIBE.POLARAMULET = "A little something from the souvenir shop."
	DESCRIBE.POLARBEARHAT = "Woby won't stop growling about it..."
	DESCRIBE.POLARICESTAFF = "I feel sorry for all the bugs around, just minding their own business."
	DESCRIBE.POLARMOOSEHAT = "Moose fur, no doubt. Did you smell it?"
	DESCRIBE.WALRUS_BAGPIPE = "Walruses'll follow this thing anywhere."
	DESCRIBE.WALRUS_BEARTRAP = "Best pick this up before someone gets hurt!"
	DESCRIBE.WINTERS_FISTS = "I aim better with my slingshot than... my own two hands."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "I didn't know that fish sticks! Heh, get it?"
	DESCRIBE.BOAT_ICE_ITEM = "Just don't slip overboard. Ha ha. That'd be pretty bad..."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Ms. Wanda sure has a lot of clocks!",
		RECHARGING = "Is that clock ticking backwards?",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Hey, shake this out!",
		INUSE = "That means... I finally got my hands on an haunted trinket!",
		REFUEL = "Where's the snow... the haunted snow?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Maybe there's a mini mammoth in it?"
	DESCRIBE.POLARICEPACK = "It won't make my jerky eternal but it's one step closer."
	DESCRIBE.POLARTRINKET_1 = "He seems ready for a snowball fight. And so am I!"
	DESCRIBE.POLARTRINKET_2 = "Wait... I know you."
	DESCRIBE.TRAP_POLARTEETH = "If this doesn't catch the Werebeaver, I quit!"
	DESCRIBE.TURF_POLAR_CAVES = "A patch of ground."
	DESCRIBE.TURF_POLAR_DRYICE = "Some road that sends shivers up my legs."
	DESCRIBE.WALL_POLAR = "This mist sets a fine spooky vibe."
	DESCRIBE.WALL_POLAR_ITEM = "Don't you dare lick it, Woby!"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Well, it match the season."
	DESCRIBE.WX78MODULE_NAUGHTY = "Robot guts! Neat!"
	