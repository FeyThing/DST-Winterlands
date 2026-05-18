local ANNOUNCE = STRINGS.CHARACTERS.WOODIE
local DESCRIBE = STRINGS.CHARACTERS.WOODIE.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Te lo mereces!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Rrraaaargh!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡La temporada de caza terminó, para ti!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "¿Eh? Oh, vamos Luce... podrías haberme dicho."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Estoy acostumbrado... a esto...",
		"Grrmmmph...",
		"Es solo un poco de nieve...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡Así se hace! ¡Y no vuelvas, eh!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Supongo que necesitaremos más leña, ¿eh?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Hnff! ¡Tiene lengua!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Sé de un mejor lugar."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "¡Hoo! Lucy, no tenías que—"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Siento que mi nariz está sintonizada en modo bestia."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Mi nariz está tapada de nuevo."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Podría usar una piel grande y cálida ahora mismo."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Así está mejor."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "¡No! No te vas a salvar sin pelear, amigo.",
		BURNT = "Cobarde.",
		CHOPPED = "Eso les enseñará.",
		GENERIC = "Espera, Luce, ¡de este me encargo yo personalmente!",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "¡Parece que pronto tendremos leña!"
	DESCRIBE.FLOWER_POLAR = "Una pequeña maravilla de la tundra."
	DESCRIBE.ICELETTUCE_SEEDS = "¿Podría plantarlas?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Aquí crecen más grandes que en la vieja cabaña."
	DESCRIBE.POLAR_ICICLE_ROCK = "No va a bajar más, ¿eh?"
	DESCRIBE.ROCK_POLAR = "Lámelo y quedarás pegado para siempre."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Reconozco un {name} cuando lo veo."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Creo que tenemos tiempo antes de que eso se abra, ¿eh?" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Buena vista desde aquí arriba, ¿eh?",
		PENGUIN = "Por un segundo pensé que eso no era nieve.",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Menos mal que no está granizando, ¿eh?"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Bonita pista de hielo la que tienes ahí.",
		HOSTILE = "¡Abajo la monarquía!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Estos pájaros están tramando algo..."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "No me gusta el sonido de eso..."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Hmph, amateur. Déjame mostrarte cómo se hace.",
		GENERIC = "¡Grande, valiente y orgulloso de su bosque como yo!",
	}
	DESCRIBE.MOOSE_SPECTER = "¿Yo también puedo hacer eso?"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "¿Alguien te ha dicho que tienes ojos bonitos, eh?"
	DESCRIBE.POLARBEAR = {
		DEAD = "Harías una buena alfombra.",
		ENRAGED = "¡Ahora sí estamos peleando!",
		FOLLOWER = "Siempre dispuesto para un viaje de pesca, ¿eh?",
		GENERIC = "Suena como que alguien se resfrió un poco.",
	}
	DESCRIBE.POLARBEARKING = "Dicen que los árboles caen cuando los mira. Eh. Claro."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Puaj!",
		HELD_INV = "¡Sal de mis pelos y plumas!",
		HELD_BACKPACK = "No son tan malos cuando los conoces.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Yo digo que talemos a este monstruo, ¿eh?"
	DESCRIBE.POLARFOX = {
		FOLLOWER = "¡Ve por esos pájaros!",
		FRIEND = "Ese es mi viejo amigo.",
		GENERIC = "Una vista poco común incluso allá en el norte.",
	}
	DESCRIBE.POLARWARG = "Podría jalar un trineo solo."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "¿Qué quieres decir con \"examinar\"? ¡Lo veo desde aquí!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "No tengo coulrofobia pero... eh. ¿Sabes?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Todas estas estatuas me ponen la piel de gallina."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Tengo la sensación de que se mueve cuando no estoy mirando..."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Solo necesita un poco de yesca.",
		ON = "Con calma ahora...",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Qué bonito, ¿eh?"
	DESCRIBE.POLAR_THRONE = "¿Eso está hecho de... carbón?"
	DESCRIBE.POLAR_THRONE_GIFTS = "Parece que nos portamos bastante bien."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Estoy muy ofendido.",
		OPEN = "No necesito tus maldiciones.",
	}
	DESCRIBE.POLARBEAR_RUG = "Ahh, me siento como en casa."
	DESCRIBE.POLARBEARHEAD = "Espeluznante, pero también bastante impresionante, ¿sabes?"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Supongo que solo estaba construida para aguantar el frío.",
		GENERIC = "Yo siempre decía: vives en lo que comes, ¿eh?",
	}
	DESCRIBE.POLARHEADSTICK = "Ojalá se quedara vacío."
	DESCRIBE.POLARICE_PLOW = "¡Debería ser un buen lugar!"
	DESCRIBE.POLARICE_PLOW_ITEM = "Menos tiempo cavando es más tiempo pescando."
	DESCRIBE.POLARWALRUSHEAD = "El rastro termina aquí."
	DESCRIBE.TOWER_POLAR_FLAG = "Buen atrapavientos, ese."
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Abajo con el imperio emplumado."
	DESCRIBE.RAINOMETER.POLARSTORM = "Esto podría ser serio..."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Oh, no seas tan exagerado."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "En realidad prefiero el helado en invierno, sí."
	DESCRIBE.FILET_O_FLEA = "Eso te enseñará a meterte donde no debes, eh."
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Sabe bien, pero no lo es."
	DESCRIBE.ICELETTUCE = "Como morder cubitos de hielo en una bebida."
	DESCRIBE.ICELETTUCE_OVERSIZED = "No pensé que lo tenías, amigo."
	DESCRIBE.ICEBURRITO = "Es mejor comerlo fresco."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Estoy listo para otra cacería después de esto."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Estoy listo para otra cacería después de esto."
	DESCRIBE.POLARCRABLEGS = "Lo estás haciendo muy bien abriéndolas, Luce."
	DESCRIBE.POLARFLEAEGGSACK = "...Se ve sabroso. ¿Eh? ¿Quién dijo eso?"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Está imposiblemente frío."
	DESCRIBE.BLUEGEM_SHARDS = "Lucy es más del tipo que hace rompecabezas que yo."
	DESCRIBE.EMPEROR_EGG = "Y, eh, ¿qué hago con eso?"
	DESCRIBE.MOOSE_POLAR_ANTLER = "Eso se vería bien sobre una chimenea."
	DESCRIBE.PETALS_POLAR = "Podría hacer un ramo, son las favoritas de Lucy."
	DESCRIBE.PETALS_POLAR_DRIED = "Huele bien."
	DESCRIBE.POLAR_DRYICE = "Bloques de construcción para los más fríos."
	DESCRIBE.POLARBEARFUR = "Debería rellenar mi franela con esto."
	DESCRIBE.POLARWARGSTOOTH = "Solo de mirarlo me duele la mandíbula..."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "¡Me quedo con ese, eh!"
	DESCRIBE.ARMORPOLAR = "Sip. Estoy bien aquí."
	DESCRIBE.COMPASS_POLAR = "¿Crees que vale la pena seguirlo, eh?"
	DESCRIBE.EMPEROR_PENGUINHAT = "No quiero gobernar a los pájaros. Quiero que se pierdan."
	DESCRIBE.FROSTWALKERAMULET = "Para convertir el océano en una cancha de hockey gigante."
	DESCRIBE.ICICLESTAFF = "Eso te va a destrozar más que un árbol entero cayendo."
	DESCRIBE.POLAR_SPEAR = "Me imagino que eso duele un poco."
	DESCRIBE.POLARAMULET = "¿Qué tan salvaje me veo con esto, eh?"
	DESCRIBE.POLARBEARHAT = "Tendrá que servir por ahora."
	DESCRIBE.POLARCROWNHAT = "Me veo usando este, la verdad."
	DESCRIBE.POLARFLEA_SACK = "Ahora son mis bichos."
	DESCRIBE.POLARICESTAFF = "Me hace sentir como en casa, eh."
	DESCRIBE.POLARMOOSEHAT = "¡Ese es más mi tipo de sombrero!"
	DESCRIBE.WALRUS_BAGPIPE = "Le daré una oportunidad."
	DESCRIBE.WALRUS_BEARTRAP = "Cuidado con eso. ¡Puede quitarte un dedo de un solo golpe!"
	DESCRIBE.WINTERS_FISTS = "Me gusta tener algo de nieve a mano."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "Tengo que encontrar la espalda perfecta..."
	DESCRIBE.BOAT_ICE_ITEM = "Solo recuerdo haber hecho el chiste, no lo decía en serio."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Ese es un reloj bastante elegante.",
		RECHARGING = "No parece estar haciendo mucho en este momento.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "De alguna forma quisiera entrar aquí, eh.",
		INUSE = "Vamos, no lo decía en serio.",
		REFUEL = "No hay nieve en el horizonte.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "No es tan gratificante como sacarlo tú mismo con la caña..."
	DESCRIBE.POLARICEPACK = "¿Para qué necesitas un congelador eléctrico cuando tienes esto?"
	DESCRIBE.POLARTRINKET_1 = "A Warly le gustaría esa bufanda."
	DESCRIBE.POLARTRINKET_2 = "¿Eh? Oh, es solo que se parece un poco a la familia."
	DESCRIBE.TRAP_POLARTEETH = "Es un paso más en el engaño."
	DESCRIBE.TURF_POLAR_CAVES = "Solo más suelo, ¿eh?"
	DESCRIBE.TURF_POLAR_DRYICE = "Ahora a encontrar patines aquí..."
	DESCRIBE.TURF_POLAR_GRASS = "Solo más suelo, ¿eh?"
	DESCRIBE.WALL_POLAR = "¿A alguien le apetece romper el hielo?"
	DESCRIBE.WALL_POLAR_ITEM = "¿Qué tal si construimos un iglú, Lucy?"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Ese es perfecto."
	DESCRIBE.WX78MODULE_NAUGHTY = "Unas partes de robot muy sofisticadas."
