local ANNOUNCE = STRINGS.CHARACTERS.WURT
local DESCRIBE = STRINGS.CHARACTERS.WURT.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡No es tu hogar! ¡Grrr!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Glorp, no me vas a comer!!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡Glurph! ¡Ve a pescar a otro lado!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "¡¿Glurgh?! Grrr, la próxima vez no me atrapa..."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"No puedo correr... no puedo nadar... imposible...",
		"Grrr... ¡estúpido gran mar de nieve!",
		"¡No es como el agua para nada!",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡Pantano {wins}, Nieve 0!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Glr-rpp, ¡deja el suelo tranquilo!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Ay! ¡AY! ¡Oh! ¡Se le puede ver por dentro!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Quizás no aquí."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "¡El mejor día de todos, florp!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Espera. ¿Qué? ¿Cómo?"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Qué raro fue eso, florp..."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "¡Glurgh! ¡El gran mar de nieve es mojado Y frío!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Aaah... ya es buen mojado otra vez."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Bien calientito, florp.",
		BURNT = "No va a arder otra vez.",
		CHOPPED = "Se está hundiendo en el gran mar de nieve.",
		GENERIC = "Hm, ¿eres amigo lejano del árbol del pantano?",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "¡Glurph! Casi me tropiezo con el árbol."
	DESCRIBE.FLOWER_POLAR = "Se ve bien, supongo."
	DESCRIBE.ICELETTUCE_SEEDS = "¡Ponerlas en el suelo!"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Glurp...¿ Fue solo el viento."
	DESCRIBE.POLAR_ICICLE_ROCK = "¡Esta gota grande, florp!"
	DESCRIBE.ROCK_POLAR = "¡Ooh, tiene partecitas brillantes adentro!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "¿Qué es esa cosa, florp?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "No puedo entrar a la cueva bajo la cueva todavía." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "¡Ooh, gran castillo, como en los libros de cuentos!",
		PENGUIN = "¡Grrr! ¡Baja de ahí!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Jeje, ¡te voy a atrapar!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "¡Deberíamos unir fuerzas y conquistar a los Cerdos!",
		HOSTILE = "¿Por qué no nos llevamos bien?",
	}
	DESCRIBE.GIRL_WALRUS = "Ji-ji. La familia rara se pone más rara."
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "¡Está protegiendo a la Gente de Nieve, florp!"
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Yo también quiero que me vuelva a crecer el cuernito, florp.",
		GENERIC = "Me gustaría tener cuernos grandes así...",
	}
	DESCRIBE.MOOSE_SPECTER = "¡Ooh! ¡Es como en el libro de cosas-que-no-existen!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "¡Es taaaan bonitoooo!"
	DESCRIBE.POLARBEAR = {
		DEAD = "Bien. Ya no se comerá al pececito.",
		ENRAGED = "¡GLORPT! ¡CORRE!!",
		FOLLOWER = "Yo n-no te tengo miedo.",
		GENERIC = "Glorp...! Es el que se come a la Gente Merm...",
	}
	DESCRIBE.POLARBEARKING = "La Gente Merm dice que él es el monstruo bajo la cama Y en el clóset. G-glup."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Glurgh, está por todos lados!",
		HELD_INV = "¡Aléjate! ¡Aléjate!",
		HELD_BACKPACK = "Tengo grandes planes para ti.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "¡Aplastar! ¡Machacar! Oh. ¡Yo no fui!"
	DESCRIBE.POLARFOX = {
		FOLLOWER = "¡Aww, es demasiado tierno!",
		FRIEND = "¿Por qué ya no me sigue, florp?",
		GENERIC = "Es como nadar en el gran mar de nieve, flort.",
	}
	DESCRIBE.POLARWARG = "¿Quieres ayudar a acabar con la Gente Osa?"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "¿Qué es fruta, florp? ¿Dónde está la fruta?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "¡El hombre payaso lo hace mejor!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Te hice lo que tú les haces a los pececitos."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Hmm. Quizás yo debería hacer estatuas del Rey Merm..."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Métele madera.",
		ON = "Está un poco alto pero igual se siente calientito.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "¡Se lo robé a la Gente Osa!"
	DESCRIBE.POLAR_THRONE = "Puedo hacer uno mejor con mis propias garras."
	DESCRIBE.POLAR_THRONE_GIFTS = "¡Mío! ¡Todo es mío!!"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Probablemente... seguro.",
		OPEN = "¿Hola? ¿No eres de la Gente Osa?",
	}
	DESCRIBE.POLARBEAR_RUG = "Se trata de mandar un mensaje, flort."
	DESCRIBE.POLARBEARHEAD = "¡Ja ja!"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Sííí, ¡una menos!",
		GENERIC = "No quiero ver qué hay adentro...",
	}
	DESCRIBE.POLARHEADSTICK = "Ja-- oh. Todavía no, florp."
	DESCRIBE.POLARICE_PLOW = "¡No puedo esperar! En serio, florp."
	DESCRIBE.POLARICE_PLOW_ITEM = "¡Quiero ver a los peces del fondo!"
	DESCRIBE.POLARWALRUSHEAD = "¡Ja ja!"
	DESCRIBE.TOWER_POLAR_FLAG = "Ji-ji, es un pececito volador."
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Ahora es el emblema del reino de la Gente Merm, flort."
	DESCRIBE.RAINOMETER.POLARSTORM = "Algo viene pero no es lluvia..."
	DESCRIBE.WINTEROMETER.POLARSTORM = "¡Glurph! ¿Qué significa eso?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Glurr- lengua-- pegaaaada!"
	DESCRIBE.FILET_O_FLEA = "¡Puaj!! ¿Cómo llegó aquí?"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "¡Puaj, quiero el otro!"
	DESCRIBE.ICELETTUCE = "¿El helado crece en la tierra?!"
	DESCRIBE.ICELETTUCE_OVERSIZED = "¡Lo logré! ¡Por fin lo logré!"
	DESCRIBE.ICEBURRITO = "¿Eh? Gluurrgh... pobrecito el pez adentro."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Ay... no puedo tener cosas buenas."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Ay... no puedo tener cosas buenas."
	DESCRIBE.POLARCRABLEGS = "¡Quiero comerme todos los gajos de limón!"
	DESCRIBE.POLARFLEAEGGSACK = "¡Me gusta meter las manos ahí. Ji-ji-ji!"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "¡Ooooooooooooo!"
	DESCRIBE.BLUEGEM_SHARDS = "Glorp, ¿se pueden volver a juntar?"
	DESCRIBE.EMPEROR_EGG = "¡Dejó lo brillante atrás!"
	DESCRIBE.MOOSE_POLAR_ANTLER = "Yo lo hice. Lo siento."
	DESCRIBE.PETALS_POLAR = "Debería preguntarle a la señora Wicker si es Comes-ible, florp."
	DESCRIBE.PETALS_POLAR_DRIED = "Los pedacitos secos no están ricos."
	DESCRIBE.POLAR_DRYICE = "¿Por qué este hielo no es Comes-ible?"
	DESCRIBE.POLARBEARFUR = "Me lo podría comer como venganza... pero no lo haré."
	DESCRIBE.POLARWARGSTOOTH = "¡Yo también quiero unos así, florp!"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "El árbol lo soltó, pero yo me lo quedo."
	DESCRIBE.ARMORPOLAR = "¡Convertí a los enemigos de la Gente Merm en camisa!"
	DESCRIBE.COMPASS_POLAR = "El pececito de metal quiere que vaya por aquí."
	DESCRIBE.EMPEROR_PENGUINHAT = "Glurp... debería soltar a los pobres pececitos al agua."
	DESCRIBE.FROSTWALKERAMULET = "Casi como nadar, flort."
	DESCRIBE.ICICLESTAFF = "Hace gotitas de lluvia super pesadas."
	DESCRIBE.POLAR_SPEAR = "¿Pero la señora Wicker dijo que no jugara con la comida?"
	DESCRIBE.POLARAMULET = "¡Yay! ¡Los muertos me ponen elegante!"
	DESCRIBE.POLARBEARHAT = "No tiene gracia."
	DESCRIBE.POLARCROWNHAT = "¡Wurt manda sobre todo el mar de nieve!!"
	DESCRIBE.POLARFLEA_SACK = "Supongo que ya son amigos, flort."
	DESCRIBE.POLARICESTAFF = "Tengo todo el invierno en un palito, florp."
	DESCRIBE.POLARMOOSEHAT = "Ji-ji, ¡te agarré el gorro pbbbth!"
	DESCRIBE.WALRUS_BAGPIPE = "¡FUERTE! ¡DEMASIADO FUERTE!"
	DESCRIBE.WALRUS_BEARTRAP = "No sé qué es esa cosa."
	DESCRIBE.WINTERS_FISTS = "¿La nieve es un arma? ¡Estuve comiendo armas todo ese tiempo!"
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¡Ooooh, pececito! ¡El hombre payaso tiene juegos divertidos!"
	DESCRIBE.BOAT_ICE_ITEM = "Muchos botes pequeñitos."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "¡Solo lo mordisqueé un poquito! Pero la señora Wandy se enojó...",
		RECHARGING = "La señora Wandy dice que está \"re-po-nien-do lo tem-po-ral\"... glurgh. Se me olvidó el resto.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "¡Jaja! ¡El invierno está atrapado adentro!",
		INUSE = "¡G-glurp! ¡Yo no fui!",
		REFUEL = "Uh oh. ¿El invierno escapó?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "¡Te voy a liberar, no te muevas!"
	DESCRIBE.POLARICEPACK = "¡Tada! Hice un amigo para la caja fría."
	DESCRIBE.POLARTRINKET_1 = "Hombrecito más raro."
	DESCRIBE.POLARTRINKET_2 = "Muñequita más rara."
	DESCRIBE.TRAP_POLARTEETH = "Y ahora me quedo mirando. ¡Ji-ji!"
	DESCRIBE.TURF_POLAR_CAVES = "Pedazo de suelo."
	DESCRIBE.TURF_POLAR_DRYICE = "¡Hace el suelo más caminable!"
	DESCRIBE.TURF_POLAR_GRASS = "Pedazo de suelo."
	DESCRIBE.WALL_POLAR = "¡Brrr... no quiero vivir en un castillo de hielo!"
	DESCRIBE.WALL_POLAR_ITEM = "Voy a hacer un gran castillo de hielo, flort."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "¡Quiero quedármelo!"
	DESCRIBE.WX78MODULE_NAUGHTY = "Crujiente."
