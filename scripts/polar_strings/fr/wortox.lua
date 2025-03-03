local ANNOUNCE = STRINGS.CHARACTERS.WORTOX
local DESCRIBE = STRINGS.CHARACTERS.WORTOX.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Prêt ou pas, me voilà !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Hop... hop... on y va... !",
		"Hou... hou... brrrrr !",
		"Avancez... vilains sabots...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Une farce passable ? C'était plutôt détestable !"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Il y a tant de glace à briser, mais pourquoi ici ?"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Tu vois ? Parfois il faut me faire confience..."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Oh là là... j-je ferais mieux de me c-couvrir."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "J'ai fondu, enfin !"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "L'as-tu vu venir ? J'en doute, houhou !",
		BURNT = "Ça a pris une tournure effrayante et croustillante.",
		CHOPPED = "Il tombe à terre, recouvert de neige.",
		GENERIC = "Tes bois sont grands, mais j'ai une hache, c'est embêtant !",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Mettons-là en terre avant qu'elle pourrisse."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Je jure qu'il a tressailli ! Ou alors ai-je menti ?"
	DESCRIBE.POLAR_ICICLE_ROCK = "Il fallait tenter ta chance, plus tôt ou tard."
	DESCRIBE.ROCK_POLAR = "Serait-ce des gemmes que je vois sous cette brume glaciale ?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Houhou ! Mais qu'est-ce donc ?"
	DESCRIBE.TUMBLEWEED_POLAR = "Un flocon avec un sens des farces !"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Ne t'inquiète pas mon grand, elles repousseront avec le temps.",
		ANTLER = "Tes bois sont immenses ! Je peux les prendre, par chance ?",
	}
	DESCRIBE.MOOSE_SPECTER = "La plupart des mortels ne voient pas non plus de diablotins, je vous rappellerai."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Un joli nageur issue des profondeurs."
	DESCRIBE.POLARBEAR = {
		DEAD = "Retour en poussière ! Ou en neige, si tu préfères.",
		ENRAGED = "Il n'a pas aimé mes blagues, pas même une bouchée !",
		FOLLOWER = "Nous sommes tous deux à peine supportables, houhou!",
		GENERIC = "Ils n'ont pas l'air d'avoir un problème avec les diablotins.",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Oh non ! Non non non !",
		HELD = "C'est pas grave, je prendrais bientôt ton âme.",
		HELD_BACKPACK = "Une façon comme une autre d'amasser des âmes.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Un petit com-patte-riote !",
		FRIEND = "Ne te souviens-tu pas de moi ? Oh, mais tu as l'air tellement affamé...",
		GENERIC = "Attrapez-le avant qu'il ne s'enfonce six sabots sous terre !",
	}
	DESCRIBE.POLARWARG = "Il a un hurlement effrayant à en gelé l'âme !"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Les mortels auraient dû y penser plus tôt, houhou !",
		ON = "Garde le froid à distance, très cher flamme.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "De quoi me réchauffer où que j'aille."
	DESCRIBE.POLAR_THRONE = "Il ne l'utilise plus beaucoup ces temps-ci."
	DESCRIBE.POLAR_THRONE_GIFTS = "Oui, oui ! Ces cadeaux sont gratuits !"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Remplie de malice, sans aucun doute !",
		OPEN = "Oh là là, mon ami, quel grand sourire tu as !",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Même ici, on ne peut échapper aux flammes.",
		GENERIC = "Une refuge ou se réchauffer l'âme.",
	}
	DESCRIBE.POLARICE_PLOW = "Attention ! Le portail au royaume des poissons va s'ouvrir !"
	DESCRIBE.POLARICE_PLOW_ITEM = "C'est moins drôle, mais plus discret que des explosifs."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Je reconnais un blague quand j'en vois une !"
	DESCRIBE.ICELETTUCE = "Les mortels cultivent toutes plantes, aussi médiocres soient-elles."
	DESCRIBE.ICEBURRITO = "Je pourrais toujours essayer. Et me les geler, houhou !"
	DESCRIBE.POLARCRABLEGS = "D'accord, d'accord, je vais croquer dans se crabe."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Dans l'air ou dans une gemme, ton âme finira quand même en moi."
	DESCRIBE.BLUEGEM_SHARDS = "Oups ! Encore cassé."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Quel dommage, pour toi !"
	DESCRIBE.POLAR_DRYICE = "Aussi froid que vous pouvez l'imaginer, c'est parfait."
	DESCRIBE.POLARBEARFUR = "Une fourrure épaisse, blanc comme neige."
	DESCRIBE.POLARWARGSTOOTH = "Je l'admet, celle-ci est redoutable !"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "C'est un bon bâton, bon bouleau."
	DESCRIBE.ARMORPOLAR = "Temps que ça fait mal, ajoutez de la fourrure !"
	DESCRIBE.FROSTWALKERAMULET = "De nouveaux chemins se révèlent lorsque l'eau se congèle."
	DESCRIBE.ICICLESTAFF = "Faites gaffe ! Ces trucs laissent une vilaine marque."
	DESCRIBE.POLAR_SPEAR = "La glace et les bâtons sont faits l'un pour l'autre."
	DESCRIBE.POLARAMULET = "Ce qui compte, c'est que tu y croies, houhou !"
	DESCRIBE.POLARBEARHAT = "Étonnamment confortable pour ce que c'est."
	DESCRIBE.POLARCROWNHAT = "Glacé dehors, gelé dedans."
	DESCRIBE.POLARFLEA_SACK = "Qu'y a-t-il dedans ? Ça, c'est une surprise !"
	DESCRIBE.POLARICESTAFF = "C'est pas sympa de laisser nos invités coincés dans la glace !"
	DESCRIBE.POLARMOOSEHAT = "Une couronne douillette pour cacher un front frileux."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Un royaume gelé, et c'est à moi de le secouer ! Houhou !",
		INUSE = "Quel tentant et maudit bibelot !",
		REFUEL = "C'est vide... mais je ne vais pas m'en plaindre !",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Tu penses être à l'abri de moi, poisson ?"
	DESCRIBE.POLARICEPACK = "Dois-je sacrifier de l'espace pour de la simple nourriture pour mortelle ?"
	DESCRIBE.POLARTRINKET_1 = "Je ne vois aucune âme là-dedans, non, non."
	DESCRIBE.POLARTRINKET_2 = "Je ne vois aucune âme là-dedans, non, non."
	DESCRIBE.TRAP_POLARTEETH = "Cruel ? Peut-être. Amusant ? Assurément !"
	DESCRIBE.TURF_POLAR_CAVES = "Sol ou plafond, selon votre point de vue."
	DESCRIBE.TURF_POLAR_DRYICE = "Sol ou plafond, selon votre point de vue."
	DESCRIBE.WALL_POLAR = "Garde t'il le froid dehors, ou dedans ?"
	DESCRIBE.WALL_POLAR_ITEM = "Ça ne sert à rien quand c'est par terre."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Audacieux, n'est-ce pas ?"
	DESCRIBE.WX78MODULE_NAUGHTY = "Es-tu l'ampoule la plus brillante de la boîte ?"