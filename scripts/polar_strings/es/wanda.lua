local ANNOUNCE = STRINGS.CHARACTERS.WANDA
local DESCRIBE = STRINGS.CHARACTERS.WANDA.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Oooh, deja ya de llorar!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Se te acabó el tiempo, bestia!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡Solo vine por los colmillos!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Espera... ¿tenía esa cosa en la espalda todo este tiempo?"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Vamos... vamoooos...!",
		"Esto va a tomar... una eternidad...",
		"Hrrrrgh...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡Ja! ¡Váyanse volando! No, espera..."
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¡Ay! El fin se acerca- o... ¿será que no?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "No puede ser así como termina todo..."
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Algo me dice que aquí es mala idea."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Gracias... pero ahora me voy a retirar."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Siento que voy en la dirección correcta..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Todo este rastreo vuelve a tardar demasiado... ¡para qué molestarse!"
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "¡Qué fastidio! No estaba preparada para eso."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "No perdamos más tiempo aquí."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_WANDATIMEFREEZE = "¡Esto nos va a ahorrar algo de tiempo!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_WANDATIMEFREEZE = "Y eso es todo el tiempo que pude ahorrar."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Podría detenerme a calentarme un momento...",
		BURNT = "Valió la pena, supongo.",
		CHOPPED = "Tarde o temprano tenía que pasar.",
		GENERIC = "Parece congelado en el tiempo.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "¿Por qué las plantas tardan tanto en crecer?"
	DESCRIBE.FLOWER_POLAR = "Estuvo esperando todo el año para salir... da qué pensar."
	DESCRIBE.ICELETTUCE_SEEDS = "¿Para qué perder tiempo cultivándolas si puedo comérmelas ahora?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Retrasa lo inevitable todo lo que puedas."
	DESCRIBE.POLAR_ICICLE_ROCK = "Lo encuentro casi... poético, de todas formas."
	DESCRIBE.ROCK_POLAR = "Dudo que vuelva a convertirse en agua pronto."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Es alguna cosa u otra..."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Tendré que volver por esto en otro momento." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Una torre, no del tipo reloj.",
		PENGUIN = "¡Espera a que te ponga mis aletas encima!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "No tengo tiempo de perseguir copos de nieve."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "¿Es realmente rico si todos sus activos están congelados?",
		HOSTILE = "¡Prefiero morir peleando que terminar en la cárcel!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Definitivamente no se ve mucho con esto puesto."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Bigote falso o no, es un problema de verdad."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Bueno. ¿Eso quiere decir que ganaste?",
		GENERIC = "Probablemente es más capaz de mantenerse firme que los otros.",
	}
	DESCRIBE.MOOSE_SPECTER = "¡Tardaste mucho en aparecer!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Todo ese brillo tiene que valer algo de oro..."
	DESCRIBE.POLARBEAR = {
		DEAD = "Al menos quedará bien conservado aquí.",
		ENRAGED = "¿Quieres verme PERDER la calma?",
		FOLLOWER = "¿La pintura es permanente? ¿O cuánto tiempo te toma al día?",
		GENERIC = "Solo estoy de paso, no me hagan caso.",
	}
	DESCRIBE.POLARBEARKING = "Oí historias de que derrotó a un Ciérclope antes de que apareciera..."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Ay! ¡Fuera de aquí!",
		HELD_INV = "Duele, pero quitarlo dolería más.",
		HELD_BACKPACK = "¡Están enrollados como resorte y listos para saltar!",
	}
	DESCRIBE.POLARFLEA_MOTHER = "¡La naturaleza de verdad no debería escalar las cosas así!"
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Ahora que te atrapé... bueno. ¡No sé exactamente qué voy a hacer!",
		FRIEND = "Nos hemos visto en esta línea temporal, ¿verdad?",
		GENERIC = "¡Oooh tú! ¡Esta vez no te vas a escapar!",
	}
	DESCRIBE.POLARWARG = "¿Cuánto tiempo lleva este monstruo merodeando por aquí?"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Ah, bueno. Hay cosas que no se pueden desver."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Hasta en piedra quiere presumir."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "De verdad se cree eterno..."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "¿Su ego enorme es todo lo que debería dejarnos como legado?"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Claro, claro. Necesita combustible.",
		ON = "Si crepita, funciona.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "¡Oooh! Nunca deja de asombrarme."
	DESCRIBE.POLAR_THRONE = "No me gusta hacer lo que no puedo hacer más rápido. Y sentarme más rápido no puedo."
	DESCRIBE.POLAR_THRONE_GIFTS = "No voy a caer en ese truco otra vez."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "¿Por qué querría alguien vivir aquí, de todos los lugares?",
		OPEN = "Haz lo que quieras, pero yo prefiero mi taller con menos... sombras.",
	}
	DESCRIBE.POLARBEAR_RUG = "Ah, se me olvidó limpiar los zapatos... bueno."
	DESCRIBE.POLARBEARHEAD = "¿Quién haría algo así...? Oh. Creo que recuerdo quién."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Quemado pero frío.",
		GENERIC = "Muy cliché, como si yo viviera en una torre de reloj. Aunque espera... ¡yo no me como los relojes!",
	}
	DESCRIBE.POLARHEADSTICK = "Pronto tendrá sentido."
	DESCRIBE.POLARICE_PLOW = "Vamos... ¡van a escaparse!"
	DESCRIBE.POLARICE_PLOW_ITEM = "¿Por qué no pescamos en algún lugar menos frío?"
	DESCRIBE.POLARWALRUSHEAD = "Qué desperdicio de buenos colmillos..."
	DESCRIBE.TOWER_POLAR_FLAG = "Lo único que hace es tratar de escapar con el viento."
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Que cargue polvo, o nieve, lo que sea."
	DESCRIBE.RAINOMETER.POLARSTORM = "Esto no puede ser bueno..."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Qué fastidio... ¿qué significaba eso ya?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Y, ¿cuándo le pones el sabor? Ah."
	DESCRIBE.FILET_O_FLEA = "Espera un momento... no recuerdo haber cocinado... ¿esto?"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "¿Qué tiene este otra vez?"
	DESCRIBE.ICELETTUCE = "¿Tengo que esperar y beberla... o qué?"
	DESCRIBE.ICELETTUCE_OVERSIZED = "¡Qué bueno que creció bastante, porque ya me estaba cansando de esperarla!"
	DESCRIBE.ICEBURRITO = "Todavía estoy tratando de entender esto."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Ojalá cazar no tardara tanto."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Ojalá cazar no tardara tanto."
	DESCRIBE.POLARCRABLEGS = "Más les vale no escabullirse de mi plato."
	DESCRIBE.POLARFLEAEGGSACK = "Ugh. ¿Y yo qué hago con esto?"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "¿Por qué siento que va a explotar en cualquier momento?"
	DESCRIBE.BLUEGEM_SHARDS = "De todas formas prefiero trabajar con piezas más pequeñas."
	DESCRIBE.EMPEROR_EGG = "No va a salir nada de aquí... mejor usarlo de otro modo."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Más vale que valga la pena."
	DESCRIBE.PETALS_POLAR = "¿Seguro que vuelven a crecer?"
	DESCRIBE.PETALS_POLAR_DRIED = "Huelen delicioso."
	DESCRIBE.POLAR_DRYICE = "¿Y ahora para qué uso esto?"
	DESCRIBE.POLARBEARFUR = "Es como sostener nieve tibia."
	DESCRIBE.POLARWARGSTOOTH = "¡No podría hacer un pedazo de sílex más filoso que esto aunque quisiera!"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "¡Oooh, exactamente lo que necesitaba!"
	DESCRIBE.ARMORPOLAR = "Por fin una armadura soportable."
	DESCRIBE.COMPASS_POLAR = "Imagina leer un reloj así... oh, qué horror."
	DESCRIBE.EMPEROR_PENGUINHAT = "No voy a ocupar su lugar."
	DESCRIBE.FROSTWALKERAMULET = "¡Qué bien! Ya tuve más que suficiente de esos malditos ríos."
	DESCRIBE.ICICLESTAFF = "Cuidado con el fuego amigo... y el hielo amigo. ¡Todos los elementos quieren vernos muertos!"
	DESCRIBE.POLAR_SPEAR = "Aprovéchala mientras está nueva."
	DESCRIBE.POLARAMULET = "Ya pasé por esa etapa. ¿O no?"
	DESCRIBE.POLARBEARHAT = "Perturbador pero algo útil."
	DESCRIBE.POLARCROWNHAT = "Empiezo a pensar que valió la pena."
	DESCRIBE.POLARFLEA_SACK = "Bueno, mientras entren solitas, sin drama..."
	DESCRIBE.POLARICESTAFF = "Todos, y digo TODOS, merecen un descanso."
	DESCRIBE.POLARMOOSEHAT = "Solo espero que no me confundan con un bistec ambulante..."
	DESCRIBE.WALRUS_BAGPIPE = "Espera un momento. ¿Hemos descartado la posibilidad de que todos estemos simplemente en Escocia?"
	DESCRIBE.WALRUS_BEARTRAP = "¡No solo duele, sino que además te deja inmovilizado!"
	DESCRIBE.WINTERS_FISTS = "Nunca tendría que quitármelos si no fueran tan pesados."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¡No tengo tiempo para estos juegos! (¿O sí...?)"
	DESCRIBE.BOAT_ICE_ITEM = "¡Para dar saltitos sobre ese molesto mar que me rodea por todos lados!"
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Si no puedo tener más tiempo, al menos debería conservar el presente.",
		RECHARGING = "Está recargando. O mejor dicho, en enfriamiento.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "No tengo tiempo de quedarme mirando esto.",
		INUSE = "En realidad... quizás sí tengo algo de tiempo para verlo.",
		REFUEL = "¿Habrá una fuga en algún lado?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Qué forma tan triste de terminar... pero quizás pueda cambiar tu destino."
	DESCRIBE.POLARICEPACK = "Debería conseguir una mochila del tiempo después."
	DESCRIBE.POLARTRINKET_1 = "Oooh, me encantan los adornitos festivos."
	DESCRIBE.POLARTRINKET_2 = "Oooh, me encantan los adornitos festivos."
	DESCRIBE.TRAP_POLARTEETH = "No conozco muchas cosas peores que quedar atrapada en un lugar."
	DESCRIBE.TURF_POLAR_CAVES = "¿Para qué pierdo tiempo mirando el suelo?"
	DESCRIBE.TURF_POLAR_DRYICE = "¿Un camino hacia dónde, exactamente?"
	DESCRIBE.TURF_POLAR_GRASS = "¿Para qué pierdo tiempo mirando el suelo?"
	DESCRIBE.WALL_POLAR = "No tengo ninganas ganas de golpear eso, eso seguro."
	DESCRIBE.WALL_POLAR_ITEM = "No se va a derretir tan pronto."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Tan real que juraría que se va a derretir... muy... pronto..."
	DESCRIBE.WX78MODULE_NAUGHTY = "¡Ajá! Me preguntaba cuándo empezarían a fabricar estos."
