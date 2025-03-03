local ANNOUNCE = STRINGS.CHARACTERS.WANDA
local DESCRIBE = STRINGS.CHARACTERS.WANDA.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Ton heure est venu, grosse bête !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Allez... Allezzz... !",
		"Ça va prendre... une éternité...",
		"Hrrrrgh...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Ack ! La fin est proche- ou... l'est-ce vraiment ?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Quelque chose me dit que c'est une mauvaise idée."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Et bien merci... mais maintenant je vais prendre congé."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Oh, flûte de zut ! J'étais pas préparé pour ça."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Ne perdons pas plus de temps ici."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Je pourrais m'arrêter et me chauffer un moment...",
		BURNT = "Ça valais le coup, je suppose.",
		CHOPPED = "Il fallait que ça arrive, tôt ou tard.",
		GENERIC = "On dirait qu'il est figé dans le temps.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Pourquoi gâcher du temps à la faire pousser quand on peut juste la manger immédiatement ?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Repousse l'inévitable autant que tu peux."
	DESCRIBE.POLAR_ICICLE_ROCK = "Je trouve ça presque... poétique, enfin bref."
	DESCRIBE.ROCK_POLAR = "Je doute que ça redevienne de l'eau de sitôt."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "C'est une chose ou une autre..."
	DESCRIBE.TUMBLEWEED_POLAR = "Je n'ai pas le temps de chasser les flocons."
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Bien. Est-ce que ça veut dire que tu as gagné ?",
		ANTLER = "Probablement plus susceptible de tenir son territoire que les autres.",
	}
	DESCRIBE.MOOSE_SPECTER = "Tu as mis ton temps pour te montrer !"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Tout cette éclat, mais aucun sens de furtivité."
	DESCRIBE.POLARBEAR = {
		DEAD = "Au moins il sera bien préservé ici.",
		ENRAGED = "Tu veux ME voir perdre MON sang-froid ?!",
		FOLLOWER = "La peinture est permanente ? Ou combien de temps ça te prends chaque jour ?",
		GENERIC = "Je ne fais que passer, ne vous préoccupez pas de moi.",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Ack ! Dégage de là !",
		HELD = "Ça fait mal, mais la retirer le sera plus.",
		HELD_BACKPACK = "Elles sont tendu comme des ressorts et prêt à bondir !",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Maintenant que je t'ai attrapé... et bien. Je ne sais pas ce que je vais faire exactement !",
		FRIEND = "Nous nous sommes déjà rencontré dans cette temporalité, n'est-ce pas ?",
		GENERIC = "Ooooh toi ! Tu ne t'échapperas pas cette fois !",
	}
	DESCRIBE.POLARWARG = "Depuis quand ce monstre rôde dans le coin ?"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Ah, oui. J'ai a besoin de carburant.",
		ON = "Si ça crépite, ça fonctionne.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Oooh ! Ça n'arrêtera jamais de m'impressioner."
	DESCRIBE.POLAR_THRONE = "J'aime pas faire ce que je ne peux pas faire plus rapidement. Et ne je peux pas m'assoir plus rapidement."
	DESCRIBE.POLAR_THRONE_GIFTS = "Je ne tomberais pas dans cette ruse, de nouveau."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Pourquoi quelqu'un voudrait-il vivre ici de tout les endroits ?",
		OPEN = "Comme tu voudras, mais j'aime mon atelier avec moins... d'ombres.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Brulé et pourtant froid.",
		GENERIC = "Très cliché, comme si je vivais dans une tour d'horloge. Nan attend... Je ne mange pas d'horloges !",
	}
	DESCRIBE.POLARICE_PLOW = "Allez... ils vont s'enfuir !"
	DESCRIBE.POLARICE_PLOW_ITEM = "Pourquoi on ne pêcherait pas à un endroit moins froid tout simplement ?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Et, quand vas-tu ajouter la saveur ? Ah."
	DESCRIBE.ICELETTUCE = "Est-ce que je dois attendre et le boire... ou bien ?"
	DESCRIBE.ICEBURRITO = "J'essaye toujours de comprendre ce truc."
	DESCRIBE.POLARCRABLEGS = "Ils n'ont pas intérêt à se carapater de mon plat."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Pourquoi j'ai l'impression que ça peut exploser à tout moment ?"
	DESCRIBE.BLUEGEM_SHARDS = "Je préfère travailler avec de petites pièces de toute façon."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Ça a intérêt à valoir le coup."
	DESCRIBE.POLAR_DRYICE = "Pour quoi pourrais-je utiliser ceci ?"
	DESCRIBE.POLARBEARFUR = "C'est comme tenir de la neige chaude."
	DESCRIBE.POLARWARGSTOOTH = "Je ne pourrais pas faire un silex plus tranchant même si je le voulais !"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Oooh, précisement ce que j'avais besoin !"
	DESCRIBE.ARMORPOLAR = "Enfin une armure potable."
	DESCRIBE.FROSTWALKERAMULET = "Bien ! J'en ai plus qu'assez de ces maudites rivières."
	DESCRIBE.ICICLESTAFF = "Méfiez vous des feux alliés... et glaces alliés. Tout les éléments vous voudrait mort !"
	DESCRIBE.POLAR_SPEAR = "Profitons-en au maximum pendant que c'est encore frais."
	DESCRIBE.POLARAMULET = "Je suis déjà passé par cette phase. Ou pas ?"
	DESCRIBE.POLARBEARHAT = "Dérangeant mais plutôt utile."
	DESCRIBE.POLARCROWNHAT = "Je commence à croire que ça en valait le coup."
	DESCRIBE.POLARFLEA_SACK = "Bon, tant qu'elles sautent directement dedans, pas de chichi..."
	DESCRIBE.POLARICESTAFF = "Tout le monde, et je dis bien TOUT LE MONDE mérite une pause."
	DESCRIBE.POLARMOOSEHAT = "J'espère qu'on ne va pas me confondre avec un steak ambullant..."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Je n'ai pas le temps de fixer ça.",
		INUSE = "En faite... J'ai peut être un peu de temps pour y jeter un œil.",
		REFUEL = "Il a une fuite quelque part ?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Quelle triste manière d'en finir... mais, peut-être que je peux annuler ton destin."
	DESCRIBE.POLARICEPACK = "Je devrais faire un pack temporel la prochaine fois."
	DESCRIBE.POLARTRINKET_1 = "Oooh, j'adore les bibelots festifs !"
	DESCRIBE.POLARTRINKET_2 = "Oooh, j'adore les bibelots festifs !"
	DESCRIBE.TRAP_POLARTEETH = "Je ne connais pas beaucoup de choses pires que d'être coincé sur place."
	DESCRIBE.TURF_POLAR_CAVES = "Pourquoi je perds mon temps à regarder le sol ?"
	DESCRIBE.TURF_POLAR_DRYICE = "Et cette route mène... où, exactement ?"
	DESCRIBE.WALL_POLAR = "Je ne voudrais pas le frapper pour sûr."
	DESCRIBE.WALL_POLAR_ITEM = "Ça ne devrais pas fondre avant un bon moment."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Si réaliste que je jurerais qu'il fondra... très... bientôt..."
	DESCRIBE.WX78MODULE_NAUGHTY = "Ha ha ! Je me demandais quand ils allaient enfin faire ça."