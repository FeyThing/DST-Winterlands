local ANNOUNCE = STRINGS.CHARACTERS.WEBBER
local DESCRIBE = STRINGS.CHARACTERS.WEBBER.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "Hey! No pecking!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "It's past your hibernation time!"
	ANNOUNCE.BATTLECRY.WALRUS = "This trail is ours!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "What? How? WHO?"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Are we... going circles?",
		"Hello...? Is anyone here?",
		"We don't want to loose our friends in the snow...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "It goes to show, birds are no match to us!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "The ground wobbled like jelly!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "Alright, alright, you win!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Too risky here."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Well that's quite nice-"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "We can smell everything now! And ew..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Oh. The air doesn't smell like poo anymore."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Mom would be upset if she saw me like this..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Can we go play in snow again... but with a coat?"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Very daunting!",
		BURNT = "It will probably snap soon.",
		CHOPPED = "Uh oh, it lost a fight.",
		GENERIC = "Mooses don't like them. But we think they're nice.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "We almost missed it in all this snow..."
	DESCRIBE.ICELETTUCE_SEEDS = "We could grow something with these."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "We better watch out."
	DESCRIBE.POLAR_ICICLE_ROCK = "Mean little ice."
	DESCRIBE.ROCK_POLAR = "What an ice find!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "We saw something! But what?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "We can't go deeper yet, maybe later?" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "We'd be careful not to slip while up here.",
		PENGUIN = "Hey! Not the face!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Doubt that one would melt on our tongue."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "We've got a big army too! But the castle is still in the work...",
		HOSTILE = "Let's see which is best, okay?",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "We didn't steal any egg! Promise!"
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "She seems right in her flippers."
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "It bumped its head! Poor moosey...",
		ANTLER_LOST = "They're much bigger than what we imagined!",
	}
	DESCRIBE.MOOSE_SPECTER = "It looks spooky a bit..."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "We fished a treasure from the depths!"
	DESCRIBE.POLARBEAR = {
		DEAD = "Ew... it's covered in fleas.",
		ENRAGED = "Sorry! Sorry!",
		FOLLOWER = "We've got a big Teddy!",
		GENERIC = "Are we welcome in your little town?",
	}
	DESCRIBE.POLARBEARKING = "Others told us he turned summer into a carpet."
	DESCRIBE.POLARFLEA = {
		GENERIC = "Yikes!",
		HELD_INV = "Next time, we keep our pockets shut!",
		HELD_BACKPACK = "Mum always said no bugs in the schoolbag...",
	}
	DESCRIBE.POLARFLEA_MOTHER = "AHHHHHHH! Oh-- that must be how others feel about our queen!"
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Wanna make angels in the snow?",
		FRIEND = "It remembers us!",
		GENERIC = "I bet it's hungry.",
	}
	DESCRIBE.POLARWARG = "Who knew the yeti had a puppy?"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Oh. We should look away. Right?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Who juggles best between the emperor, Wes, and Wolfgang?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "He's also king of showoffs."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Too bad statues can't dance!"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Is it on? We can't see from down here!",
		ON = "Aaah, we needed this!",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Anywhere can be home."
	DESCRIBE.POLAR_THRONE = "It's quite the climb."
	DESCRIBE.POLAR_THRONE_GIFTS = "For... -W. That gotta be us!"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Looks like the cabin Walter described around the fire!",
		OPEN = "Can you stop looking at our fangs?",
	}
	DESCRIBE.POLARBEAR_RUG = "It would make a great bed if it was a bit more stuffed."
	DESCRIBE.POLARBEARHEAD = "What did it do to deserve this?"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Rest in peace... to the spider on the ceiling.",
		GENERIC = "We would be better indoor than outhere.",
	}
	DESCRIBE.POLARHEADSTICK = "It's almost creepier empty."
	DESCRIBE.POLARICE_PLOW = "We should move back, don't want to see the fish from TOO close."
	DESCRIBE.POLARICE_PLOW_ITEM = "A machine to free the fish from the ice."
	DESCRIBE.POLARWALRUSHEAD = "It kind of deserved it."
	DESCRIBE.TOWER_POLAR_FLAG = "Let's wave back at it!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "So... is it our empire now?"
	DESCRIBE.RAINOMETER.POLARSTORM = "Shouldn't we tell the others about this?"
	DESCRIBE.WINTEROMETER.POLARSTORM = "Is something wrong, Mr. Thermal Measurer?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "It won't drop even if we hold it upside down!"
	DESCRIBE.FILET_O_FLEA = "Not bad... a bit fleecy though."
	DESCRIBE.ICELETTUCE = "Eat our greens? But it's all blue."
	DESCRIBE.ICELETTUCE_OVERSIZED = "Hooray! Wait. We're eating salad all week now? Not hooray."
	DESCRIBE.ICEBURRITO = "Legend says this burrito never falls apart!"
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "No wonder walruses are all chubby."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "No wonder walruses are all chubby."
	DESCRIBE.POLARCRABLEGS = "It got more legs than us to share!"
	DESCRIBE.POLARFLEAEGGSACK = "It's healthier over his candies, I think."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Glittery-er and cooler!"
	DESCRIBE.BLUEGEM_SHARDS = "Maybe we could have been more careful."
	DESCRIBE.EMPEROR_EGG = "So they left the kids behind? Just like that?"
	DESCRIBE.MOOSE_POLAR_ANTLER = "We got your horns! And... life, besides."
	DESCRIBE.POLAR_DRYICE = "Those are ruled out in snowball fights."
	DESCRIBE.POLARBEARFUR = "We've got ourselves a pillow."
	DESCRIBE.POLARWARGSTOOTH = "It sure is sharper than ours."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "After all these years... the perfect stick!"
	DESCRIBE.ARMORPOLAR = "We would like to wear it furever."
	DESCRIBE.COMPASS_POLAR = "It's having a hard time figuring the way."
	DESCRIBE.EMPEROR_PENGUINHAT = "Does that mean we won?"
	DESCRIBE.FROSTWALKERAMULET = "Better to have cold legs than soggy."
	DESCRIBE.ICICLESTAFF = "Yikes! That looks sharp!"
	DESCRIBE.POLAR_SPEAR = "It's like a giant icicle on a stick!"
	DESCRIBE.POLARAMULET = "No spiders were harmed in the process."
	DESCRIBE.POLARBEARHAT = "RAAAWR!! Did we scare you?"
	DESCRIBE.POLARCROWNHAT = "Spiders aren't too fond of the cold."
	DESCRIBE.POLARFLEA_SACK = "To carry a whole troop on our back."
	DESCRIBE.POLARICESTAFF = "Emergency ice web."
	DESCRIBE.POLARMOOSEHAT = "A hat made of Mr. Woodie's friends."
	DESCRIBE.WALRUS_BAGPIPE = "We wanna toot it!"
	DESCRIBE.WALRUS_BEARTRAP = "Who's gonna poke it?"
	DESCRIBE.WINTERS_FISTS = "It's not too uncomfortable when you have fuzzy hands."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "It's all fools and games until it's on your back!"
	DESCRIBE.BOAT_ICE_ITEM = "We could skip across the whole ocean with enough of these."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Would we change anything if we could go back in time?",
		RECHARGING = "It's resting.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "The snow is moving, slowly. Too slowly...",
		INUSE = "Will that get me on the naughty list?",
		REFUEL = "It needs some special snow.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Let's free Willy!"
	DESCRIBE.POLARICEPACK = "It's funny to hold... f-for a while at least."
	DESCRIBE.POLARTRINKET_1 = "We want big clothes like that too!"
	DESCRIBE.POLARTRINKET_2 = "We want big clothes like that too!"
	DESCRIBE.TRAP_POLARTEETH = "Our frozen web is getting bigger."
	DESCRIBE.TURF_POLAR_CAVES = "Some ground that we dug up."
	DESCRIBE.TURF_POLAR_DRYICE = "Don't step on the cracks!"
	DESCRIBE.WALL_POLAR = "The walls of our Frosty Fort!"
	DESCRIBE.WALL_POLAR_ITEM = "First rule of the Frosty Fort: do not lick the walls."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "We like to keep it (a bit) simple."
	DESCRIBE.WX78MODULE_NAUGHTY = "Huh. Is that what robot insides look like?"