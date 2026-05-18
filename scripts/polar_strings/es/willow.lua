local ANNOUNCE = STRINGS.CHARACTERS.WILLOW
local DESCRIBE = STRINGS.CHARACTERS.WILLOW.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡A la gueeee-rra!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Voy a rellenar a Bernie con tu pelaje!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡Si quieres pelea, habrá pelea!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "¡¿Eh?! ¿Quién me puso este maldito pez?!"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Ugh... por qué tenía que ser... nieve.",
		"¡Sácame de aquí!",
		"Hmph...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "Aww, ¿le da miedo un poco de fuego?"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¡Ah! ¡Ya odio este lugar!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡No quiero ser comida de pulgas!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "¿Aquí? ¿De todos los lugares?"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Pudo haber sido peor."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "¡Estoy encendida para la cacería!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Bueno, ya basta de lamer tierra..."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "¡Ack! ¡Quítenme esta nieve de encima!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Ugh, mejor pero no por mucho."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "¡SÍ! ¡ARDEEEEE!",
		BURNT = "Y... ya no está.",
		CHOPPED = "Nos volveremos a ver, árbol.",
		GENERIC = "Más te vale arder bien.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Brrr... ¡vamos, crece para poder quemarte!"
	DESCRIBE.FLOWER_POLAR = "Creí que los únicos colores aquí eran blanco, verde y más blanco."
	DESCRIBE.ICELETTUCE_SEEDS = "Unas semillas."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "¿Eh?"
	DESCRIBE.POLAR_ICICLE_ROCK = "¡Ah! ¡Casi me ensarto!"
	DESCRIBE.ROCK_POLAR = "Puedo sentir el frío emanando de aquí."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "No me obligues a meterme aquí."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Aún no puedo ir, aunque no me molesta..." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Bonito castillo. Lástima que se derretirá para el verano.",
		PENGUIN = "¡Está lloviendo nieve!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "¡Te voy a atrapar. Y te voy a derretir!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Oye Maxwell, ¿ves algún parecido?",
		HOSTILE = "¡Está perdiendo los estribos!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "¡Woah, relájate!"
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Su bigote es falso, ¿verdad? TIENE que serlo."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Pfft, mira quién está más idiota ahora.",
		GENERIC = "Oh genial, otro ciervo estúpido de algún tipo.",
	}
	DESCRIBE.MOOSE_SPECTER = "Voy a necesitar más dardos."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Te saqué de este infierno congelado, de nada."
	DESCRIBE.POLARBEAR = {
		DEAD = "Ja, eso es lo que obtienes, oso.",
		ENRAGED = "¡Tiene un temperamento de fuego!",
		FOLLOWER = "¡Ahora muérdelos tú por mí!",
		GENERIC = "Oh, se ven muy inflamables.",
	}
	DESCRIBE.POLARBEARKING = "No me creo las historias... pero tampoco quiero aparecer en la próxima."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Diablos, diablos!",
		HELD_INV = "¡Ughhh! ¡Quítenmela!",
		HELD_BACKPACK = "¡Oye, Wilson! ¡Ven a sacudir mi mochila!",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Venir aquí fue un grave error."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Ven conmigo, y ya verás...",
		FRIEND = "¡Creí que te había perdido!",
		GENERIC = "¡Hola, pequeñín!",
	}
	DESCRIBE.POLARWARG = "Mantén tus pulgas lejos de mí."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Preferiría no derretir ni un solo copo de este."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Espera, ¿él es el emperador o el bufón de la corte?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Meh. Esta exposición estaría mejor con estatuas de madera."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "¡Un golpe de viento y toda la galería cae como dominós!"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Transportable de día. ¡En llamas de noche!",
		ON = "¡Sííí! ¡Arde! ¡Arde de nuevo!",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "¡Esto sí que es pura genialidad!"
	DESCRIBE.POLAR_THRONE = "Solo conozco a uno que desperdiciaría su tiempo sentado aquí. En realidad, dos."
	DESCRIBE.POLAR_THRONE_GIFTS = "Sí. Dudo que algo de esto sea mío."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Quemar este lugar sería hacerle un favor.",
		OPEN = "O sea que así es el Ratón de los Dientes... bueno.",
	}
	DESCRIBE.POLARBEAR_RUG = "¿Qué pasa, Bernie? Ohhh... ya sé."
	DESCRIBE.POLARBEARHEAD = "No me gustaría estar en tu lugar."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "¡Ja ja! ¡Tu casa de pescado no tuvo ninguna oportunidad!",
		GENERIC = "Ugh, huele a pescado.",
	}
	DESCRIBE.POLARHEADSTICK = "Hm. ¿Qué tal si esta vez ponemos fuego en el palo?"
	DESCRIBE.POLARICE_PLOW = "¡Los voy a salvar a todos, pecesitos!"
	DESCRIBE.POLARICE_PLOW_ITEM = "Debe ser una pesadilla estar atrapado bajo el hielo."
	DESCRIBE.POLARWALRUSHEAD = "¡Ay, no! Creí que iba a ser una torreta de disparo."
	DESCRIBE.TOWER_POLAR_FLAG = "¡Apuesto a que quedaría aún mejor en llamas!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Bah. Eso es combustible."
	DESCRIBE.RAINOMETER.POLARSTORM = "Quizás este sea un buen momento para irse de aquí."
	DESCRIBE.WINTEROMETER.POLARSTORM = "¿A que sí?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Warly. Escúchame bien."
	DESCRIBE.FILET_O_FLEA = "Todavía se mueve. ¡Genial!"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "No es exactamente mi favorito."
	DESCRIBE.ICELETTUCE = "Esto es lo opuesto a bueno."
	DESCRIBE.ICELETTUCE_OVERSIZED = "Genial."
	DESCRIBE.ICEBURRITO = "No creo que ninguna salsa picante pueda arreglar esto."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "¡Cualquier cosa tan ahumada tiene que saber rico!"
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "¡Cualquier cosa tan ahumada tiene que saber rico!"
	DESCRIBE.POLARCRABLEGS = "Nunca había probado una de estas. Voy a probar diez."
	DESCRIBE.POLARFLEAEGGSACK = "Al fuego. Sin pensar."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Sísss... ¡aléjate!!"
	DESCRIBE.BLUEGEM_SHARDS = "Astillas horribles."
	DESCRIBE.EMPEROR_EGG = "Brrr... ¡solo pensarlo me da pesadillas!"
	DESCRIBE.MOOSE_POLAR_ANTLER = "Ahora qué hago con este palo..."
	DESCRIBE.PETALS_POLAR = "¿Qué más se puede hacer con ellos que quemarlos?"
	DESCRIBE.PETALS_POLAR_DRIED = "Mmm... Tan seco. Tan inflamable."
	DESCRIBE.POLAR_DRYICE = "¿Para qué sirve si ni siquiera se puede derretir?"
	DESCRIBE.POLARBEARFUR = "Conserva bien el calor."
	DESCRIBE.POLARWARGSTOOTH = "Su última mordida fue helada."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "¿Quién dejaría buena leña tirada por ahí?"
	DESCRIBE.ARMORPOLAR = "¡Nunca me lo quitaré! A menos que empiece a apestar."
	DESCRIBE.COMPASS_POLAR = "¡Grrr! ¡Me rindo con esta cosa inútil!"
	DESCRIBE.EMPEROR_PENGUINHAT = "Prefiero quedarme como plebeya antes de ponérmelo."
	DESCRIBE.FROSTWALKERAMULET = "¡Woah, qué cool! Digo... qué mal, pero es algo cool."
	DESCRIBE.ICICLESTAFF = "Nunca pensé que pelearía lado a lado con el hielo."
	DESCRIBE.POLAR_SPEAR = "Mantén la calma, si puedes."
	DESCRIBE.POLARAMULET = "Es... solo una etapa."
	DESCRIBE.POLARBEARHAT = "Tómalo como una advertencia de no meterse conmigo."
	DESCRIBE.POLARCROWNHAT = "¡Ay! No."
	DESCRIBE.POLARFLEA_SACK = "Uhhh... ¿por qué estamos haciendo esto?"
	DESCRIBE.POLARICESTAFF = "La próxima vez nos vamos a otro lugar...\n¡uno donde pueda conseguirme una Varita Infernal y todo eso!"
	DESCRIBE.POLARMOOSEHAT = "Huele a pescado."
	DESCRIBE.WALRUS_BAGPIPE = "¡Prefiero una ópera de mandrágora antes que esto!"
	DESCRIBE.WALRUS_BEARTRAP = "Odio estas cosas con una pasión ardiente."
	DESCRIBE.WINTERS_FISTS = "Las bolas de nieve son una porquería. ¡Quiero bolas de fuego!"
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¡Deberíamos prenderlps en fuego para más diversión! ¿No? Pfft."
	DESCRIBE.BOAT_ICE_ITEM = "Claro, ¿qué podría salir mal?"
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "¿Para qué preocuparse por el pasado o el futuro? Todo terminará en llamas de todas formas.",
		RECHARGING = "Ahora mismo no hace gran cosa.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Qué juguete tan estúpido.",
		INUSE = "¿Por qué lo sacudiste, por qué?",
		REFUEL = "¡Y no vuelvas!",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "¡Sé justo lo que necesitas, pez!"
	DESCRIBE.POLARICEPACK = "Déjalo en el refri y ya."
	DESCRIBE.POLARTRINKET_1 = "Se ve como que tampoco le gusta mucho el frío."
	DESCRIBE.POLARTRINKET_2 = "Se ve como que tampoco le gusta mucho el frío."
	DESCRIBE.TRAP_POLARTEETH = "Seguiría siendo mejor con fuego."
	DESCRIBE.TURF_POLAR_CAVES = "El suelo es aburrido y frío."
	DESCRIBE.TURF_POLAR_DRYICE = "El suelo es aburrido y frío."
	DESCRIBE.TURF_POLAR_GRASS = "El suelo es aburrido y frío."
	DESCRIBE.WALL_POLAR = "Lo odio."
	DESCRIBE.WALL_POLAR_ITEM = "Quizás le dé una oportunidad."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "No es precisamente mi favorito."
	DESCRIBE.WX78MODULE_NAUGHTY = "Oye WX, ¿cuándo vas a instalar un lanzallamas?"
