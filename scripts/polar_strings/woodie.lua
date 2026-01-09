local ANNOUNCE = STRINGS.CHARACTERS.WOODIE
local DESCRIBE = STRINGS.CHARACTERS.WOODIE.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "Ya get what ya deserve!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "Rrraaargh!"
	ANNOUNCE.BATTLECRY.WALRUS = "Hunting season's over, for you!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Eh? Oh, c'mon Luce... you could've told me."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"I'm used... to this...",
		"Grrmmmph...",
		"It's just a bit of snow...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "That's right! And don't come back, eh!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Guess we'll need more firewood, eh?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "Hnff! It's got tongue!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "I know a better spot."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Hoo! Lucy, you shouldn't have-"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "I feel like my nose's tuned ta beast mode."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "My nose's all stuffy again."
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
	DESCRIBE.ANTLER_TREE_SAPLING = "Looks like we'll have firewood soon!"
	DESCRIBE.ICELETTUCE_SEEDS = "Maybe I could plant them?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "They get bigger here than over the ol' cabin."
	DESCRIBE.POLAR_ICICLE_ROCK = "It won't get any lower, eh?"
	DESCRIBE.ROCK_POLAR = "Lick it, and you're stuck for good."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "I know a {name} when I see one."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Think we have some time before that opens up, eh?" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Good view from up here, eh?",
		PENGUIN = "I thought that wasn't snow for a sec.",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Lucky it's not hailing, eh?"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Fine ice rink you got there.",
		HOSTILE = "Down with the monarchy!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "These birds are up to something..."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "I don't like the sound of that..."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Hmph, amateur. Lemme show you how it's done.",
		GENERIC = "Big, bold, and proud of his woods like I am!",
	}
	DESCRIBE.MOOSE_SPECTER = "Can I do that too?"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Has anyone told ya you got pretty eyes, eh?"
	DESCRIBE.POLARBEAR = {
		DEAD = "You would make a fine rug.",
		ENRAGED = "Now we're fightin'!",
		FOLLOWER = "Always down for a fishing trip, eh?",
		GENERIC = "Sounds like someone got a little cold.",
	}
	DESCRIBE.POLARBEARKING = "They say trees fall when he looks their way. Eh. Sure."
	DESCRIBE.POLARFLEA = {
		GENERIC = "Yuck!",
		HELD_INV = "Get outta my hairs and feathers!",
		HELD_BACKPACK = "They ain't so bad when you get to know them.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "I say we chop this monstrosity down, eh?"
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Go get'em birds!",
		FRIEND = "That's my old chum.",
		GENERIC = "A rare sight even up in the North.",
	}
	DESCRIBE.POLARWARG = "It could pull a sled on its own."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Whatcha mean \"examine\"? I can see it from here!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "I don't have coulrophobia but... eh. You know?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "All these statues are givin' me goosebumps."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Got the feeling it moves when I ain't lookin'..."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Just needs some kindling.",
		ON = "Steady now...",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Isn't that nice, eh?"
	DESCRIBE.POLAR_THRONE = "Is that made of... charcoal?"
	DESCRIBE.POLAR_THRONE_GIFTS = "Seems we behaved quite well."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "I'm very offended.",
		OPEN = "I don't need your curses.",
	}
	DESCRIBE.POLARBEARHEAD = "Creepy, but also kinda impressive yknow?"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Guess it was only built to withstand the cold.",
		GENERIC = "I used to say: you live in what you eat, eh?",
	}
	DESCRIBE.POLARHEADSTICK = "Sure wish it would stay empty."
	DESCRIBE.POLARICE_PLOW = "Should be a good spot!"
	DESCRIBE.POLARICE_PLOW_ITEM = "Less time digging is more time fishing."
	DESCRIBE.POLARWALRUSHEAD = "The track ends here."
	DESCRIBE.TOWER_POLAR_FLAG = "Nice breeze catcher, that."
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Down with the feathery empire."
	DESCRIBE.RAINOMETER.POLARSTORM = "This might be serious..."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Oh, don't be such a baby."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "I actually prefer ice cream in winter, yup."
	DESCRIBE.FILET_O_FLEA = "That'll teach you goin' in places you shouldn't, eh."
	DESCRIBE.ICELETTUCE = "Like biting ice cubes in a drink."
	DESCRIBE.ICELETTUCE_OVERSIZED = "Didn't think you had it in you, buddy."
	DESCRIBE.ICEBURRITO = "It's better to eat fresh."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "I'm game for another hunt after this."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "I'm game for another hunt after this."
	DESCRIBE.POLARCRABLEGS = "Yer doing a fine job at cracking 'em, Luce."
	DESCRIBE.POLARFLEAEGGSACK = "...Looks tasty. Eh? Who said that?"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "It's impossibly cold."
	DESCRIBE.BLUEGEM_SHARDS = "Lucy is more the type to do puzzles than I am."
	DESCRIBE.EMPEROR_EGG = "And, uh, what do I do with that?"
	DESCRIBE.MOOSE_POLAR_ANTLER = "That would look good over a fireplace."
	DESCRIBE.POLAR_DRYICE = "Building blocks for the cool kids."
	DESCRIBE.POLARBEARFUR = "I should stuff my plaid with it."
	DESCRIBE.POLARWARGSTOOTH = "My jaw hurts just by staring at it..."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "I'll just take that, eh!"
	DESCRIBE.ARMORPOLAR = "Yup. I'm good in here."
	DESCRIBE.COMPASS_POLAR = "Think it's worth following it, eh?"
	DESCRIBE.EMPEROR_PENGUINHAT = "I don't want to rule over the birds. I want them to get lost."
	DESCRIBE.FROSTWALKERAMULET = "To turn the ocean into one giant hockey field."
	DESCRIBE.ICICLESTAFF = "That will mess you up more than a whole falling tree."
	DESCRIBE.POLAR_SPEAR = "Ice suppose that would hurt a little."
	DESCRIBE.POLARAMULET = "How wild do I look with it, eh?"
	DESCRIBE.POLARBEARHAT = "That will have to do for now."
	DESCRIBE.POLARCROWNHAT = "I can see myself wearing this one, actually."
	DESCRIBE.POLARFLEA_SACK = "They're my bugs now."
	DESCRIBE.POLARICESTAFF = "Makes me feel right at home, eh."
	DESCRIBE.POLARMOOSEHAT = "That's more my kind of headwear!"
	DESCRIBE.WALRUS_BAGPIPE = "I'll give 'er a go."
	DESCRIBE.WALRUS_BEARTRAP = "Careful 'round that. It can take a toe clean off!"
	DESCRIBE.WINTERS_FISTS = "I do like to keep some snow at hand."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "I gotta find the perfect back..."
	DESCRIBE.BOAT_ICE_ITEM = "I merely remember making the joke, I didn't mean it."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "That's a pretty fancy lookin' clock.",
		RECHARGING = "Doesn't look like it's doing much right now.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "I kinda want to go in here, eh.",
		INUSE = "C'mon, I didn't mean it seriously.",
		REFUEL = "No snow on the horizon.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Not as gratifying as reeling it by yourself..."
	DESCRIBE.POLARICEPACK = "Who needs an electric freezer when you have this?"
	DESCRIBE.POLARTRINKET_1 = "Warly would like that scarf."
	DESCRIBE.POLARTRINKET_2 = "Eh? Oh, it's just that she looks like family, a bit."
	DESCRIBE.TRAP_POLARTEETH = "It's one step further in trickery."
	DESCRIBE.TURF_POLAR_CAVES = "Just more ground, eh?"
	DESCRIBE.TURF_POLAR_DRYICE = "Now to find ice skates in here..."
	DESCRIBE.WALL_POLAR = "Anyone's feelin' like breaking the ice?"
	DESCRIBE.WALL_POLAR_ITEM = "How aboot we build some igloo, eh Lucy?"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "That one's perfect."
	DESCRIBE.WX78MODULE_NAUGHTY = "Some fancy robot bits."