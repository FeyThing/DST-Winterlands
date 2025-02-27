local ANNOUNCE = STRINGS.CHARACTERS.WOODIE
local DESCRIBE = STRINGS.CHARACTERS.WOODIE.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Rrraaargh !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"J'ai... l'habitude...",
		"Grrmmmph...",
		"C'est qu'un peu de neige...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "J'imagine on va avoir besoin de plus de bois de chauffage, hein ?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Je connais un meilleur endroit."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Hoo! Lucy, tu n'aurais pas dû..."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "M'faudrais une fourrure bien chaude là maintenant."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "C'est mieux."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Ah non ! Tu partiras pas sans te battre, mon gars.",
		BURNT = "Lâche.",
		CHOPPED = "Ça lui montrera.",
		GENERIC = "Pas maintenant Lucy, j'ai un tête à tête à faire avec lui !",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Je pourrais peut-être la planter ?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Elles grandissent plus ici que sur ma vieille cabane."
	DESCRIBE.POLAR_ICICLE_ROCK = "Elle tombera pas plus bas, hein ?"
	DESCRIBE.ROCK_POLAR = "Lèche le, et t'es coincé pour de bon."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Je reconnais des {name} quand j'en vois."
	DESCRIBE.TUMBLEWEED_POLAR = "Heureusement qu'il ne grêle pas, hein ?"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Hmf, amateur. Laisse-moi te montrer comment on fait.",
		ANTLER = "Grand, intrépide, et fière de ses bois comme je le suis !",
	}
	DESCRIBE.MOOSE_SPECTER = "Je peux faire ça aussi ?"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "On t'as déjà dit que t'as de beau yeux, hein ?"
	DESCRIBE.POLARBEAR = {
		DEAD = "Tu feras un beau tapis.",
		ENRAGED = "Ça c'est de la bagarre !",
		FOLLOWER = "Toujours partant pour une journée pêche, hein ?",
		GENERIC = "On dirait bien que quelqu'un a attrapé froid.",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Beurk !",
		HELD = "Dégage de mes poils et mes plumes !",
		HELD_BACKPACK = "Elles sont pas si mal quand tu finis par les connaitre.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Choppe moi ces foutu piafs.",
		FRIEND = "Je reconnais bien là mon petit chum.",
		GENERIC = "Une vision rare même dans le nord.",
	}
	DESCRIBE.POLARWARG = "Il pourrait tirer un traîneau à lui tout seul."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Juste besoin de petit bois.",
		ON = "Temps qu'il reste stable...",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "N'est ce pas super, hein ?"
	DESCRIBE.POLAR_THRONE = "Est-ce que c'est fait de... charbon ?"
	DESCRIBE.POLAR_THRONE_GIFTS = "On dirait qu'on s'est bien tenu."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Je suis franchement offensé.",
		OPEN = "J'ai pas besoin de tes malédictions.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ça a été construit seulement pour résister au froid.",
		GENERIC = "Comme je disais : tu vis dans ce que tu manges.",
	}
	DESCRIBE.POLARICE_PLOW = "Ça devrait être un bon coin !"
	DESCRIBE.POLARICE_PLOW_ITEM = "Moins de temps à creuser c'est plus de temps à pêcher."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "En vrais je préfère la glace en hiver, et ouais."
	DESCRIBE.ICELETTUCE = "Comme croquer un glaçon dans une boisson."
	DESCRIBE.ICEBURRITO = "Vaudrait mieux le manger frais."
	DESCRIBE.POLARCRABLEGS = "Tu fais du bon boulot pour craquer la coquille, Lucy."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "C'est impossiblement froid."
	DESCRIBE.BLUEGEM_SHARDS = "Lucy est plus calé que moi pour les puzzles."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Ça rendrait bien au dessus d'une cheminée."
	DESCRIBE.POLAR_DRYICE = "Des blocs de construction pour les gamins."
	DESCRIBE.POLARBEARFUR = "Je devrais rembourrer mon plaid avec."
	DESCRIBE.POLARWARGSTOOTH = "Ma mâchoire me fait mal rien qu'en la regardant..."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Je vais juste prendre ça !"
	DESCRIBE.ARMORPOLAR = "Ouais. On est bien dedans."
	DESCRIBE.FROSTWALKERAMULET = "Pour transformer l'océan en un terrain de hockey géant."
	DESCRIBE.ICICLESTAFF = "Ça doit faire plus mal que de se prendre un arbre entier qui tombe."
	DESCRIBE.POLAR_SPEAR = "Givre'magine que ça doit faire mal."
	DESCRIBE.POLARAMULET = "Ça me donne un air sauvage, hein ?"
	DESCRIBE.POLARBEARHAT = "Ça fera l'affaire pour l'instant."
	DESCRIBE.POLARCROWNHAT = "Je me vois bien porter ça, en fait."
	DESCRIBE.POLARFLEA_SACK = "C'est mes insectes maintenant."
	DESCRIBE.POLARICESTAFF = "Un ptit coup, et je me sens comme à la maison."
	DESCRIBE.POLARMOOSEHAT = "C'est mon genre de chapeau ça."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Ça me donnerait envie d'y être, hein.",
		INUSE = "R'allez, j'étais pas sérieux.",
		REFUEL = "Pas de neige à l'horizon.",
	}
	DESCRIBE.POLARICEPACK = "Qui a besoin d'un congél quand on a ça ?"
	DESCRIBE.POLARTRINKET_1 = "Warly aimerais bien cette écharpe."
	DESCRIBE.POLARTRINKET_2 = "Hein ? Oh, c'est juste qu'elle ressemble à de la famille, un peu."
	DESCRIBE.TRAP_POLARTEETH = "C'est un pas de plus dans la fourberie."
	DESCRIBE.TURF_POLAR_CAVES = "Juste encore plus de terre, hein ?"
	DESCRIBE.TURF_POLAR_DRYICE = "Va trouver des patins à glaces ici..."
	DESCRIBE.WALL_POLAR = "Personne se sens de briser la glace ?"
	DESCRIBE.WALL_POLAR_ITEM = "Et si on construisait un igloo, hein Lucy ?"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Celui là est parfait."
	DESCRIBE.WX78MODULE_NAUGHTY = "Des bouts de robot bizarres."