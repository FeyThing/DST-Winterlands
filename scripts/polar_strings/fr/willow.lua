local ANNOUNCE = STRINGS.CHARACTERS.WILLOW
local DESCRIBE = STRINGS.CHARACTERS.WILLOW.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Je fourrerais Bernie de ta fourrure !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Rah... pourquoi fallait-il que ce soit... de la neige.",
		"Sortez-moi de là !",
		"Hmpf...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Ah ! Je déteste déjà cet endroit !"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Ici ? De tous les endroits possibles ?"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Ça aurait pu être pire."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Beurk ! Dégagez-moi cette neige !"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Pfff, c'est mieux, mais pas plus."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "OUI ! BRÛLE !",
		BURNT = "Eeeet voilà, fini.",
		CHOPPED = "On se reverra, arbre.",
		GENERIC = "Tu ferais mieux de bien brûler.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Une graine."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Hein ?"
	DESCRIBE.POLAR_ICICLE_ROCK = "Ah ! J'aurais pu me faire empaler !"
	DESCRIBE.ROCK_POLAR = "Je peux sentir le froid émaner d'ici."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "On m'forcera pas à aller là-dedans."
	DESCRIBE.TUMBLEWEED_POLAR = "Je t'attraperai. Et j'te fondrai !"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Pfft, regarde qui a l'air encore plus stupide maintenant.",
		ANTLER = "Super, un autre genre de cerf débile.",
	}
	DESCRIBE.MOOSE_SPECTER = "Je vais avoir besoin de plus de fléchettes."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Je t'ai sorti de cet enfer gelé, de rien."
	DESCRIBE.POLARBEAR = {
		DEAD = "Ha, bien fait pour toi, l'ours.",
		ENRAGED = "Il a un tempérament vraiment enflammé !",
		FOLLOWER = "Tu mords pour moi maintenant !",
		GENERIC = "Oh, tu as l'air très inflammable.",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Oh bordel !",
		HELD = "Argh ! Enlèvez-la !",
		HELD_BACKPACK = "Hé, Wilson ! Viens secouer mon sac !",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Viens avec moi, et tu verras...",
		FRIEND = "J'avais cru t'avoir perdu !",
		GENERIC = "Hey, petit gars !",
	}
	DESCRIBE.POLARWARG = "Garde tes puces loin de moi."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Transportable le jour. Enflammé la nuit !",
		ON = "Ouiii ! Brûle ! Brûle encore !",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Ok. Ça, c'est du pur génie !"
	DESCRIBE.POLAR_THRONE = "Je connais qu'un type qui perdrait son temps assie ici. En fait, deux."
	DESCRIBE.POLAR_THRONE_GIFTS = "Ouais. Je doute qu'il y est quoi que ce soit pour moi."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Brûler cette piaule serait lui rendre service.",
		OPEN = "C'est donc à ça que ressemble la petite souris... Bon, tant pis.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ha ha ! Ta poissonnerie n'avait aucune chance !",
		GENERIC = "Arf, ça pue le poisson.",
	}
	DESCRIBE.POLARICE_PLOW = "Je vous sauverais, petits poissons !"
	DESCRIBE.POLARICE_PLOW_ITEM = "Ça craint d'être coincé sous la glace."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Warly. Écoute-moi bien."
	DESCRIBE.ICELETTUCE = "C'est genre l'opposé de bon."
	DESCRIBE.ICEBURRITO = "J'pense même pas qu'une sauce piquante puisse arranger ça."
	DESCRIBE.POLARCRABLEGS = "J'en ai jamais goûté. Je vais en prendre dix."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Argh... reste loin de moi !!"
	DESCRIBE.BLUEGEM_SHARDS = "Un plein de petits éclats bien moche."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Qu'est-ce que je vais pouvoir faire de ce bâton..."
	DESCRIBE.POLAR_DRYICE = "À quoi ça sert si je peut même pas le fondre ?"
	DESCRIBE.POLARBEARFUR = "Ça garde bien la chaleur."
	DESCRIBE.POLARWARGSTOOTH = "Il a mordu son dernier repas."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Qui laisserait du bon bois traîner comme ça ?"
	DESCRIBE.ARMORPOLAR = "Je l'enlèverai jamais ! Sauf si ça commence à schlinguer."
	DESCRIBE.FROSTWALKERAMULET = "Ouah, cool ! Enfin... c'est naze, mais c'est quand même un peu cool."
	DESCRIBE.ICICLESTAFF = "J'aurais jamais pensé me battre aux côtés de la glace."
	DESCRIBE.POLAR_SPEAR = "Garde la tête froide, si tu y tiens."
	DESCRIBE.POLARAMULET = "C'est... juste une phase."
	DESCRIBE.POLARBEARHAT = "Prends ça comme un avertissement, faut pas me chercher."
	DESCRIBE.POLARCROWNHAT = "Aïe ! Non."
	DESCRIBE.POLARFLEA_SACK = "Euhhh... c'est pourquoi faire déjà ?"
	DESCRIBE.POLARICESTAFF = "La prochaine fois on ira ailleurs...\ngenre là où je peux me trouver une Baguette infernale et tout ça !"
	DESCRIBE.POLARMOOSEHAT = "Y a une odeur de poisson et... d'autres trucs."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Quel jouet bidon.",
		INUSE = "Qui l'a secoué, et pourquoi ?!",
		REFUEL = "Et ne reviens pas !",
	}
	DESCRIBE.POLARICEPACK = "Laisse ça dans le frigo, peu importe."
	DESCRIBE.POLARTRINKET_1 = "Il semble pas beaucoup aimer le froid non plus."
	DESCRIBE.POLARTRINKET_2 = "Elle semble pas beaucoup aimer le froid non plus."
	DESCRIBE.TRAP_POLARTEETH = "Ce serait quand même mieux avec du feu."
	DESCRIBE.TURF_POLAR_CAVES = "La terre est froide et d'un ennui."
	DESCRIBE.TURF_POLAR_DRYICE = "La terre est froide et d'un ennui."
	DESCRIBE.WALL_POLAR = "Je le hais."
	DESCRIBE.WALL_POLAR_ITEM = "Peut-être que je lui laisserai une chance."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Pas vraiment mon préféré."
	DESCRIBE.WX78MODULE_NAUGHTY = "Hé, WX, quand est-ce que tu installes un lance-flammes ?"