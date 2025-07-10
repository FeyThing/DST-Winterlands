local ANNOUNCE = STRINGS.CHARACTERS.WALTER
local DESCRIBE = STRINGS.CHARACTERS.WALTER.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Regarde, Woby ! J'me bas avec un gros ours effrayant !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Woby ! Où- ah, te voilà !",
		"On devrait aller au Nord... non, au Sud !",
		"Brrr...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "C'était... cool ! Glacial, même !"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Essayons sur un terrain plus stable."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Chouette ! Presque ce que je voulais."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Il me f-faut des v-vêtements adéquats... !"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Au moins, mes cheveux ont dégelé."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Un arbre en feu ? Ici ? Vraiment ?",
		BURNT = "Hm. Je me demande bien comment ça a pu arriver.",
		CHOPPED = "La hache a gagné le clash.",
		GENERIC = "L'élan spectral... Ah, c'est juste un arbre. Ça reste quand même cool.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Où on devrait la planter, Woby ?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Je me demande quand elle va tomber."
	DESCRIBE.POLAR_ICICLE_ROCK = "Woah ! Tu l'as vu tomber ?"
	DESCRIBE.ROCK_POLAR = "Regarde combien de Woby il y a là-dedans !"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Hein ? Woby... qu'est-ce qu'il y a là-dedans ?"
	DESCRIBE.TUMBLEWEED_POLAR = "L'abominable flocon de neige ! Je l'ai enfin trouvé !"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Comment a-t-il perdu ses bois ? Oh, c'est une histoire bien tragique... ",
		ANTLER = "Hm. C'est pas trop mal ! Mais s'il était blanc et caché dans une tempête de neige...",
	}
	DESCRIBE.MOOSE_SPECTER = "J-je le savais ! Je le savais... depuis le début ! Ha ha !"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Hé, regardez ces yeux effrayants !"
	DESCRIBE.POLARBEAR = {
		DEAD = "Monsieur ? Monsieur, je crois que vous avez besoin d'aide !",
		ENRAGED = "Mais quels grands crocs tu as !",
		FOLLOWER = "T'es plus facile à apprivoiser que ce qu'ils disaient à la radio.",
		GENERIC = "J'avais raison. Ces trois petits points sombres étaient bel et bien un ours polaire."
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Regardez cet... uh, CES insectes !",
		HELD = "Mon manuel dit que... c'est trop tard pour l'enlever.",
		HELD_BACKPACK = "Rien ne peut m'arrêter, moi, et mes bestioles !",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Je crois qu'il nous aime bien !",
		FRIEND = "Il aurait bien envie d'un petit encas.",
		GENERIC = "Vas-y, Woby, attrape-le !",
	}
	DESCRIBE.POLARWARG = "Pauvre bête, elle doit être perdue."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Un feu de camp portable... ?",
		ON = "Euh... quelqu'un a apporté le sac de guimauves portable ?",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Un jour, Woby, tu transporteras toute notre base !"
	DESCRIBE.POLAR_THRONE = "Ça doit devenir ennuyeux après un moment, hein, M. Maxwell ?"
	DESCRIBE.POLAR_THRONE_GIFTS = "Peut-être qu'ils sont égarés."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Oooh, c'est sûrement ce musée dentaire dont j'ai entendu parler !",
		OPEN = "Salut ! Vous acceptez les visiteurs ?",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ça, c'est ce que j'appelle une brûlure au moins-cinquième degrès. T'as compris?",
		GENERIC = "Tu crois qu'ils fabriquent leurs meubles en neige ?",
	}
	DESCRIBE.POLARICE_PLOW = "T'inquiète pas, je connais le drill."
	DESCRIBE.POLARICE_PLOW_ITEM = "Peut-être que Woby pourrait localiser les poissons à l'odorat ?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Une crème glacée, version eau pétillante."
	DESCRIBE.ICELETTUCE = "Nous lai-serait-tue attrapé froid ? Tu l'as ? Parce que... Laisse tomber..."
	DESCRIBE.ICEBURRITO = "Il ne tombera pas en morceaux, pas une seule miette."
	DESCRIBE.POLARCRABLEGS = "Mmmm ! Hé, quelqu'un veut écouter une histoire d'horreur sur les crabes ?"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "D'une gemme magique à... j'sais pas... une gemme maudite, sûrement ?"
	DESCRIBE.BLUEGEM_SHARDS = "Je parie que je peux reconstituer ce mystère."
	DESCRIBE.MOOSE_POLAR_ANTLER = "On n'aurait pas dû en arriver là."
	DESCRIBE.POLAR_DRYICE = "Faisons un golem de neige !"
	DESCRIBE.POLARBEARFUR = "Ouah, il y a plein de puces là-dedans !"
	DESCRIBE.POLARWARGSTOOTH = "Ça me rappelle que je vais devoir te brosser les dents, fifille."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Un bon bâton pour jouer à rapporter... et quelques autres trucs."
	DESCRIBE.ARMORPOLAR = "Les armures pourraient aussi bien protéger d'autres trucs, hein ?"
	DESCRIBE.FROSTWALKERAMULET = "Oh, euh... j'aurais peut-être dû en faire un collier pour chien."
	DESCRIBE.ICICLESTAFF = "Et si on tirait un coup pour essayer ?"
	DESCRIBE.POLAR_SPEAR = "Désolé Woby, tu peux pas avoir ce bâton."
	DESCRIBE.POLARCROWNHAT = "Bon, c'est quand qu'on construit mon château de glace ?"
	DESCRIBE.POLARFLEA_SACK = "Fais attention quand tu es à portée de mes insectes de poche."
	DESCRIBE.POLARAMULET = "Un petit truc du magasin de souvenirs."
	DESCRIBE.POLARBEARHAT = "Woby n'arrête pas de grogner quand je le porte..."
	DESCRIBE.POLARICESTAFF = "J'ai pitié pour tous les insectes qui se baladent autour de nous."
	DESCRIBE.POLARMOOSEHAT = "C'est de la fourrure d'élan, sans aucun doute. Tu sens ça ?"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Hé, secoue ça !",
		INUSE = "That means... I finally got my hands on an haunted trinket!",
		REFUEL = "Where's the snow... the haunted snow?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Peut-être bien qu'il y a un mini mammouth dedans ?"
	DESCRIBE.POLARICEPACK = "Ça ne rendra pas ma viande séchée éternelle, mais c'est un pas de plus vers son achèvement."
	DESCRIBE.POLARTRINKET_1 = "Il a l'air prêt pour une bataille de boules de neige. Bah moi aussi !"
	DESCRIBE.POLARTRINKET_2 = "Attendez... Je vous connais."
	DESCRIBE.TRAP_POLARTEETH = "Si ça n'attrape pas le castor-garou , j'abandonne !"
	DESCRIBE.TURF_POLAR_CAVES = "Un bout de terrain."
	DESCRIBE.TURF_POLAR_DRYICE = "Une route qui donne des frissons jusqu'aux jambes."
	DESCRIBE.WALL_POLAR = "Cette brume met une bonne ambiance."
	DESCRIBE.WALL_POLAR_ITEM = "N'y pense même pas, Woby !"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Eh bien, ça colle à la saison."
	DESCRIBE.WX78MODULE_NAUGHTY = "Des boyaux de robots ! Des roboyaux !"