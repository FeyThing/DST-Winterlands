local ANNOUNCE = STRINGS.CHARACTERS.WARLY
local DESCRIBE = STRINGS.CHARACTERS.WARLY.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "Ooh, you tasty drumstick!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "You know what they say about selling bear fur?"
	ANNOUNCE.BATTLECRY.WALRUS = "Ah! Right as I was looking for dinner!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Alors là! I will have my revenge!"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Aller... presque...",
		"Bon sang... oof...",
		"Hrrrr...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "The king is gone! Long live the king!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Brr! Who left the freezer door open?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "Oh sa mère!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "I'd rather fish somewhere else."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Merci-- oh. I should have brought gifts too!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "The wilderness reveals its aromas to me."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Enough hunting, I'd prefer some variety."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Q-quel froid! I need a bigger coat..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Aaahhh... what would we do without fire?"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "I'd better enjoy this fire while it lasts.",
		BURNT = "Crisp, no?",
		CHOPPED = "Clashed!",
		GENERIC = "Oh! I almost ran into it.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Just a petite bébé."
	DESCRIBE.FLOWER_POLAR = "I worry they won't stay here forever."
	DESCRIBE.ICELETTUCE_SEEDS = "These will grow some nice fresh vegetables."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "My thanks for the fresh reminder."
	DESCRIBE.POLAR_ICICLE_ROCK = "How will you get back up again?"
	DESCRIBE.ROCK_POLAR = "Shall we practice ice sculpting during the extraction?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Anything edible in here?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Ça alors... it's close. Maybe another time?" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "A whole ice castle? I got to respect that.",
		PENGUIN = "I bet his meatball game is strong!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Maybe venturing out there wasn't all bad!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Are they hosting a banquet, or a banquise?",
		HOSTILE = "Ah, are we overthrowing the monarchy now?",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Guess I'll find eggs someplace else..."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Not too happy to make your acquaintance, madame."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "It lost its garnish.",
		GENERIC = "A grand beast sure to yield robust, gamey flavors.",
	}
	DESCRIBE.MOOSE_SPECTER = "Mon dieu, it looks simply exquisite!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Poisson frais!"
	DESCRIBE.POLARBEAR = {
		DEAD = "I can finally sell its fur.",
		ENRAGED = "It's hungry for a fight!",
		FOLLOWER = "It got quite the insatiable appetite.",
		GENERIC = "We're both eager to find out how the other taste like\n... or is it just me?",
	}
	DESCRIBE.POLARBEARKING = "They say he eat meat without chewing... I think I'm about to faint."
	DESCRIBE.POLARFLEA = {
		GENERIC = "Oh non!",
		HELD_INV = "Bon appétit, and adieu!",
		HELD_BACKPACK = "I believe they're hibernating.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "To each their own Maman..."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "You simply can't say non to a good meal, non?",
		FRIEND = "What say you for a meal like old times?",
		GENERIC = "A cunning little renard.",
	}
	DESCRIBE.POLARWARG = "I'm all shivery, and it's not just the cold..."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Presentation is half the taste, n'est-ce pas?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "I've exerced juggling a little myself. Not with food, mind you!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "It's a bold serving of ego."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "It's all very nice. But... when do we eat?"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Could use some twigs.",
		ON = "Et voilà!",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "A good addition to my portable kitchen."
	DESCRIBE.POLAR_THRONE = "I won't sit at a throne without table."
	DESCRIBE.POLAR_THRONE_GIFTS = "I mean... I've been nice this year, non?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Must be a veritable boucherie inside...",
		OPEN = "You can have what I don't plan on cooking.",
	}
	DESCRIBE.POLARBEAR_RUG = "It belongs in a banquet room."
	DESCRIBE.POLARBEARHEAD = "What a waste of -- I mean what a shame, a real shame."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Thought I smelled sardines.",
		GENERIC = "Would that really withstand a snowstorm?",
	}
	DESCRIBE.POLARHEADSTICK = "This seat is reserved."
	DESCRIBE.POLARICE_PLOW = "I hope I brought enough bait..."
	DESCRIBE.POLARICE_PLOW_ITEM = "A day of ice fishing sounds tempting!"
	DESCRIBE.POLARWALRUSHEAD = "He doesn't move as fast as I'd think anymore."
	DESCRIBE.TOWER_POLAR_FLAG = "Watching it float like that makes me hungry... what?"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "I suppose they won't return to pick it up?"
	DESCRIBE.RAINOMETER.POLARSTORM = "Something's cooking..."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Would you like a coat?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Ice cream for the cool kids!"
	DESCRIBE.FILET_O_FLEA = "The secret ingredient is a dash of shame."
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "I said \"poisson frais\" ma'am, not... ah well."
	DESCRIBE.ICELETTUCE = "Brr... could use dressing..."
	DESCRIBE.ICELETTUCE_OVERSIZED = "Ça alors, it's a huge salade!"
	DESCRIBE.ICEBURRITO = "This is the last time I rely on Wilson to name my recipes."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Ooh la la, this hunters' cookbook holds treasures!"
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Ooh la la, this hunters' cookbook holds treasures!"
	DESCRIBE.POLARCRABLEGS = "Mwah! Simplement par-fait!"
	DESCRIBE.POLARFLEAEGGSACK = "Looks like... hold the pot -- I have an idea!"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Oh my, that is too cold for my taste!"
	DESCRIBE.BLUEGEM_SHARDS = "Could use a bit of glue."
	DESCRIBE.EMPEROR_EGG = "Now that's a culinarius- er, curious find."
	DESCRIBE.MOOSE_POLAR_ANTLER = "I was more looking forward to try the meat."
	DESCRIBE.PETALS_POLAR = "Could use some taste test."
	DESCRIBE.PETALS_POLAR_DRIED = "A fine ingredient!"
	DESCRIBE.POLAR_DRYICE = "What big ice cubes!"
	DESCRIBE.POLARBEARFUR = "The coziest of snowballs."
	DESCRIBE.POLARWARGSTOOTH = "That would leave a dent."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Salut, vieille branche!"
	DESCRIBE.ARMORPOLAR = "Some furry protection."
	DESCRIBE.COMPASS_POLAR = "Show me the way to the freezer, please."
	DESCRIBE.EMPEROR_PENGUINHAT = "I'm not one to dislike fish. However..."
	DESCRIBE.FLOWER_POLARHAT = "I can't taste or smell anything anymore... please! Take it away!"
	DESCRIBE.FROSTWALKERAMULET = "This takes frosting to the next level!"
	DESCRIBE.ICICLESTAFF = "Il pleut il mouille? No, it kills!"
	DESCRIBE.POLAR_SPEAR = "It's all fun until it starts dripping."
	DESCRIBE.POLARAMULET = "You wouldn't want to be around when I get my fangs out."
	DESCRIBE.POLARBEARHAT = "Is that how my food sees before being eaten?"
	DESCRIBE.POLARCROWNHAT = "Was anyone afraid I'd finally lose my cool?"
	DESCRIBE.POLARFLEA_SACK = "Better inside than on my skin."
	DESCRIBE.POLARICESTAFF = "Pardon, but I need to breathe some fresh air."
	DESCRIBE.POLARMOOSEHAT = "There better be no vinous hunter in these parts."
	DESCRIBE.WALRUS_BAGPIPE = "Bon dieu, my ears!"
	DESCRIBE.WALRUS_BEARTRAP = "A trap eager to make a mouthful of me."
	DESCRIBE.WINTERS_FISTS = "Now I'm seriously offhanded..."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "A classic, harmless prank! Or at least it should be..."
	DESCRIBE.BOAT_ICE_ITEM = "Anything to stay a-flotte."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Maybe I could ask her to make me a kitchen timer...",
		RECHARGING = "I don't think it's ready just yet.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "This makes for a good feasting table decoration.",
		INUSE = "Well. I'd better prep some soup for everyone.",
		REFUEL = "Ah non! You aren't getting your snow back.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "There's no questioning its freshness."
	DESCRIBE.POLARICEPACK = "Some fortification against my worst enemy."
	DESCRIBE.POLARTRINKET_1 = "Were there flowers growing in your snowy garden?"
	DESCRIBE.POLARTRINKET_2 = "I take it your lawn wasn't green all year round."
	DESCRIBE.TRAP_POLARTEETH = "Grips like a fork, cuts like a butcher knife."
	DESCRIBE.TURF_POLAR_CAVES = "It's like an ingredient for the ground."
	DESCRIBE.TURF_POLAR_DRYICE = "It's like an ingredient for the ground."
	DESCRIBE.TURF_POLAR_GRASS = "Will I need to cut this?"
	DESCRIBE.WALL_POLAR = "Aaah. Isn't that ice?"
	DESCRIBE.WALL_POLAR_ITEM = "I trust it won't melt anytime soon."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Frosting for our festive tree."
	DESCRIBE.WX78MODULE_NAUGHTY = "Now that is just too much zest for one mouth. Or speaker, I don't know."