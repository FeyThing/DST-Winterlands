local ANNOUNCE = STRINGS.CHARACTERS.WATHGRITHR
local DESCRIBE = STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Laisse-moi une belle cicatrice, tu veux ?"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Ce n'est... rien... !",
		"Je te braverais... neige !",
		"... Mggrmm...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Malédictions! Le Fimbulvetr a commencé !"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Ça s'rais une erreur."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "C'était quoi ce son ?"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Ullr m'a jeté une malédiction !"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Que Loge me sèche de ce cauchemar aquatique !"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Tes branches nous manqueront, arbre.",
		BURNT = "Hélas, il a été réclamé par les feux d'Hel.",
		CHOPPED = "Il est tombé au combat, honorablement.",
		GENERIC = "Icelle branches feraient une belle arme.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Une graine, non carnée."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "La mort par les cieux !"
	DESCRIBE.POLAR_ICICLE_ROCK = "Ha ha ! Les ruses de Loki ne fonctionneront pas sur moi !"
	DESCRIBE.ROCK_POLAR = "Cette glace nous fournit des trésors venues d'en bas."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Allié, ou gèlemie ?"
	DESCRIBE.TUMBLEWEED_POLAR = "Un héraut de l'hiver, tourbillonnant je ne sais où."
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Bah ! Tu t'es désarmé tout seul !",
		ANTLER = "La grâce de Freya touche même ces terres gelées.",
	}
	DESCRIBE.MOOSE_SPECTER = "Une créature caché dans le voile du domaine de Skadi."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Son rayonnement prédit un beau festin."
	DESCRIBE.POLARBEAR = {
		DEAD = "Que ton âme s'élève au Valhalla.",
		ENRAGED = "Combat moi avec toute ta force !",
		FOLLOWER = "Un compagnon des terres du gel..",
		GENERIC = "Vaillant guerrier nordique, crain par tout le royaume des poissons.",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Par Toutatis !",
		HELD = "Elle peut être retiré, au prix de ma peau.",
		HELD_BACKPACK = "Les insectes aspirent à se joindre à moi dans la bataille.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Tout n'est qu'un jeu jusqu'à ce que tu me mènes dans un piège.",
		FRIEND = "Nos chemins se croisent de nouveau...",
		GENERIC = "Tu n'as aucune chance de m'échapper !",
	}
	DESCRIBE.POLARWARG = "Un combat glorieux m'attends dans ces terres gelées."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Un panier de roche pour contenir les flammes.",
		ON = "Je t'invoque, O flamme rugissante!",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Un feu qui attend d'être."
	DESCRIBE.POLAR_THRONE = "Le siège d'un géant de glace."
	DESCRIBE.POLAR_THRONE_GIFTS = "Ça sent le piège."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Un hall d'échange des plus intrigants.",
		OPEN = "Ces article brille de promesses utilent au combat.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Le poisson maison est partie en fumée.",
		GENERIC = "Ça s'rais impressionnant si c'était une vrai prise !",
	}
	DESCRIBE.POLARICE_PLOW = "Razzia !"
	DESCRIBE.POLARICE_PLOW_ITEM = "Quelque chose pour transpercer les ramparts des poissons."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Au goût de mon chez moi !"
	DESCRIBE.ICELETTUCE = "De la non-viande faite de glace."
	DESCRIBE.ICEBURRITO = "Un poisson reposant dans sa couchette gelée."
	DESCRIBE.POLARCRABLEGS = "La bête se dirige vers le Valhalla... et vers mon ventre !"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Renforcé par le râle d'agonie du géant de glace."
	DESCRIBE.BLUEGEM_SHARDS = "La gemme a été défait."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Repose en paix..."
	DESCRIBE.POLAR_DRYICE = "Les morceaux d'un géant de glace !"
	DESCRIBE.POLARBEARFUR = "Une fourrure que seul les plus féroces guerriers peuvent obtenir."
	DESCRIBE.POLARWARGSTOOTH = "Manier cela, c'est d'avoir dompté le gel."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Fait place, maudite neige, ou subi le bâton !"
	DESCRIBE.ARMORPOLAR = "Une armure digne d'une Valkyrie."
	DESCRIBE.FROSTWALKERAMULET = "Traverser les mers est devenu un vrai jeu d'enfant !"
	DESCRIBE.ICICLESTAFF = "Pour invoquer une pluie de lances de glace."
	DESCRIBE.POLAR_SPEAR = "Cette arme ne f'ra pas long feu."
	DESCRIBE.POLARAMULET = "Un pendentif vivifiant, fait pour les tombés."
	DESCRIBE.POLARBEARHAT = "Une mâchoire pour me protéger de la tempête."
	DESCRIBE.POLARCROWNHAT = "Pour congeler mes ennemies comme d'anciens Draugrs !"
	DESCRIBE.POLARFLEA_SACK = "À remplir de petits guerriers, prêt au combat !"
	DESCRIBE.POLARICESTAFF = "Restez à l’écart, ou restez sur place."
	DESCRIBE.POLARMOOSEHAT = "Un casque à corne pour combattre le froid."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Elle contient le pouvoir de déchainer l'hiver !",
		INUSE = "Ce secouage vigoureux à déplu aux dieux !",
		REFUEL = "Elle doit être repli avec la plus sèche des glaces.",
	}
	DESCRIBE.POLARICEPACK = "Notre précieux festin durera un peu plus longtemps."
	DESCRIBE.POLARTRINKET_1 = "Un petit homme bizzare."
	DESCRIBE.POLARTRINKET_2 = "Une petite femme bizzare."
	DESCRIBE.TRAP_POLARTEETH = "Bien des dangers rôdent sous la neige."
	DESCRIBE.TURF_POLAR_CAVES = "Un morceau de champ de bataille."
	DESCRIBE.TURF_POLAR_DRYICE = "Cette route mène à la maison."
	DESCRIBE.WALL_POLAR = "Froid et inflexible, comme ma détermination !"
	DESCRIBE.WALL_POLAR_ITEM = "Des fortifications fait d'un géant des glaces."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Un jeton froid qui convient aux halls du Valhalla."
	DESCRIBE.WX78MODULE_NAUGHTY = "Icels présents devraient renforcer nostre guerrier d'acier."