local ANNOUNCE = STRINGS.CHARACTERS.WEBBER
local DESCRIBE = STRINGS.CHARACTERS.WEBBER.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "C'est l'heure d'hiberner !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"On tourne... en rond, là ?",
		"Hé ho... ? Il y a quelqu'un ?",
		"On veut pas perdre nos amis dans la neige...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Le sol a tremblé comme de la gelée !"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "C'est trop risqué ici."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Oh, c'est plutôt sympa..."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Maman serait fâchée de nous voir comme ça..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "On peut retourner jouer dans la neige... mais avec un manteau ?"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "C'est très intimidant !",
		BURNT = "Il va sûrement tomber, bientôt.",
		CHOPPED = "Oh oh, il a perdu le combat.",
		GENERIC = "Les élans ne les aiment pas. Mais nous, on les trouve jolis.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "On pourrait faire pousser un truc avec ça."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "On ferait mieux de faire attention."
	DESCRIBE.POLAR_ICICLE_ROCK = "C'est bien fait pour toi."
	DESCRIBE.ROCK_POLAR = "Une bien belle trouvaille."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "On a vu quelque chose ! Mais quoi ?"
	DESCRIBE.TUMBLEWEED_POLAR = "Pas sûr que ça fondrait sur la langue."
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Il s'est cogné la tête ! Pauvre bébête...",
		ANTLER = "Ils sont bien plus grand que ce qu'on imaginait !",
	}
	DESCRIBE.MOOSE_SPECTER = "Il est un poil effrayant..."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "On a pêché un trésor des profondeurs !"
	DESCRIBE.POLARBEAR = {
		DEAD = "Beurk... il est couvert de puces.",
		ENRAGED = "Pardon ! Pardon !",
		FOLLOWER = "On a un gros nounours !",
		GENERIC = "Sommes-nous les bienvenus dans votre petit village ?",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Et mince !",
		HELD = "La prochaine fois, on ferme nos poches !",
		HELD_BACKPACK = "Maman a toujours dit : pas de bestioles dans le cartable...",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Viens on fait des anges dans la neige.",
		FRIEND = "Il se souvient de nous !",
		GENERIC = "Je parie qu'il a faim.",
	}
	DESCRIBE.POLARWARG = "Qui aurait-cru que le yéti avait un chiot ?"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "C'est allumé ? On voit pas bien d'ici !",
		ON = "Aaah, ça fait du bien!",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "On peut avoir un petit chez-soi n'importe où."
	DESCRIBE.POLAR_THRONE = "C'est une sacrée montée."
	DESCRIBE.POLAR_THRONE_GIFTS = "Pour... -W. Ça doit être nous !"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "On dirait la cabane que Walter a décrite dans son histoire !",
		OPEN = "Tu peux arrêter de fixer nos dents ?",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Repose en paix... petite araignée au plafond.",
		GENERIC = "On serait mieux dedans qu'ici dehors.",
	}
	DESCRIBE.POLARICE_PLOW = "On devrait reculer, si on veut pas voir les poissons de TROP près."
	DESCRIBE.POLARICE_PLOW_ITEM = "Une machine pour libérer les poissons de la glace."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Ça tombe pas même si on la tient à l'envers !"
	DESCRIBE.ICELETTUCE = "Faut qu'on mange nos légumes ? Mais c'est de la glace."
	DESCRIBE.ICEBURRITO = "La légende dit que ce burrito ne se défait jamais !"
	DESCRIBE.POLARCRABLEGS = "Il a plus de pattes que nous à partager !"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "C'est encore plus brillant et plus frais."
	DESCRIBE.BLUEGEM_SHARDS = "On aurait peut-être dû être plus prudents."
	DESCRIBE.MOOSE_POLAR_ANTLER = "J'ai t'es cornes ! Et... ta vie, au passage."
	DESCRIBE.POLAR_DRYICE = "C'est interdit dans les batailles de boules de neige."
	DESCRIBE.POLARBEARFUR = "Un oreiller tout doux."
	DESCRIBE.POLARWARGSTOOTH = "C'est bien plus tranchant que les nôtres."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Après toutes ces années... le bâton ultime !"
	DESCRIBE.ARMORPOLAR = "On aimerait la porter pour toujours."
	DESCRIBE.FROSTWALKERAMULET = "Mieux vaut avoir les jambes froides que trempées."
	DESCRIBE.ICICLESTAFF = "Ouhlà ! Ça a l'air pointu !"
	DESCRIBE.POLAR_SPEAR = "Une stalactite sur un bâton !"
	DESCRIBE.POLARAMULET = "Aucun araignée n'a été blessée durant la fabrication."
	DESCRIBE.POLARBEARHAT = "GRRRR !! On t'a fait peur ?"
	DESCRIBE.POLARCROWNHAT = "Les araignées aiment pas trop le froid."
	DESCRIBE.POLARFLEA_SACK = "Pour transporter toute la troupe sur notre dos."
	DESCRIBE.POLARICESTAFF = "Pour faire une toile de glace d'urgence."
	DESCRIBE.POLARMOOSEHAT = "Un chapeau fait d'amis de M. Woodie."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "La neige bouge, lentement. Trop lentement...",
		INUSE = "Est-ce que ça va me mettre sur la liste des enfants pas sage ?",
		REFUEL = "Il lui faut une neige spéciale.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Il faut sauver Willy !"
	DESCRIBE.POLARICEPACK = "C'est rigolo à tenir... p-pour un moment au moins."
	DESCRIBE.POLARTRINKET_1 = "On veut des gros vêtements comme ça aussi !"
	DESCRIBE.POLARTRINKET_2 = "On veut des gros vêtements comme ça aussi !"
	DESCRIBE.TRAP_POLARTEETH = "Notre toile gelée s'agrandit."
	DESCRIBE.TURF_POLAR_CAVES = "Du sol qu'on a creusé."
	DESCRIBE.TURF_POLAR_DRYICE = "Il faut pas marcher sur les craquelures !"
	DESCRIBE.WALL_POLAR = "Les murs de notre fort givré !"
	DESCRIBE.WALL_POLAR_ITEM = "FPremière règle du fort givré : ne pas lécher les murs."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "On aime garder l'arbre (un peu) simple."
	DESCRIBE.WX78MODULE_NAUGHTY = "Oooh. Alors ça ressemble à ça dedans, un robot ?"