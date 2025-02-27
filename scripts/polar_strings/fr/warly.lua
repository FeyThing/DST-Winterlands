local ANNOUNCE = STRINGS.CHARACTERS.WARLY
local DESCRIBE = STRINGS.CHARACTERS.WARLY.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Tu sais ce qu'on dit à propos de vendre la peau de l'ours ?"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Aller... presque...",
		"Bon sang... oof...",
		"Hrrrr...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Brr! Qui a laissé la porte du congélateur ouverte ?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Je préfèrerais pêcher ailleurs."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Merci, oh. J'aurais dû amener des cadeaux aussi !"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Q-quel froid ! J'ai besoin d'un plus gros manteau..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Aaahhh... que ferions nous sans feu ?"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Je ferais mieux de profiter tant que ça dure.",
		BURNT = "Croustillant, non ?",
		CHOPPED = "Ça l'a bien heurté.",
		GENERIC = "Oh! J'ai failli rentrer dedans.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Voilà qui me permettra d'obtenir de bons légumes frais."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Merci pour l'avertissement."
	DESCRIBE.POLAR_ICICLE_ROCK = "Et comment vas-tu remonter à nouveau ?"
	DESCRIBE.ROCK_POLAR = "Devrons-nous nous entraîner à la sculpture sur glace pendant l'extraction ?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Peut-être quelque chose de comestible."
	DESCRIBE.TUMBLEWEED_POLAR = "S'aventurer là-dedans n'était peut-être pas une si mauvaise idée !"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Il a perdu sa garniture.",
		ANTLER = "Cette grosse bête produira surement de bonnes saveurs robustes.",
	}
	DESCRIBE.MOOSE_SPECTER = "Mon Dieu, elle a l'air tout simplement... exquise !"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Poisson frais!"
	DESCRIBE.POLARBEAR = {
		DEAD = "Je peux enfin vendre sa fourrure.",
		ENRAGED = "Il a soif de sang !",
		FOLLOWER = "Il a un appétit insatiable.",
		GENERIC = "On veut tout les deux savoir quel goût à l'autre\n... ou c'est juste moi ?",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Oh non !",
		HELD = "Bon appétit, et adieu !",
		HELD_BACKPACK = "Je pense qu'elles hibernent là.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Tu dirais pas non a un bon repas, non ?",
		FRIEND = "Que dis-tu d'un plat comme autrefois ?",
		GENERIC = "Un petit renard rusé.",
	}
	DESCRIBE.POLARWARG = "J'en ai des frissons, et ce n'est pas dû qu'au froid..."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Ça manque d'allume-feu.",
		ON = "Et voilà !",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Une bonne addition dans ma cuisine portative."
	DESCRIBE.POLAR_THRONE = "Je ne m'assoirais pas sur un trône sans table."
	DESCRIBE.POLAR_THRONE_GIFTS = "Je veux dire... j'ai été sage cette année, non ?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Ça doit être une vrai boucherie à l'intérieur...",
		OPEN = "Tu peux avoir tout les morceaux que je ne peux pas cuire.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "J'ai cru sentir des sardines.",
		GENERIC = "Est-ce que ça résisterait vraiment à une tempête ?",
	}
	DESCRIBE.POLARICE_PLOW = "J'espère avoir pris assez d'appât..."
	DESCRIBE.POLARICE_PLOW_ITEM = "Une journée de pêche sur glace serait tentante !"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Et une crême glacée pour tout le monde !"
	DESCRIBE.ICELETTUCE = "Brr... ça manque de dressage..."
	DESCRIBE.ICEBURRITO = "C'est la dernière fois que je compte sur Wilson pour nommer mes recettes."
	DESCRIBE.POLARCRABLEGS = "Mwah! Simplement par-fait !"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Bien trop froid à mon goût !"
	DESCRIBE.BLUEGEM_SHARDS = "Ça manque de glue."
	DESCRIBE.MOOSE_POLAR_ANTLER = "J'avais plus hâte d'essayer sa viande que ça."
	DESCRIBE.POLAR_DRYICE = "C'est un bon gros glaçon !"
	DESCRIBE.POLARBEARFUR = "La plus douce des boules de neige."
	DESCRIBE.POLARWARGSTOOTH = "Ça laisserait une sacrée trace."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Salut vieille branche !"
	DESCRIBE.ARMORPOLAR = "Une protection plutôt poilu."
	DESCRIBE.FROSTWALKERAMULET = "Ça prend le glaçage à un tout autre niveau !"
	DESCRIBE.ICICLESTAFF = "Il pleut, il mouille ? Non, ça tue !"
	DESCRIBE.POLAR_SPEAR = "C'est marrant jusqu'à ce qu'elle commence à goutter."
	DESCRIBE.POLARAMULET = "Tu ne voudrais pas être autour quand je sors mes crocs."
	DESCRIBE.POLARBEARHAT = "Est-ce ainsi que mes plats vois avant d'être mangé ?"
	DESCRIBE.POLARCROWNHAT = "Quelqu'un avait-il peur que je perde enfin mon sang-froid ?"
	DESCRIBE.POLARFLEA_SACK = "Mieux à l'intérieur que sur ma peau."
	DESCRIBE.POLARICESTAFF = "Pardon, mais j'ai besoin de respirer un peu d'air frais."
	DESCRIBE.POLARMOOSEHAT = "Il vaut mieux qu'il n'y ait pas de chasseur aviné dans le coin."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Ça ferait une belle décoration de table.",
		INUSE = "Bon. Je ferais mieu de préparer de la soupe pour tout le monde.",
		REFUEL = "Ah non ! Tu ne reprendras pas ta neige.",
	}
	DESCRIBE.POLARICEPACK = "Une fortification contre mon pire ennemie."
	DESCRIBE.POLARTRINKET_1 = "Y a-t-il des fleurs dans votre jardin enneigé ?"
	DESCRIBE.POLARTRINKET_2 = "J'imagine que ta pelouse n'est pas verte toute l'année."
	DESCRIBE.TRAP_POLARTEETH = "Agrippe comme une fourchette, coupe comme un couteau de boucher."
	DESCRIBE.TURF_POLAR_CAVES = "C'est comme un ingrédient pour le sol."
	DESCRIBE.TURF_POLAR_DRYICE = "C'est comme un ingrédient pour le sol."
	DESCRIBE.WALL_POLAR = "Aaah. Qu'est-ce qu'on peut pas faire avec de la glace ?"
	DESCRIBE.WALL_POLAR_ITEM = "Je ne pense pas qu'il fondra de sitôt."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Un glaçage pour notre arbre de fête de l'hiver."
	DESCRIBE.WX78MODULE_NAUGHTY = "Là, c'est trop de zeste pour une seule bouche. Ou haut-parleur, je ne sais pas."