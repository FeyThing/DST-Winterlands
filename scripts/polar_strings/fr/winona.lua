local ANNOUNCE = STRINGS.CHARACTERS.WINONA
local DESCRIBE = STRINGS.CHARACTERS.WINONA.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "On en vient au pattes !"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Peux pas m'arrêter... dois pas m'arrêter... okay, j'arrête.",
		"J'ralenti pas... je gère mon rythme...",
		"Pfiou... J'pourrais prendre une pause !",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Ouf ! C'est fini. Et il... neige ?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Nan. Mauvaise idée."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Au moins certains patrons font des cadeaux."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Ouhlà ! J'suis pas assez vêtu pour ça !"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Et maintenant dans l'essoreuse..."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Brûle, bébé, brûle !",
		BURNT = "Il saupoudre de la cendre sur la neige.",
		CHOPPED = "Il a-bois plus qu'il... enfin t'as compris.",
		GENERIC = "Ces branches ont l'air tranchantes, mais j'ai plus tranchant encore.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Je ne vois vraiment pas ce qui pousse avec ça."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Ah oui, c'est vrai. Mon casque !"
	DESCRIBE.POLAR_ICICLE_ROCK = "J'espère bien toucher ma prime de risque pour tout ça."
	DESCRIBE.ROCK_POLAR = "Ça dérange si je me sers?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Ce qui se trouve là-dessous est une devinette."
	DESCRIBE.TUMBLEWEED_POLAR = "On dit que chacun d'eux est unique. À l'intérieur comme à l'extérieur."
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Ça fonce tête baissé dans les ennuies, hein ?",
		ANTLER = "Ça joue les dure. C'est l'heure de voir si ça l'est vraiment.",
	}
	DESCRIBE.MOOSE_SPECTER = "J'ai juste envie de l'observer pour l'instant."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Un peu trop brillant à mon goût, mais toujours au menu."
	DESCRIBE.POLARBEAR = {
		DEAD = "Et il ne se relève plus !",
		ENRAGED = "Euh, on a un problème d'ours !",
		FOLLOWER = "Donc, euh, c'est quoi ton poisson préféré ?",
		GENERIC = "Me laisse pas en froid.",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "J'ai meilleur chose à faire que de m'approcher de ces trucs.",
		HELD = "Beurk ! Dégage !",
		HELD_BACKPACK = "C'est moi le patron ici. Tu mords quand je le dis.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Tu m'apportes des lapins, et je t'apporte le dinner, simple.",
		FRIEND = "J'aurais oublié ma part du contrat ?",
		GENERIC = "Viens par ici, petit vaurien !",
	}
	DESCRIBE.POLARWARG = "J'ai aucune doute sur son haleine mentholée."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Allumez le feu !",
		ON = "Le design est familier... ça doit être mon imagination.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Une source de lumière portable."
	DESCRIBE.POLAR_THRONE = "Un symbole de pouvoir et de fainéantise."
	DESCRIBE.POLAR_THRONE_GIFTS = "Les p'tits lutins doivent toujours être dans le coin."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "J'suis mieu dehors que dans cette cabane miteuse.",
		OPEN = "L'ami, t'as déjà entendu parler de l'éclairage ? C'est effrayant chez toi.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Hm. Probablement dû à un autre feu de forêt.",
		GENERIC = "Il y a quelque chose de louche là-dedans.",
	}
	DESCRIBE.POLARICE_PLOW = "Je devrais reculer un tout petit peu."
	DESCRIBE.POLARICE_PLOW_ITEM = "J'en ai assez de jouer à cache-cache, la poiscaille."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "La neige n'est rien après avoir mangé ça."
	DESCRIBE.ICELETTUCE = "En parfait état? C'est pratiquement cyopréservé !"
	DESCRIBE.ICEBURRITO = "Juste ce que j'avais besoin pour emballer la journée."
	DESCRIBE.POLARCRABLEGS = "Je me porte bien avec pas plus d'une pincée de luxe."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Je porte pas ça sans gants."
	DESCRIBE.BLUEGEM_SHARDS = "Plutôt sur que le froid à lui seul peut les recoller."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Tu t'es bien battu, poto."
	DESCRIBE.POLAR_DRYICE = "Direction la ligne de glacemblage."
	DESCRIBE.POLARBEARFUR = "C'est chaud, et plus important : c'est mien."
	DESCRIBE.POLARWARGSTOOTH = "J'me doute qu'il était pas herbivore."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Ça peut être utile."
	DESCRIBE.ARMORPOLAR = "On m'a souvent dit que je suis dure à cuir."
	DESCRIBE.FROSTWALKERAMULET = "Ça évitera mon esprit de glisser au travail. Ha !"
	DESCRIBE.ICICLESTAFF = "Je ne devrais pas néglier les conditions venteuses avec ce truc."
	DESCRIBE.POLAR_SPEAR = "Pfft. Très bien. Assumant qu'on vit dans un frigo..."
	DESCRIBE.POLARAMULET = "Il a dit qu'elles sont toutes unique ou un truc du genre."
	DESCRIBE.POLARBEARHAT = "J'imagine que deux têtes valent mieux qu'une."
	DESCRIBE.POLARCROWNHAT = "On peut pas suer avec ça sur le front."
	DESCRIBE.POLARFLEA_SACK = "Si tu t'en prends à moi, tu t'en prends aux bestioles de mon sac."
	DESCRIBE.POLARICESTAFF = "Aller, tout le monde prend la pose !"
	DESCRIBE.POLARMOOSEHAT = "Hé, Woodie. Te restes encore des poils au derche ?"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Ha ! Charlie adorait ces petites choses.",
		INUSE = "Oh toi...",
		REFUEL = "Pas sur comment ça a fuie. Mais c'est mieux ainsi.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Hé bah. Un poisson gratos !"
	DESCRIBE.POLARICEPACK = "Ce petit morceau de glace à parcouru un long chemin."
	DESCRIBE.POLARTRINKET_1 = "Belle écharpe que t'as. J'aimerais bien en avoir une aussi."
	DESCRIBE.POLARTRINKET_2 = "Euh, on dirait qu'ils ont mélangé deux lignes de production."
	DESCRIBE.TRAP_POLARTEETH = "Cruel mais intelligent."
	DESCRIBE.TURF_POLAR_CAVES = "Un morceau de sol."
	DESCRIBE.TURF_POLAR_DRYICE = "Un morceau de route."
	DESCRIBE.WALL_POLAR = "Ouais, c'est un bien beau mur, tout frais."
	DESCRIBE.WALL_POLAR_ITEM = "C'est l'heure d'assembler tout ça."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Y a rien qui cri hiver plus que ça."
	DESCRIBE.WX78MODULE_NAUGHTY = "WX, arrête de laisser traîner n'importe quoi."