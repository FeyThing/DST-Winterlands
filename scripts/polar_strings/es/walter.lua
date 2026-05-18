local ANNOUNCE = STRINGS.CHARACTERS.WALTER
local DESCRIBE = STRINGS.CHARACTERS.WALTER.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "Voy a estar bien, son pájaros que no pelean."
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Atenta, Woby! ¡Estoy peleando con un oso enorme y aterrador!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡Ja! ¡Cayó justo en mi trampa!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Caramba... ¡no pueden seguir saliéndose con la suya!"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"¡Wobes! ¿Dón- ah, ahí estás!",
		"Deberíamos ir al Norte... no, ¡al Sur!",
		"Brrr...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡Supongo que ese castillo de hielo es mío ahora!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¡Eso fue... genial! ¡ Helado icluso!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Espera! ¿Los insectos también pueden atrapar humanos?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Busquemos un lugar más estable."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "¡Qué bien! Casi era lo que quería."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Sniff, sniff... ¿tú hueles esto, Woby? ¡Porque yo sí!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Sabes, en cierta forma extraño la caza a la antigua."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "E-esto exige r-ropa a-adecuada...!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Al menos se me descongelaron los pelos."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "¿Un árbol en llamas? ¿Aquí? ¿De todos los lugares posibles?",
		BURNT = "Vaya. Me pregunto cómo habrá pasado eso.",
		CHOPPED = "El hacha ganó el duelo.",
		GENERIC = "El Alce Espec-- ¡ah! Es un árbol. Igual está genial.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "¡Ay, qué chiquito eres!"
	DESCRIBE.FLOWER_POLAR = "¡La naturaleza siempre encuentra la manera!"
	DESCRIBE.ICELETTUCE_SEEDS = "¿Dónde los plantamos, Woby?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Me pregunto cuándo caerá."
	DESCRIBE.POLAR_ICICLE_ROCK = "¡Vaya! ¿Lo viste caer?"
	DESCRIBE.ROCK_POLAR = "¡Mira cuántos Wobies hay dentro!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "¿Eh? Woby... ¿qué hay aquí?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "¿Qué es eso...? \"En construc... ción\"-- Jaja, ¡qué letra tan horrible!" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "¿Nos dejarán subir hasta arriba si lo pedimos?",
		PENGUIN = "¡Su Majestad podría practicar un poco la puntería!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "¡El copo de nieve abominable! ¡Por fin lo encontré!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Me parece que solo es un fanfarrón.",
		HOSTILE = "Ay, ay... creo que acabamos de iniciar una guerra, Woby.",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "¿Crees que todo un regimiento podría derrotar a un Ciérclope?"
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "¡Oye, nada de tirar basura!"
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "¿Cómo perdió los cuernos? Bueno, es una historia bastante trágica.",
		GENERIC = "Hm. ¡No parece muy misterioso! Pero quizás si fuera blanco y se escondiera en una tormenta...",
	}
	DESCRIBE.MOOSE_SPECTER = "¡Y-yo lo sabía! ¡Lo sabía... todo el tiempo! ¡Jaja!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "¡Oye, mira esos ojos tan inquietantes!"
	DESCRIBE.POLARBEAR = {
		DEAD = "¿Señor? Creo que necesita nuestra ayuda.",
		ENRAGED = "¡Qué colmillos tan grandes tienes!",
		FOLLOWER = "Eres más fácil de domar de lo que decían en ese programa de radio.",
		GENERIC = "Tenía razón. Esos tres puntos oscuros eran, en efecto, un oso polar."
	}
	DESCRIBE.POLARBEARKING = "Dicen que vendió la piel del oso antes de cazarlo. Vaya... ¿¡puedes creerlo!?"
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Mira estos-- uh, ESTOS insectos tan geniales!",
		HELD_INV = "Mi manual dice... que ya es demasiado tarde para quitarlo.",
		HELD_BACKPACK = "¡Nada puede detenerme a mí y a mis insectos!",
	}
	DESCRIBE.POLARFLEA_MOTHER = "¡Caray, Wobers! Recuérdame cepillarte después de esto."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "¡Creo que le caemos bien!",
		FRIEND = "Le vendría bien otro bocadillo.",
		GENERIC = "¡Agárralo, chica!",
	}
	DESCRIBE.POLARWARG = "La pobre criatura debe estar perdida."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "¿A eso le llaman arte? Vaya."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "¿Qué pasa, Wobers? ¡No puede dejar de mirarlo!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Qué bien, qué bien. ¿Pero cuántas medallas te da eso?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Espero que también sirva de veleta."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Un brasero portátil para fuego.",
		ON = "Eh... ¿alguien trajo la bolsa de malvaviscos?",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "¡Algún día, Woby, vas a transportar toda una base!"
	DESCRIBE.POLAR_THRONE = "¿No te aburre después de un rato, Sr. Maxwell?"
	DESCRIBE.POLAR_THRONE_GIFTS = "Quizás se perdieron."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "¡Oooh, este debe ser el museo dental del que había oído hablar!",
		OPEN = "¡Hola! ¿Aceptan visitas?",
	}
	DESCRIBE.POLARBEAR_RUG = "Bienvenidos todos a mi salón de cuentos de terror.\n¡Por favor, tomen asiento!"
	DESCRIBE.POLARBEARHEAD = "¿Es demasiado tarde para devolvérsela a su dueño?"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Eso es una quemadura de hielo si alguna vez vi una. Jeh.",
		GENERIC = "¿Crees que hacen muebles de nieve?",
	}
	DESCRIBE.POLARHEADSTICK = "Eso es un palo genial."
	DESCRIBE.POLARICE_PLOW = "No te preocupes, sé cómo funciona esto."
	DESCRIBE.POLARICE_PLOW_ITEM = "¿Podría Woby localizar el pescado por el olfato?"
	DESCRIBE.POLARWALRUSHEAD = "¡Caramba! ¡Volví a perder el monóculo!"
	DESCRIBE.TOWER_POLAR_FLAG = "¡En esta base, saludamos la bandera!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "No creo haber oído hablar de esta nación antes."
	DESCRIBE.RAINOMETER.POLARSTORM = "Algo debe haber en el aire."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Ja! Todavía está temblando por el cuento de ayer."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Helado, edición agua con gas."
	DESCRIBE.FILET_O_FLEA = "Esto no va a hacerme dejar de cocinar al aire libre, pero ¡qué asco!"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Quizás el veneno desapareció como por arte de magia."
	DESCRIBE.ICELETTUCE = "¿Se congela la lechuga? ¿Lo captan? Porque... olvídenlo..."
	DESCRIBE.ICELETTUCE_OVERSIZED = "Sabía que esta semilla no nos iba a dejar conge- bueno, ya paro."
	DESCRIBE.ICEBURRITO = "No se va a desmoronar ni un poquito."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "¡Vaya, Warly tiene competencia seria con MaTusk por aquí!"
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "¡Vaya, Warly tiene competencia seria con MaTusk por aquí!"
	DESCRIBE.POLARCRABLEGS = "¡Mmmm! Oigan, ¿alguien quiere escuchar mis historias de terror de cangrejos?"
	DESCRIBE.POLARFLEAEGGSACK = "Está lleno de gelatina y frijoles."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "De una gema azul mágica a... no sé... una gema azul maldita, seguramente."
	DESCRIBE.BLUEGEM_SHARDS = "Apuesto a que puedo armar este misterio pieza por pieza."
	DESCRIBE.EMPEROR_EGG = "¡Esta cosa es resistente! No sé cómo un polluelo podría escapar de ella."
	DESCRIBE.MOOSE_POLAR_ANTLER = "No tenía que llegar a esto."
	DESCRIBE.PETALS_POLAR = "Mm... mi instinto me dice que deje que un animal silvestre las pruebe primero."
	DESCRIBE.PETALS_POLAR_DRIED = "¡Secadas a la perfección!"
	DESCRIBE.POLAR_DRYICE = "¡Vamos a construir un muñeco de nieve!"
	DESCRIBE.POLARBEARFUR = "¡Vaya, mira todas las pulgas que tiene!"
	DESCRIBE.POLARWARGSTOOTH = "Me recuerda que pronto debo cepillarte los dientes, chica."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Un buen palo para jugar a buscar... y para algunas otras cosas."
	DESCRIBE.ARMORPOLAR = "Las armaduras igual pueden proteger contra otras cosas, ¿eh?"
	DESCRIBE.COMPASS_POLAR = "Err... dame un segundo, solo tengo que promediar hacia dónde apunta."
	DESCRIBE.EMPEROR_PENGUINHAT = "...¿De verdad es indispensable para ser rey? Bueno."
	DESCRIBE.FROSTWALKERAMULET = "Oh, eh... quizás debería haber hecho un collar para perro con esto."
	DESCRIBE.ICICLESTAFF = "¿Qué tal si lanzamos un tiro? Jeh. Buen chiste, Walter."
	DESCRIBE.POLAR_SPEAR = "Lo siento, Wobers, este palo no es tuyo."
	DESCRIBE.POLARCROWNHAT = "Entonces, ¿cuándo construimos mi castillo de hielo?"
	DESCRIBE.POLARFLEA_SACK = "Más te vale tener cuidado si estás al alcance de mis insectos de bolsillo."
	DESCRIBE.POLARAMULET = "Un pequeño recuerdo de la tienda de souvenirs."
	DESCRIBE.POLARBEARHAT = "Woby no deja de gruñir al respecto..."
	DESCRIBE.POLARICESTAFF = "Me da lástima por todos los insectos de alrededor, que solo estaban ocupados en sus cosas."
	DESCRIBE.POLARMOOSEHAT = "Piel de alce, sin duda. ¿Lo oliste?"
	DESCRIBE.WALRUS_BAGPIPE = "Las morsas seguirían a esa cosa a cualquier parte."
	DESCRIBE.WALRUS_BEARTRAP = "¡Mejor recogemos esto antes de que alguien salga lastimado!"
	DESCRIBE.WINTERS_FISTS = "Apunto mejor con mi honda que con... mis propias manos."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¡No sabía que el pescado se pegaba! ¿Entienden? Porque... ¡se pega!"
	DESCRIBE.BOAT_ICE_ITEM = "Solo no te resbales por la borda. Ja ja. Eso sería bastante malo..."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "¡La señorita Wanda tiene muchos relojes!",
		RECHARGING = "¿Ese reloj está yendo para atrás?",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "¡Oye, agítalo!",
		INUSE = "Eso significa... ¡que por fin tengo en mis manos un objeto embrujado!",
		REFUEL = "¿Dónde está la nieve... la nieve embrujada?",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "¿Y si hay un mini mamut dentro?"
	DESCRIBE.POLARICEPACK = "No va a hacer mi cecina eterna, pero es un paso más cerca."
	DESCRIBE.POLARTRINKET_1 = "Parece listo para una guerra de bolas de nieve. ¡Y yo también!"
	DESCRIBE.POLARTRINKET_2 = "Espera... te conozco."
	DESCRIBE.TRAP_POLARTEETH = "¡Si esto no atrapa al Hombre Castor, lo dejo!"
	DESCRIBE.TURF_POLAR_CAVES = "Un pedazo de suelo."
	DESCRIBE.TURF_POLAR_DRYICE = "Un camino que me hace temblar las piernas."
	DESCRIBE.TURF_POLAR_GRASS = "Un pedazo de suelo."
	DESCRIBE.WALL_POLAR = "Esta neblina crea un ambiente espeluznante muy bueno."
	DESCRIBE.WALL_POLAR_ITEM = "¡Ni se te ocurra lamerla, Woby!"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Bueno, va con la temporada."
	DESCRIBE.WX78MODULE_NAUGHTY = "¡Tripas de robot! ¡Qué genial!"
