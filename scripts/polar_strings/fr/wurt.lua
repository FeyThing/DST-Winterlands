local ANNOUNCE = STRINGS.CHARACTERS.WURT
local DESCRIBE = STRINGS.CHARACTERS.WURT.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Glorp, tu m'mangeras pas !!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Peux pas courir... Peux pas nager... Peut rien faire...",
		"Grrrr... Stupide mer de neige !",
		"C'est pas comme dans l'eau du tout !",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Glr-rpp, laissez le sol tranquille !"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Peut-être pas ici."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "C'est le meilleur jour de ma vie, florp !"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Glurg ! La mer de neige est mouillée ET froide !"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Aaah... de nouveau mouillé juste comme il faut."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "C'est bien chaud, florp.",
		BURNT = "Ça brûlera plus.",
		CHOPPED = "Il coule dans la mer de neige.",
		GENERIC = "Hé, t'es pas un cousin de l'arbre du marais ?",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Faut la mettre dans l'sol !"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Glurp... ? C'était juste du vent."
	DESCRIBE.POLAR_ICICLE_ROCK = "C'est une grosse goutte gelée, florp !"
	DESCRIBE.ROCK_POLAR = "Oooh, y a des trucs qui brille dessus !"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "C'est quoi ce truc, florp ?"
	DESCRIBE.TUMBLEWEED_POLAR = "Hé hé, je vais t'avoir !"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Moi aussi veux faire repousser ma corne, florp.",
		ANTLER = "Je veux avoir des cornes grosse comme ça...",
	}
	DESCRIBE.MOOSE_SPECTER = "Oooh ! C'est comme dans le livre de choses pas vraies !"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Il est troooo beaaaau !"
	DESCRIBE.POLARBEAR = {
		DEAD = "Bien fait. Tu mangeras plus poisson.",
		ENRAGED = "GLORP ! COUREZ !!",
		FOLLOWER = "M-moi pas peur de toi !",
		GENERIC = "Glorp... ! Des mangeurs de Merm...",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Glurg, elles sont partout !",
		HELD = "Va-t'en ! Vaaaa-t'en !",
		HELD_BACKPACK = "J'ai de grands plans pour toi, florp.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Oooh, trop mignon !",
		FRIEND = "Pourquoi tu suis plus, florp ?",
		GENERIC = "Il aime nager dans la mer de neige, flort.",
	}
	DESCRIBE.POLARWARG = "Tu veux bien m'aider à tuer le peuple Ours ?"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Faut jeter bois dedans.",
		ON = "Un peu haut mais encore chaud.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Je l'ai volé au grand méchant ours !"
	DESCRIBE.POLAR_THRONE = "J'peux faire mieux avec mes petites griffes."
	DESCRIBE.POLAR_THRONE_GIFTS = "À moi ! Tout à moi !"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Ça doit être sûr...",
		OPEN = "Coucou ? T'es pas un ours, hein ?",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ouaiiis, un de moins !",
		GENERIC = "Pas envie de voir ce qu'il y a dedans...",
	}
	DESCRIBE.POLARICE_PLOW = "J'peux plus attendre ! Sérieux, florp."
	DESCRIBE.POLARICE_PLOW_ITEM = "J'veux voir les poissons du fond !"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Glurr... Languh... Blooquuuh !"
	DESCRIBE.ICELETTUCE = "C'est une glace qui pousse dans la terre ?!"
	DESCRIBE.ICEBURRITO = "Hein ? Gloorrr... y a un pauvre poisson dedans."
	DESCRIBE.POLARCRABLEGS = "Je vais manger tout le citron !"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Ooooooooooooo!"
	DESCRIBE.BLUEGEM_SHARDS = "Glorp, j'ai tout cassé ?"
	DESCRIBE.MOOSE_POLAR_ANTLER = "C'est moi qui est fait. Ch'ui désolé."
	DESCRIBE.POLAR_DRYICE = "Pourquoi faudrait pas manger cette glace ?"
	DESCRIBE.POLARBEARFUR = "Je pourrais la manger en vengeance... Mais je ferais pas."
	DESCRIBE.POLARWARGSTOOTH = "J'veux les mêmes, florp !"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "L'arbre a laissé ça tomber, mais je garde."
	DESCRIBE.ARMORPOLAR = "J'ai transformé mes ennemies en veste !"
	DESCRIBE.FROSTWALKERAMULET = "C'est presque comme nager, flort."
	DESCRIBE.ICICLESTAFF = "Pour faire tomber des gouttes super lourdes."
	DESCRIBE.POLAR_SPEAR = "Mais, Mme Wicker a dit faut pas jouer avec la nourriture ?"
	DESCRIBE.POLARAMULET = "Les trucs morts me vont si bien !"
	DESCRIBE.POLARBEARHAT = "C'est même pas drôle."
	DESCRIBE.POLARCROWNHAT = "Wurt règne sur la mer de neige !!"
	DESCRIBE.POLARFLEA_SACK = "C'est mes potes maintenant, flort."
	DESCRIBE.POLARICESTAFF = "J'ai une saison entière dans un bâton, florp."
	DESCRIBE.POLARMOOSEHAT = "Hé hé, j'ai pris ton chapeau, pbbbt !"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Ha ha ! L'hiver est coincé dedans !",
		INUSE = "G-glurp! J'ai rien fait !",
		REFUEL = "Oh oh. L'hiver s'est échappé ?",
	}
	DESCRIBE.POLARICEPACK = "Tada ! Un copain pour la boîte gelée."
	DESCRIBE.POLARTRINKET_1 = "Un petit bonhomme encore plus drôle."
	DESCRIBE.POLARTRINKET_2 = "Une petite madame encore plus drôle."
	DESCRIBE.TRAP_POLARTEETH = "Et maintenant on attend. Hé hé !"
	DESCRIBE.TURF_POLAR_CAVES = "C'est de la terre."
	DESCRIBE.TURF_POLAR_DRYICE = "Ça m'aide à marcher plus facilement sur le sol."
	DESCRIBE.WALL_POLAR = "Brrr... j'veux pas vivre dans château de glace !"
	DESCRIBE.WALL_POLAR_ITEM = "J'veux faire un grand château de glace, flort !"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "J'peux le garder ?"
	DESCRIBE.WX78MODULE_NAUGHTY = "Ça crisse."