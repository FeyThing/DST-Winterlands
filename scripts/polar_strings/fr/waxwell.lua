local ANNOUNCE = STRINGS.CHARACTERS.WAXWELL
local DESCRIBE = STRINGS.CHARACTERS.WAXWELL.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "L'esprit bat les pattes !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"N'interprétez pas ça mal... mais j'aurais besoin d'un manteau... et d'une canne...",
		"Mes servants rendraient ça bien plus simple...",
		"Neige... glace... tout ruine un costume...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Qui a encore joué avec ce truc maudit ?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Je préférerais ne pas briser cette glace."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Y a un truc qui cloche..."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Je ne suis pas habillé adéquatement pour ça."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "C'est une leçon d'apprise... Pfff."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Il s'est sacrifié pour mon confort.",
		BURNT = "Ça ne me servira plus, quoi que...",
		CHOPPED = "Il va falloir faire mieu, arbre.",
		GENERIC = "Hmpf. Chose miteuse... il tiens à peine debout.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Je suis supposé planter ça ?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Simple mais brillant."
	DESCRIBE.POLAR_ICICLE_ROCK = "Tu n'auras pas de seconde chance."
	DESCRIBE.ROCK_POLAR = "Tout frais sorti du fournisseur."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "C'est un... truc, dans la neige."
	DESCRIBE.TUMBLEWEED_POLAR = "Très fantaisiste, mais sans importance."
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Il n'est plus trop intimidant comme ça.",
		ANTLER = "Grosse cornes, grande attitude.",
	}
	DESCRIBE.MOOSE_SPECTER = "C'est si... majestueux. Mouais."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "J'ai un collègue aquariophile qui aurait payé une fortune pour ça."
	DESCRIBE.POLARBEAR = {
		DEAD = "La nature prendra soin du reste.",
		ENRAGED = "Oh super. Il sort les crocs.",
		FOLLOWER = "Pour la dernière fois. On n'ira PAS pêcher !",
		GENERIC = "Ils sont bien intrigant.",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Ah non ! Non et non !",
		HELD = "Ça va faire mal, mais ce n'est pas comme si j'allais le garder.",
		HELD_BACKPACK = "Vous ne me ferai pas garder ce truc.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Nous sommes tous dans le même bateau maintenant.",
		FRIEND = "Ça faisait longtemps, l'ami.",
		GENERIC = "Reste sur ton chemin.",
	}
	DESCRIBE.POLARWARG = "Quelle merveilleuse adaptation."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Je ne vais pas mentir, j'aime les braseros.",
		ON = "Tribal. Mais ça marche bien.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "J'ai l'impression d'être devenu une mule là."
	DESCRIBE.POLAR_THRONE = "C'est donc à ça que ça ressemble d'en bas ?"
	DESCRIBE.POLAR_THRONE_GIFTS = "À quel jeu joue-t-il cette fois-ci ?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Et bah. Tu parles d'un logement bien hospitalier.",
		OPEN = "... Je vais prétendre ne pas avoir vu l'intérieur.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Si seulement le soleil pouvait épargner cet endroit.",
		GENERIC = "Je sens quelque chose de pourrit à l'intérieur. Pouah.",
	}
	DESCRIBE.POLARICE_PLOW = "Mieux vaut reculer, ou vous finirez en nourriture pour poisson."
	DESCRIBE.POLARICE_PLOW_ITEM = "Les temps désespérés appelle à des mesures destructrices."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Vous pouvez ouvrir un crâne avec ça."
	DESCRIBE.ICELETTUCE = "Donc, on mange de l'eau croustillante maintenant ?"
	DESCRIBE.ICEBURRITO = "Je ne dis pas que ce soit mauvais mais..."
	DESCRIBE.POLARCRABLEGS = "Ça serait parfait avec du beurre fondu."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Je reprends ce qui m'est de droit, même si il a un peu changé."
	DESCRIBE.BLUEGEM_SHARDS = "Des paillettes."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Je devrais extraire la magie à l'intérieur."
	DESCRIBE.POLAR_DRYICE = "Ça me rappelle... je ne me suis jamais sculpté dans la glace, pas encore."
	DESCRIBE.POLARBEARFUR = "C'est une belle... Argh ! Des puces !"
	DESCRIBE.POLARWARGSTOOTH = "Il faut dire, c'est une belle dent."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Ah, ça peut être utile."
	DESCRIBE.ARMORPOLAR = "Commode, et étonnament raffinée."
	DESCRIBE.FROSTWALKERAMULET = "Dommage pour les poissons dans mon sillage. Enfin bref."
	DESCRIBE.ICICLESTAFF = "Un destin pire que les tomates pourries."
	DESCRIBE.POLAR_SPEAR = "Je l'admets, il peut déchirer mon costume, au pire."
	DESCRIBE.POLARAMULET = "Il a fait un peu de la magie sur la corde. Mais quoi exactement, je ne sais pas."
	DESCRIBE.POLARBEARHAT = "Je suis sérieusement révolté."
	DESCRIBE.POLARCROWNHAT = "Puissant, élégant, mais aussi inconfortable."
	DESCRIBE.POLARFLEA_SACK = "À peine plus préférable que de mourir gelée."
	DESCRIBE.POLARICESTAFF = "Le bon sort, dans de mauvaise mains."
	DESCRIBE.POLARMOOSEHAT = "Hem. Très... rustique."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Ne. Le. Touchez. Pas.",
		INUSE = "Je savais que c'était une mauvaise idée.",
		REFUEL = "Je devrais te lancer dans la mer.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "N'es-tu pas embarrassé, poisson ?"
	DESCRIBE.POLARICEPACK = "Cela éloignera les bactéries un peu plus longtemps."
	DESCRIBE.POLARTRINKET_1 = "Il n'y vraiment nul part où allez pour fuir ces gars."
	DESCRIBE.POLARTRINKET_2 = "Il n'y vraiment nul part où allez pour fuir ces filles."
	DESCRIBE.TRAP_POLARTEETH = "Malicieux. J'aime ça !"
	DESCRIBE.TURF_POLAR_CAVES = "De la tourbe."
	DESCRIBE.TURF_POLAR_DRYICE = "Ça, ça sert au moins."
	DESCRIBE.WALL_POLAR = "J'apprécie leur coté athmosphérique."
	DESCRIBE.WALL_POLAR_ITEM = "Des glaçons de la taille d'un mur. Ouep."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "C'est subtile mais ravissant."
	DESCRIBE.WX78MODULE_NAUGHTY = "Ce robot doit éviter de s'éparpiller."