local ANNOUNCE = STRINGS.CHARACTERS.WOLFGANG
local DESCRIBE = STRINGS.CHARACTERS.WOLFGANG.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "C'est l'heure de la bagarre !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Mes pieds sont tout froids !",
		"D-doit... vaincre la neige.",
		"Brrr...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Le ciel a toujours été si bleu ?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "La glace ici est trop faible."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "J'aime les cadeaux!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Wolfgang n'aime pas la neige dans ses chaussures."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Hah ! Le Père Noël ne m'arrêtera pas."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Les cornes brûlent!",
		BURNT = "L'arbre a l'air plus effrayant maintenant.",
		CHOPPED = "Wolfgang a besoin d'adversaires plus forts.",
		GENERIC = "Arbre avec cornes ? L'arbre veut se battre ?",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Une petite graine à enterrer."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Mmm ? C'est surement le vent."
	DESCRIBE.POLAR_ICICLE_ROCK = "Oh, le rocher voulait juste dire bonjour ?"
	DESCRIBE.ROCK_POLAR = "C'est trop froid pour soulever."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Quelque chose est caché ici ?"
	DESCRIBE.TUMBLEWEED_POLAR = "Wolfgang peut le briser facilement."
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Il pleur de tout petits glaçons.",
		ANTLER = "C'est une bête fun a combattre.",
	}
	DESCRIBE.MOOSE_SPECTER = "AAAH ! Wolfgang est désolé !"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Il a un visage un peu effrayant."
	DESCRIBE.POLARBEAR = {
		DEAD = "L'ours était fort. Mais Wolfgang est encore plus fort !",
		ENRAGED = "Il est... un peu intimidant.",
		FOLLOWER = "Wolfgang aime les bras de fer entre amis.",
		GENERIC = "Wolfgang respecte gros ours !",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Hiii!",
		HELD = "Elle voudra pas lâcher sans se battre.",
		HELD_BACKPACK = "Wolfgang n'écrasera pas insecte... si insecte se tient bien.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Petit mais mignon.",
		FRIEND = "Oooh, tu es trop affamé pour suivre Wolfgang ?",
		GENERIC = "Ha ! Quelle petite créature !",
	}
	DESCRIBE.POLARWARG = "Grosse bête a nouveau manteau ?"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Un bol à remplir de feu.",
		ON = "Le bol est plein de lumière et chaleur.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Il est tout petit maintenant !"
	DESCRIBE.POLAR_THRONE = "Un siège pour fessier costaud."
	DESCRIBE.POLAR_THRONE_GIFTS = "Si Wolfgang peut les soulever, Wolfgang peut aussi les prendre !"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Wolfgang a un mauvais pressentiment.",
		OPEN = "C'est un peu s-sombre ici...",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ce gros poisson a eu la vie difficile.",
		GENERIC = "Gros ours a vaincu gros poisson.",
	}
	DESCRIBE.POLARICE_PLOW = "C'est vraiment si profond... ?"
	DESCRIBE.POLARICE_PLOW_ITEM = "Pour creuser de grands trous."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Ça fond pas, mais ça fait psshh dans l'air !"
	DESCRIBE.ICELETTUCE = "C'est des feuilles très croquantes..."
	DESCRIBE.ICEBURRITO = "Is first burrito to survive Wolfgang's grip."
	DESCRIBE.POLARCRABLEGS = "Le premier burrito à survivre à la poigne de Wolfgang."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Ça chatouille la main !"
	DESCRIBE.BLUEGEM_SHARDS = "Sont trop petits. Il faut les assembler en un seul gros caillou."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Wolfgang est puissamment désolé."
	DESCRIBE.POLAR_DRYICE = "C'est plus fort que de la glace mouillé."
	DESCRIBE.POLARBEARFUR = "Ha, ha ! J'en fais un tapis maintenant !"
	DESCRIBE.POLARWARGSTOOTH = "Une dent de gros chien."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "C'est un bon bâton pour marcher et taper."
	DESCRIBE.ARMORPOLAR = "Ne vous mettez pas trop à l'aise maintenant, mes muscles."
	DESCRIBE.FROSTWALKERAMULET = "La glace ferait mieux de ne pas craquer sous pas puissants de Wolfgang."
	DESCRIBE.ICICLESTAFF = "C'est pas aussi amusant que de balancer des coups de poing."
	DESCRIBE.POLAR_SPEAR = "C'est de la glace, mais qui pique !"
	DESCRIBE.POLARAMULET = "Ça va très bien sur Wolfgang !"
	DESCRIBE.POLARBEARHAT = "N'ayez pas peur, Wolfgang n'est pas un ours, juste Wolfgang."
	DESCRIBE.POLARCROWNHAT = "Ça garde le mauvais vent dehors et le bon vent dedans."
	DESCRIBE.POLARFLEA_SACK = "Un cirque de puces portable."
	DESCRIBE.POLARICESTAFF = "Je frapperai le sol et invoquerai l'hiver !"
	DESCRIBE.POLARMOOSEHAT = "Gros ours a perdu son chapeau ?"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Wolfgang aime bien cette boule de neige.",
		INUSE = "Wolfgang l'a secoué un peu trop fort ?",
		REFUEL = "C'est une drôle de boule.",
	}
	DESCRIBE.POLARICEPACK = "Ça garde les choses bien au frais plus longtemps."
	DESCRIBE.POLARTRINKET_1 = "Il est trop fier de sa moustache pour la cacher du froid ! Bon gars."
	DESCRIBE.POLARTRINKET_2 = "Cette petite dame de neige n'a pas peur du froid."
	DESCRIBE.TRAP_POLARTEETH = "Pour transformer les monstres en sacs de frappe."
	DESCRIBE.TURF_POLAR_CAVES = "Du sol froid pour marcher froid."
	DESCRIBE.TURF_POLAR_DRYICE = "Du sol froid pour marcher froid."
	DESCRIBE.WALL_POLAR = "Wolfgang voit un bel homme coincé dedans !"
	DESCRIBE.WALL_POLAR_ITEM = "C'est t'un gros bloc de glace !"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Très joli. Très fragile."
	DESCRIBE.WX78MODULE_NAUGHTY = "C'est du manger à robot, c'est ça ?"