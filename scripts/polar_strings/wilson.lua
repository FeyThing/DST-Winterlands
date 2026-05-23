local ANNOUNCE = STRINGS.CHARACTERS.GENERIC
local DESCRIBE = STRINGS.CHARACTERS.GENERIC.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "Things are getting feathery!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "This may bear consequences."
	ANNOUNCE.BATTLECRY.WALRUS = "You've made a big blubber coming here!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "I knew something felt off... fishy even."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Trust me... this is... a shortcut.",
		"Hngh...",
		"Huff...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "I hereby declare a new era of cool-headed leadership!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Quakes and shivers- what just happened?!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "AHHHH-- Help!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Ice should try somewhere else."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Huh. That wasn't so bad."
	
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {"only_used_by_wx78"}
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {"only_used_by_wx78"}
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "My tracking senses feel... unusually precise."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Back to ordinary observation."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Brrr...! This is snow joke!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "I'm dry. But only in terms of snow."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_WANDATIMEFREEZE = "only_used_by_wanda"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_WANDATIMEFREEZE = "only_used_by_wanda"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "I won't say no to a fire.",
		BURNT = "It contrasts a lot with the rest of the place.",
		CHOPPED = "Better vamoose before the other trees notice.",
		GENERIC = "This tree is axing for a fight.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "A frozen baby tree."
	DESCRIBE.FLOWER_POLAR = "I'm sure it smells nice but my nose's a bit runny."
	DESCRIBE.ICELETTUCE_SEEDS = "It's some seeds."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Did it move just now?"
	DESCRIBE.POLAR_ICICLE_ROCK = "Yeah, it definitely moved."
	DESCRIBE.ROCK_POLAR = "Gems fresh for harvest."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "I think I saw something in here."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "I've got the sinking feeling this hole isn't finished yet." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Subtlety clearly wasn't in their blueprints.",
		PENGUIN = "Drat! Snowballista!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "It defies all known science."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Could we arrange a court appointment?",
		HOSTILE = "He's got home-ice advantage!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Looks pecky."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "There's fun for the whole family."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "It moose be tough to cope with antler loss.",
		GENERIC = "I'd rather stay clear from its path.",
	}
	DESCRIBE.MOOSE_SPECTER = "Seems the local legends were true."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Those eyes would be worth a fortune!"
	DESCRIBE.POLARBEAR = {
		DEAD = "A pile of snow... no, wait.",
		ENRAGED = "He's got as much bark as bite!",
		FOLLOWER = "That's my bear buddy.",
		GENERIC = "A fearsome, cuddly looking guy.",
	}
	DESCRIBE.POLARBEARKING = "Science says rumors about him."
	DESCRIBE.POLARFLEA = {
		GENERIC = "Time to flea!",
		HELD_INV = "The mandibles are already quite far under my skin.",
		HELD_BACKPACK = "I'm positive this whole idea will go well.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "She looks quite upset! I wonder why."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Let's play a small game.",
		FRIEND = "He's got a familiar face. Look like I do too.",
		GENERIC = "Aha! Come here!",
	}
	DESCRIBE.POLARWARG = "The cold must be trivial with fur like his."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "This anatomy model isn't all that insightful."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Impressive coordination, for someone with flippers!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "I guess art can be used to assert one's dominance."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Pretty sure I saw a statue of Maxwell just like that..."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "A pocket sized firepit.",
		ON = "Too hot to go in my pockets now. Unless I quench the flame.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Science says everything is better when portable."
	DESCRIBE.POLAR_THRONE = "Looks comfy."
	DESCRIBE.POLAR_THRONE_GIFTS = "Is that my name? I can't tell with that clawwriting."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "It's a mystery how this shack holds together.",
		OPEN = "Er, my mistake. Wrong address.",
	}
	DESCRIBE.POLARBEAR_RUG = "He's just a big softie, now."
	DESCRIBE.POLARBEARHEAD = "I wouldn't mess with a bear, or the one who killed it."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Holy mackerel!",
		GENERIC = "I doubt it's much warmer in there.",
	}
	DESCRIBE.POLARHEADSTICK = "I hope I'm not getting ahead of myself..."
	DESCRIBE.POLARICE_PLOW = "I'm deeply intrigued about what's under."
	DESCRIBE.POLARICE_PLOW_ITEM = "The best fish is always the one hiding."
	DESCRIBE.POLARWALRUSHEAD = "Nothing personal of course. (Ahem!)"
	DESCRIBE.TOWER_POLAR_FLAG = "Do I need to know where the wind goes?"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Perfect timing, I needed a tissue!"
	DESCRIBE.RAINOMETER.POLARSTORM = "Must be that climate change thing I've heard about."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Is it trying to warn me of something?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Carbon dioxide flavor is hard to best."
	DESCRIBE.FILET_O_FLEA = "Hmm. Has anyone ordered a bug-er?"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Scien-tea-fically speaking, they tastes better."
	DESCRIBE.ICELETTUCE = "That's a little too much seasoning."
	DESCRIBE.ICELETTUCE_OVERSIZED = "This one knows to dress to impress!"
	DESCRIBE.ICEBURRITO = "I really dig that name."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Smoked and fried aliments is chemistry at its best."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Smoked and fried aliments is chemistry at its best."
	DESCRIBE.POLARCRABLEGS = "The good thing about having ten legs, is that there's enough for everyone."
	DESCRIBE.POLARFLEAEGGSACK = "Looks like jellybeans."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "I take it back. THIS sparkles with cold energy!"
	DESCRIBE.BLUEGEM_SHARDS = "A puzzle of mineralogical intrigue."
	DESCRIBE.EMPEROR_EGG = "I don't think it'd hatch. Just melt."
	DESCRIBE.MOOSE_POLAR_ANTLER = "This thing's heavy!"
	DESCRIBE.PETALS_POLAR = "Botany suggests these may have medicinal applications."
	DESCRIBE.PETALS_POLAR_DRIED = "Nice dry."
	DESCRIBE.POLAR_DRYICE = "I could build something reeeally cool with that."
	DESCRIBE.POLARBEARFUR = "It's snuggy. Fur real!"
	DESCRIBE.POLARWARGSTOOTH = "It's sharper!"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Science says this stick is perfect."
	DESCRIBE.ARMORPOLAR = "That's the stuff!"
	DESCRIBE.COMPASS_POLAR = "Am I getting warmer?"
	DESCRIBE.EMPEROR_PENGUINHAT = "Refrigerated regal."
	DESCRIBE.FLOWER_POLARHAT = "I'm feeling like doing some questionable experiences."
	DESCRIBE.FROSTWALKERAMULET = "Science can explain this phenomenon... but I won't."
	DESCRIBE.ICICLESTAFF = "Always useful. If we forget about the \"incident\"."
	DESCRIBE.POLAR_SPEAR = "That's one big pokesicle!"
	DESCRIBE.POLARAMULET = "It's doing... things, most certainly."
	DESCRIBE.POLARBEARHAT = "Getting eaten has its perks."
	DESCRIBE.POLARCROWNHAT = "And what protects me from the brain freeze?"
	DESCRIBE.POLARFLEA_SACK = "To fill with bite-sized allies."
	DESCRIBE.POLARICESTAFF = "I like all my staves but this one is frost among equals."
	DESCRIBE.POLARMOOSEHAT = "Quite the articstic headpiece."
	DESCRIBE.WALRUS_BAGPIPE = "Welcome to MacTusk N' WilSon hunting party."
	DESCRIBE.WALRUS_BEARTRAP = "Good thing I'm not a bear!"
	DESCRIBE.WINTERS_FISTS = "Packed ice for packing a punch."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "All I got to do is act natural."
	DESCRIBE.BOAT_ICE_ITEM = "These are just good to get a-round."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "I bet there's a lot of interesting science inside.",
		RECHARGING = "It's doing \"time stuff\", that's the technical term.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "It's still going.",
		INUSE = "Let's not do this again!",
		REFUEL = "Where did the snow go?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "That's a fish cube."
	DESCRIBE.POLARICEPACK = "Alas, it won't preserve me any better."
	DESCRIBE.POLARTRINKET_1 = "An artifact steeped in wintry legends, surely."
	DESCRIBE.POLARTRINKET_2 = "An artifact steeped in wintry legends, surely."
	DESCRIBE.TRAP_POLARTEETH = "Now that's a cold reception..."
	DESCRIBE.TURF_POLAR_CAVES = "Yet another cave type."
	DESCRIBE.TURF_POLAR_DRYICE = "Tougher than most ice around here."
	DESCRIBE.TURF_POLAR_GRASS = "A chunk of ground."
	DESCRIBE.WALL_POLAR = "I feel so safe and cold within those."
	DESCRIBE.WALL_POLAR_ITEM = "Useful to keep one's cool."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "This one should spruce up the tree just right."
	DESCRIBE.WX78MODULE_NAUGHTY = "So much science packed into one tiny gizmo."