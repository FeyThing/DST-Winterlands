local ANNOUNCE = STRINGS.CHARACTERS.GENERIC
local DESCRIBE = STRINGS.CHARACTERS.GENERIC.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Ça pourrait avoir des conséquences."
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Croyez-moi... c'est un... raccourci.",
		"Hngh...",
		"Huff...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Qu'est-ce que c'était que ça ?!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Givré essayer ailleurs."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Huh. Ce n'était pas si mal."
	
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {"only_used_by_wx78"}
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {"only_used_by_wx78"}
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Brrr... ! Flocon me sorte de là !"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Je suis sec. Mais seulement en termes de neige."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Je ne vais pas dire non à un feu.",
		BURNT = "Ça contraste beaucoup avec le reste du coin.",
		CHOPPED = "Vaudrait mieux que je m'élan-- euh, m'éloigne avant que les autres arbres ne remarquent.",
		GENERIC = "Cet arbre a l'air hache-arné.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "C'est une graine."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Ça vient de bouger, non ?"
	DESCRIBE.POLAR_ICICLE_ROCK = "Ouais, ça a définitivement bougé."
	DESCRIBE.ROCK_POLAR = "Des gemmes toutes fraîches à récolter."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Je crois avoir vu quelque chose là-dedans."
	DESCRIBE.TUMBLEWEED_POLAR = "Il défie toutes lois de la science."
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Il bois être dur de vivre sans tes cornes.",
		ANTLER = "Je préférerais rester en dehors de son chemin.",
	}
	DESCRIBE.MOOSE_SPECTER = "On dirait que les légendes locales étaient vraies."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Ces yeux doivent valoir une fortune !"
	DESCRIBE.POLARBEAR = {
		DEAD = "Un tas de neige... attends, non.",
		ENRAGED = "Il aboie autant qu'il mord !",
		FOLLOWER = "Ça, c'est mon pote l'ours.",
		GENERIC = "Un gars effrayant, mais câlin.",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "On vient de me mettre la puce à l'oreille qu'il faudrait fuir.",
		HELD = "Ses mandibules sont déjà assez loin sous ma peau.",
		HELD_BACKPACK = "Je suis sûr que tout va très bien se passer.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Allons chasser un peu.",
		FRIEND = "Il a un visage familier. Et on dirait que moi aussi.",
		GENERIC = "Ha ha ! Viens ici !",
	}
	DESCRIBE.POLARWARG = "Le froid doit être trivial avec une fourrure comme la sienne."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Un feu format poche.",
		ON = "C'est trop chaud pour le mettre mes poches. À moins que j'éteindre la flamme.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Selon la science, tout est mieux portatif."
	DESCRIBE.POLAR_THRONE = "Ça a l'air confortable."
	DESCRIBE.POLAR_THRONE_GIFTS = "C'est mon nom ? Je n'arrive pas à lire avec cette égriffure."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "C'est un mystère comment cette cabane tient debout.",
		OPEN = "Euh, pardon. Mauvaise adresse.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Nom d'un crabe !",
		GENERIC = "Je doute qu'il y fasse plus chaud.",
	}
	DESCRIBE.POLARICE_PLOW = "Je suis profondément intrigué par ce qu'il y a en dessous."
	DESCRIBE.POLARICE_PLOW_ITEM = "Le meilleur poisson est toujours celui qui se cache."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Une saveur difficile à égaler."
	DESCRIBE.ICELETTUCE = "C'est un peu trop assaisonné."
	DESCRIBE.ICEBURRITO = "J'adore ce nom."
	DESCRIBE.POLARCRABLEGS = "Le bon côté d'avoir dix jambes, c'est qu'il y en a assez pour tout le monde."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Je retire ce que j'ai dit. ÇA étincelle d'énergie froide."
	DESCRIBE.BLUEGEM_SHARDS = "Un puzzle d'intrigue minéralogique."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Ce truc est lourd !"
	DESCRIBE.POLAR_DRYICE = "Je pourrais faire quelque chose de vraiiiment cool avec ça."
	DESCRIBE.POLARBEARFUR = "C'est tout doux. Peau de vrai !"
	DESCRIBE.POLARWARGSTOOTH = "C'est encore plus pointu !"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "La science dit que ce bâton est parfait."
	DESCRIBE.ARMORPOLAR = "C'est du lourd !"
	DESCRIBE.FROSTWALKERAMULET = "La science peut expliquer ce phénomène... mais pas moi."
	DESCRIBE.ICICLESTAFF = "Toujours utile. Si on oublie «l'incident»."
	DESCRIBE.POLAR_SPEAR = "C'est un gros cornet !"
	DESCRIBE.POLARAMULET = "Ça fait... des choses, c'est certain."
	DESCRIBE.POLARBEARHAT = "Se faire manger a ses avantages."
	DESCRIBE.POLARCROWNHAT = "Et ce qui me protège du gel du cerveau ?"
	DESCRIBE.POLARFLEA_SACK = "À remplir avec de tout petits potes."
	DESCRIBE.POLARICESTAFF = "J'aime tous mes bâtons, mais celui-ci est le cool d'entre eux."
	DESCRIBE.POLARMOOSEHAT = "Un véritable couvre-chef articstique."
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Ça tombe toujours.",
		INUSE = "Ne recommençons pas avec ce truc !",
		REFUEL = "Où est passé la neige ?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "C'est un poiçon."
	DESCRIBE.POLARICEPACK = "Hélas, ça ne me préservera pas mieux."
	DESCRIBE.POLARTRINKET_1 = "Un artefact empreint de légendes hivernales, sûrement."
	DESCRIBE.POLARTRINKET_2 = "Un artefact empreint de légendes hivernales, sûrement."
	DESCRIBE.TRAP_POLARTEETH = "En voilà une réception bien glacée..."
	DESCRIBE.TURF_POLAR_CAVES = "Encore un autre type de caverne."
	DESCRIBE.TURF_POLAR_DRYICE = "Ça se brisera pas sous mes pieds."
	DESCRIBE.WALL_POLAR = "Je me sens tellement en sécurité et au frais entre ces murs."
	DESCRIBE.WALL_POLAR_ITEM = "Utile pour garder son sang froid."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "De quoi épicéa-rer joliment le sapin."
	DESCRIBE.WX78MODULE_NAUGHTY = "Tant de science dans un si petit bidule."