local ANNOUNCE = STRINGS.CHARACTERS.GENERIC
local DESCRIBE = STRINGS.CHARACTERS.GENERIC.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Las cosas se están poniendo plumosas!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "Esto puede tener consecuencias."
	ANNOUNCE.BATTLECRY.WALRUS = "¡Cometiste un gran error viniendo aquí!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Sabía que algo estaba raro... incluso sospechoso."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Créanme... esto es... un atajo.",
		"Hngh...",
		"Huff...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡Declaro el inicio de una nueva era de liderazgo sereno!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¡Sacudidas y temblores, qué acaba de pasar?!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡AAAHH! ¡Ayuda!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "El hielo debería intentarlo en otro lugar."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Huh. No estuvo tan mal."
	
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {"only_used_by_wx78"}
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {"only_used_by_wx78"}
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Mis sentidos de rastreo se sienten... inusualmente precisos."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "De vuelta a la observación ordinaria."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "¡Brrr...! ¡Esto no tiene ninguna gracia!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Estoy seco. Pero solo en términos de nieve."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_WANDATIMEFREEZE = "only_used_by_wanda"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_WANDATIMEFREEZE = "only_used_by_wanda"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "No voy a rechazar un fuego.",
		BURNT = "Contrasta mucho con el resto del lugar.",
		CHOPPED = "Mejor escapar antes de que los otros árboles se den cuenta.",
		GENERIC = "Este árbol está pidiendo guerra.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Un árbol bebé congelado."
	DESCRIBE.FLOWER_POLAR = "Seguro huele bien pero tengo la nariz un poco tapada."
	DESCRIBE.ICELETTUCE_SEEDS = "Son unas semillas."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "¿Se movió justo ahora?"
	DESCRIBE.POLAR_ICICLE_ROCK = "Sí, definitivamente se movió."
	DESCRIBE.ROCK_POLAR = "Gemas listas para extraer."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Creo que vi algo aquí."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Tengo el presentimiento de que este hoyo todavía no está terminado." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "La sutileza claramente no estaba en sus planos.",
		PENGUIN = "¡Maldición! ¡Lanzanieves!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Desafía toda la ciencia conocida."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "¿Podríamos coordinar una audiencia en la corte?",
		HOSTILE = "¡Tiene ventaja de hielo local!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Se ve picador."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Hay diversión para toda la familia."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Debe ser difícil lidiar con la pérdida de cuernos.",
		GENERIC = "Prefiero mantenerme alejado de su camino.",
	}
	DESCRIBE.MOOSE_SPECTER = "Parece que las leyendas locales eran ciertas."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "¡Esos ojos valdrían una fortuna!"
	DESCRIBE.POLARBEAR = {
		DEAD = "Un montón de nieve... no, espera.",
		ENRAGED = "¡Muerde tanto como ladra!",
		FOLLOWER = "Ese es mi compañero oso.",
		GENERIC = "Un tipo temible y de aspecto adorable.",
	}
	DESCRIBE.POLARBEARKING = "La ciencia dice rumores sobre él."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Hora de huir!",
		HELD_INV = "Las mandíbulas ya están bastante dentro de mi piel.",
		HELD_BACKPACK = "Estoy seguro de que toda esta idea saldrá bien.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "¡Se ve bastante molesta! Me pregunto por qué."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Juguemos un jueguito.",
		FRIEND = "Tiene una cara familiar. Parece que yo también la tengo.",
		GENERIC = "¡Ajá! ¡Ven aquí!",
	}
	DESCRIBE.POLARWARG = "El frío debe ser trivial con un pelaje como el suyo."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Este modelo anatómico no es muy ilustrativo."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "¡Coordinación impresionante, para alguien con aletas!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Supongo que el arte puede usarse para afirmar el dominio de uno."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Casi seguro que vi una estatua de Maxwell exactamente igual..."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Una hoguera de bolsillo.",
		ON = "Demasiado caliente para mis bolsillos ahora. A menos que apague la llama.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "La ciencia dice que todo es mejor cuando es portátil."
	DESCRIBE.POLAR_THRONE = "Se ve cómodo."
	DESCRIBE.POLAR_THRONE_GIFTS = "¿Es ese mi nombre? No puedo saberlo con esa letra de garras."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Es un misterio cómo esta choza se sostiene.",
		OPEN = "Er, fue mi error. Dirección equivocada.",
	}
	DESCRIBE.POLARBEAR_RUG = "Ahora es puro ternura."
	DESCRIBE.POLARBEARHEAD = "Yo no me metería con un oso, ni con quien lo mató."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "¡Santo Dios!",
		GENERIC = "Dudo que haga más calor allá adentro.",
	}
	DESCRIBE.POLARHEADSTICK = "Espero no estar adelantándome demasiado..."
	DESCRIBE.POLARICE_PLOW = "Estoy profundamente intrigado por lo que hay debajo."
	DESCRIBE.POLARICE_PLOW_ITEM = "El mejor pez siempre es el que está escondido."
	DESCRIBE.POLARWALRUSHEAD = "Nada personal, por supuesto. (¡Ejem!)"
	DESCRIBE.TOWER_POLAR_FLAG = "¿Necesito saber a dónde va el viento?"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "¡Perfecto, necesitaba un pañuelo!"
	DESCRIBE.RAINOMETER.POLARSTORM = "Debe ser eso del cambio climático que he escuchado."
	DESCRIBE.WINTEROMETER.POLARSTORM = "¿Me está intentando advertir de algo?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "El sabor a dióxido de carbono es difícil de superar."
	DESCRIBE.FILET_O_FLEA = "Hmm. ¿Alguien pidió una hamburguesa de bicho?"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Ciencia-fícamente hablando, saben mejor."
	DESCRIBE.ICELETTUCE = "Eso tiene demasiado condimento."
	DESCRIBE.ICELETTUCE_OVERSIZED = "¡Esta sabe cómo impresionar!"
	DESCRIBE.ICEBURRITO = "Me gusta mucho ese nombre."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Los alimentos ahumados y fritos son la química en su máxima expresión."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Los alimentos ahumados y fritos son la química en su máxima expresión."
	DESCRIBE.POLARCRABLEGS = "Lo bueno de tener diez patas es que hay suficiente para todos."
	DESCRIBE.POLARFLEAEGGSACK = "Parece gomitas."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Me retracto. ¡ESTO brilla con energía fría!"
	DESCRIBE.BLUEGEM_SHARDS = "Un rompecabezas de intriga mineralógica."
	DESCRIBE.EMPEROR_EGG = "No creo que eclosione. Solo se derretirá."
	DESCRIBE.MOOSE_POLAR_ANTLER = "¡Esta cosa es pesada!"
	DESCRIBE.PETALS_POLAR = "La botánica sugiere que pueden tener aplicaciones medicinales."
	DESCRIBE.PETALS_POLAR_DRIED = "Bien secos."
	DESCRIBE.POLAR_DRYICE = "Podría construir algo reaaaalmente genial con eso."
	DESCRIBE.POLARBEARFUR = "Es acogedor. ¡En serio!"
	DESCRIBE.POLARWARGSTOOTH = "¡Es más afilado!"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "La ciencia dice que este palo es perfecto."
	DESCRIBE.ARMORPOLAR = "¡Eso sí que está bueno!"
	DESCRIBE.COMPASS_POLAR = "¿Me estoy acercando?"
	DESCRIBE.EMPEROR_PENGUINHAT = "Realeza refrigerada."
	DESCRIBE.FROSTWALKERAMULET = "La ciencia puede explicar este fenómeno... pero no lo haré."
	DESCRIBE.ICICLESTAFF = "Siempre útil. Si olvidamos el \"incidente\"."
	DESCRIBE.POLAR_SPEAR = "¡Es una paleta gigante de pinchar!"
	DESCRIBE.POLARAMULET = "Está haciendo... cosas, con toda seguridad."
	DESCRIBE.POLARBEARHAT = "Ser devorado tiene sus ventajas."
	DESCRIBE.POLARCROWNHAT = "¿Y qué me protege del congelamiento cerebral?"
	DESCRIBE.POLARFLEA_SACK = "Para llenarlo de aliados del tamaño de un bocado."
	DESCRIBE.POLARICESTAFF = "Me gustan todos mis bastones pero este es el primero entre hielos."
	DESCRIBE.POLARMOOSEHAT = "Vaya pieza de tocado ártico."
	DESCRIBE.WALRUS_BAGPIPE = "Bienvenidos a la fiesta de caza de MacTusk y WilSon."
	DESCRIBE.WALRUS_BEARTRAP = "¡Menos mal que no soy un oso!"
	DESCRIBE.WINTERS_FISTS = "Hielo comprimido para dar un buen golpe."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "Solo tengo que actuar con naturalidad."
	DESCRIBE.BOAT_ICE_ITEM = "Estos son buenos para moverse."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Apuesto a que hay mucha ciencia interesante adentro.",
		RECHARGING = "Está haciendo \"cosas del tiempo\", ese es el término técnico.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Todavía está funcionando.",
		INUSE = "¡No volvamos a hacer esto!",
		REFUEL = "¿A dónde se fue la nieve?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Eso es un cubo de pez."
	DESCRIBE.POLARICEPACK = "Por desgracia, no me conservará a mí mejor."
	DESCRIBE.POLARTRINKET_1 = "Un artefacto impregnado de leyendas invernales, seguramente."
	DESCRIBE.POLARTRINKET_2 = "Un artefacto impregnado de leyendas invernales, seguramente."
	DESCRIBE.TRAP_POLARTEETH = "Eso sí que es una recepción fría..."
	DESCRIBE.TURF_POLAR_CAVES = "Otro tipo de cueva más."
	DESCRIBE.TURF_POLAR_DRYICE = "Más resistente que la mayoría del hielo por aquí."
	DESCRIBE.TURF_POLAR_GRASS = "Un trozo de suelo."
	DESCRIBE.WALL_POLAR = "Me siento muy seguro y frío dentro de esas."
	DESCRIBE.WALL_POLAR_ITEM = "Útil para mantener la calma."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Este debería adornar el árbol perfectamente."
	DESCRIBE.WX78MODULE_NAUGHTY = "Tanta ciencia empacada en un pequeño aparato."
