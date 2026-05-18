local ANNOUNCE = STRINGS.CHARACTERS.WARLY
local DESCRIBE = STRINGS.CHARACTERS.WARLY.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Ooh, qué muslo tan apetitoso!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¿Saben lo que dicen sobre vender piel del oso?"
	ANNOUNCE.BATTLECRY.WALRUS = "¡Ah! ¡Justo cuando buscaba la cena!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "¡Alors là! ¡Me las van a pagar!"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Aller... casi...",
		"Bon sang... oof...",
		"Hrrrr...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡El rey se fue! ¡Larga vida al rey!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¡Brr! ¿Quién dejó la puerta del congelador abierta?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Oh sa mère!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Preferiría pescar en otro lugar."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Merci-- oh. ¡Debí haber traído regalos también!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "La naturaleza me revela sus aromas."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Ya es suficiente caza, prefiero variedad."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Q-quel froid! Necesito un abrigo más grande..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Aaahhh... ¿qué haríamos sin el fuego?"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Más me vale disfrutar este fuego mientras dure.",
		BURNT = "Bien tostado, ¿no?",
		CHOPPED = "¡Derribado!",
		GENERIC = "¡Oh! Casi me choco con él.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Solo un petite bébé."
	DESCRIBE.FLOWER_POLAR = "Me preocupa que no duren para siempre aquí."
	DESCRIBE.ICELETTUCE_SEEDS = "De aquí crecerán unas verduras bien frescas."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Gracias por el fresco recordatorio."
	DESCRIBE.POLAR_ICICLE_ROCK = "¿Cómo vas a volver a subir?"
	DESCRIBE.ROCK_POLAR = "¿Practicamos escultura en hielo mientras lo extraemos?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "¿Habrá algo comestible aquí?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Ça alors... está cerca. ¿Quizás otro día?" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "¿Un castillo de hielo entero? Hay que respetarlo.",
		PENGUIN = "¡Apuesto a que sus albóndigas son increíbles!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "¡Quizás aventurarse por aquí no fue tan mala idea!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "¿Están organizando un banquete o una banquise?",
		HOSTILE = "Ah, ¿ya estamos derrocando la monarquía?",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Supongo que buscaré huevos en otro lugar..."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "No es un placer conocerla, madame."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Perdió su garnish.",
		GENERIC = "Una bestia imponente que promete sabores intensos y de caza.",
	}
	DESCRIBE.MOOSE_SPECTER = "Mon dieu, ¡se ve simplemente exquisito!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "¡Poisson frais!"
	DESCRIBE.POLARBEAR = {
		DEAD = "Por fin puedo vender su piel.",
		ENRAGED = "¡Tiene hambre de pelea!",
		FOLLOWER = "Tiene un apetito verdaderamente insaciable.",
		GENERIC = "Los dos tenemos curiosidad por saber cómo sabe el otro\n... ¿o solo soy yo?",
	}
	DESCRIBE.POLARBEARKING = "Dicen que come carne sin masticar... creo que me voy a desmayar."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Oh non!",
		HELD_INV = "¡Bon appétit, y adiós!",
		HELD_BACKPACK = "Creo que están hibernando.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Cada quien tiene su Maman..."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Sencillamente no puedes decirle que non a una buena comida, ¿non?",
		FRIEND = "¿Qué tal si comemos juntos como en los viejos tiempos?",
		GENERIC = "Un renard astuto y pequeño.",
	}
	DESCRIBE.POLARWARG = "Estoy temblando, y no es solo por el frío..."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "La presentación es la mitad del sabor, n'est-ce pas?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Yo también he practicado el malabarismo. ¡Pero jamás con comida!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Una buena ración de ego."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Todo muy bonito. Pero... ¿cuándo comemos?"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Le hacen falta unas ramitas.",
		ON = "¡Et voilà!",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Un buen complemento para mi cocina portátil."
	DESCRIBE.POLAR_THRONE = "No me siento en un trono sin mesa."
	DESCRIBE.POLAR_THRONE_GIFTS = "O sea... he sido bueno este año, ¿non?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Debe ser una verdadera boucherie ahí adentro...",
		OPEN = "Puedes quedarte con lo que no pienso cocinar.",
	}
	DESCRIBE.POLARBEAR_RUG = "Le pertenece a un salón de banquetes."
	DESCRIBE.POLARBEARHEAD = "Qué desperdicio de -- digo, qué lástima, una verdadera lástima."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Creí haber olido sardinas.",
		GENERIC = "¿De verdad resistiría una tormenta de nieve?",
	}
	DESCRIBE.POLARHEADSTICK = "Este asiento está reservado."
	DESCRIBE.POLARICE_PLOW = "Espero haber traído suficiente carnada..."
	DESCRIBE.POLARICE_PLOW_ITEM = "¡Un día de pesca en el hielo suena tentador!"
	DESCRIBE.POLARWALRUSHEAD = "Ya no se mueve tan rápido como esperaría."
	DESCRIBE.TOWER_POLAR_FLAG = "Verlo flotar así me da hambre... ¿qué?"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "¿Supongo que no van a volver a recogerlo?"
	DESCRIBE.RAINOMETER.POLARSTORM = "Algo se está cocinando..."
	DESCRIBE.WINTEROMETER.POLARSTORM = "¿Quieres un abrigo?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "¡Helado para los chicos más cool!"
	DESCRIBE.FILET_O_FLEA = "El ingrediente secreto es una pizca de vergüenza."
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Dije \"poisson frais\" señora, no... bueno."
	DESCRIBE.ICELETTUCE = "Brr... le falta aderezo..."
	DESCRIBE.ICELETTUCE_OVERSIZED = "Ça alors, ¡es una salade enorme!"
	DESCRIBE.ICEBURRITO = "Es la última vez que le dejo los nombres de mis recetas a Wilson."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "¡Ooh la la, este libro de cocina de cazadores guarda tesoros!"
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "¡Ooh la la, este libro de cocina de cazadores guarda tesoros!"
	DESCRIBE.POLARCRABLEGS = "¡Mwah! ¡Simplement par-fait!"
	DESCRIBE.POLARFLEAEGGSACK = "Esto parece... un momento, tengo una idea."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "¡Oh, eso está demasiado frío para mi gusto!"
	DESCRIBE.BLUEGEM_SHARDS = "Le vendría bien un poco de pegamento."
	DESCRIBE.EMPEROR_EGG = "Vaya hallazgo culinarius- eh, curioso."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Yo más bien esperaba probar la carne."
	DESCRIBE.PETALS_POLAR = "Necesita una degustación."
	DESCRIBE.PETALS_POLAR_DRIED = "¡Un ingrediente de primera!"
	DESCRIBE.POLAR_DRYICE = "¡Qué cubos de hielo tan grandes!"
	DESCRIBE.POLARBEARFUR = "La bola de nieve más acogedora."
	DESCRIBE.POLARWARGSTOOTH = "Con eso quedarías bien marcado."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "¡Salut, vieille branche!"
	DESCRIBE.ARMORPOLAR = "Protección peluda."
	DESCRIBE.COMPASS_POLAR = "Por favor, muéstrame el camino al congelador."
	DESCRIBE.EMPEROR_PENGUINHAT = "No es que me disguste el pescado. Sin embargo..."
	DESCRIBE.FROSTWALKERAMULET = "¡Esto lleva el glaseado al siguiente nivel!"
	DESCRIBE.ICICLESTAFF = "¿Il pleut il mouille? No, ¡esto mata!"
	DESCRIBE.POLAR_SPEAR = "Todo bien hasta que empieza a gotear."
	DESCRIBE.POLARAMULET = "No querrías estar cerca cuando saque los colmillos."
	DESCRIBE.POLARBEARHAT = "¿Así es como ve mi comida antes de ser devorada?"
	DESCRIBE.POLARCROWNHAT = "¿Alguien temía que por fin perdiera la calma?"
	DESCRIBE.POLARFLEA_SACK = "Mejor adentro que en mi piel."
	DESCRIBE.POLARICESTAFF = "Perdón, necesito tomar un poco de aire fresco."
	DESCRIBE.POLARMOOSEHAT = "Espero que no haya ningún cazador borracho por aquí."
	DESCRIBE.WALRUS_BAGPIPE = "Bon dieu, ¡mis oídos!"
	DESCRIBE.WALRUS_BEARTRAP = "Una trampa con ganas de hacer un bocado de mí."
	DESCRIBE.WINTERS_FISTS = "Ahora sí que estoy fuera del juego..."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¡Una broma clásica e inofensiva! O al menos debería serlo..."
	DESCRIBE.BOAT_ICE_ITEM = "Lo que sea para mantenerse a flote."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Quizás podría pedirle que me haga un temporizador de cocina...",
		RECHARGING = "Creo que aún no está lista.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Sería un buen adorno de mesa para un banquete.",
		INUSE = "Bueno. Más me vale preparar sopa para todos.",
		REFUEL = "Ah non! No vas a recuperar tu nieve.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "No hay duda de su frescura."
	DESCRIBE.POLARICEPACK = "Un poco de protección contra mi peor enemigo."
	DESCRIBE.POLARTRINKET_1 = "¿Crecían flores en tu jardín nevado?"
	DESCRIBE.POLARTRINKET_2 = "Supongo que tu jardín no era verde todo el año."
	DESCRIBE.TRAP_POLARTEETH = "Agarra como un tenedor, corta como cuchillo de carnicero."
	DESCRIBE.TURF_POLAR_CAVES = "Como un ingrediente para el suelo."
	DESCRIBE.TURF_POLAR_DRYICE = "Como un ingrediente para el suelo."
	DESCRIBE.TURF_POLAR_GRASS = "¿Tendré que cortarlo?"
	DESCRIBE.WALL_POLAR = "Aaah. ¿No es eso hielo?"
	DESCRIBE.WALL_POLAR_ITEM = "Confío en que no se derretirá pronto."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Glaseado para nuestro árbol festivo."
	DESCRIBE.WX78MODULE_NAUGHTY = "Eso es demasiada chispa para una sola boca. O altavoz, no sé."
