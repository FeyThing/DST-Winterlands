local ANNOUNCE = STRINGS.CHARACTERS.WICKERBOTTOM
local DESCRIBE = STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Regresa a tu hábitat natural!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Prevalecerá la mente sobre la fuerza bruta!"
	ANNOUNCE.BATTLECRY.WALRUS = "Aquí termina el camino."
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Bueno. Al menos es grato ver a todos reírse."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"¡Un desvío habría sido preferible a semejante esfuerzo!",
		"Mi locomoción está gravemente impedida...",
		"¿Por qué no me preparé mejor para este penoso avance en la nieve?",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¿Una retirada estratégica? Tsk."
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Esta perturbación parece orquestada, no natural."
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Oh, cielos!!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Hacer un agujero aquí sería poco aconsejable."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Ooo. ¡Qué regalo tan funcional!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Mis sentidos parecen haberse agudizado de repente."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Por el olor, diría que el efecto ha llegado a su fin."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "No estoy equipada para tales condiciones."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "El deshielo me dejó completamente empapada."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Arde de raíz a copa.",
		BURNT = "Un resto carbonizado de lo que fue.",
		CHOPPED = "Se había adaptado para intimidar a los animales, no para soportarlos.",
		GENERIC = "Este árbol parece imitar las defensas de los Cervidae con sus ramas.", -- THE MIMIC!!!
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "¿Cuánto tiempo lleva este retoño dormido bajo la nieve?"
	DESCRIBE.FLOWER_POLAR = "Bonita, y se parece mucho a un miembro del género Colchicum."
	DESCRIBE.ICELETTUCE_SEEDS = "No puede empezar a crecer hasta que la hayas plantado, querida."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Cuidado con tus pasos, querida."
	DESCRIBE.POLAR_ICICLE_ROCK = "Cada uno pronto será víctima de sus propios planes."
	DESCRIBE.ROCK_POLAR = "¡Esperan ser excavadas las gemas incrustadas!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Esto requiere una inspección más cercana."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Ahora no, querida. Lo que hay abajo aún no está listo." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Aves sociales, sí, ¡pero esto es algo completamente distinto!",
		PENGUIN = "No hace falta ser cortés cuando uno está bajo asedio.",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Me gustaría observar su estructura de más cerca."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Vaya, este Aptenodytes imperator desde luego tiene muy alta opinión de sí mismo.",
		HOSTILE = "¡Tu reinado termina aquí!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Podría usar esta pluma..."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Oh, cielos, esta vez trajeron refuerzos."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "No te equivoques, aún puede pelear.",
		GENERIC = "Un bello ejemplar con defensas dignas de la naturaleza salvaje.",
	}
	DESCRIBE.MOOSE_SPECTER = "¡Este ejemplar valdría la pena estudiarlo!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Me pregunto cómo se vería el mundo a través de esos ojos nacarados."
	DESCRIBE.POLARBEAR = {
		DEAD = "Extraordinario, pero sin vida.",
		ENRAGED = "Eso sí que es una \"fuerza de la naturaleza\". ¡Tsk!",
		FOLLOWER = "Domar un oso es absurdo, pero parece que le he caído bien.",
		GENERIC = "Un cazador extraordinario que prospera en condiciones tan extremas.",
	}
	DESCRIBE.POLARBEARKING = "Su leyenda está archivada simultáneamente bajo Mitología y Memorias Personales. Estoy desconcertada."
	DESCRIBE.POLARFLEA = {
		GENERIC = "Oh, cielos...",
		HELD_INV = "¡Qué falta de modales, repugnantes parásitos!",
		HELD_BACKPACK = "No toleraré que ninguno de ustedes se acerque a mis libros.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Ya había notado cuán prolíficas son.\nPero solo ahora entiendo por qué."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Un poco de comida rinde mucho aquí, ¿verdad, querida?",
		FRIEND = "Una cara que no olvidaré pronto.",
		GENERIC = "¡Vulpes lagopus, retozando felizmente en la nieve!",
	}
	DESCRIBE.POLARWARG = "Será difícil de vencer con ventaja de terreno."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Solo la mitad del compromiso con el arte..."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "¿Son huevos? ¡Habría sido una representación espantosa!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Qué noble. Claro, a los nobles les gusta que los esculpan, ¿no?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "El artista podría estar en el patio; debo preguntarle."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Necesita combustible.",
		ON = "Una llama cálida y segura.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Un recipiente portátil de fuego bastante básico. Aunque no fui yo quien lo pensó primero."
	DESCRIBE.POLAR_THRONE = "Quien se sienta aquí lleva mucho tiempo ausente."
	DESCRIBE.POLAR_THRONE_GIFTS = "Me sorprende que no estén cubiertos de nieve todavía."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Qué lugar tan curioso para un comercio... o quién sabe qué.",
		OPEN = "Aún conservo todos mis dientes, querida, y pienso seguir así.",
	}
	DESCRIBE.POLARBEAR_RUG = "Un poco macabro, pero sin duda acogedor."
	DESCRIBE.POLARBEARHEAD = "Esto pretende ser una advertencia."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ha sucumbido a las llamas.",
		GENERIC = "Una guarida, aunque apenas aislada térmicamente.",
	}
	DESCRIBE.POLARHEADSTICK = "Parece estar aguardando un... ejemplar."
	DESCRIBE.POLARICE_PLOW = "A segundos de descubrirlo..."
	DESCRIBE.POLARICE_PLOW_ITEM = "El frío fondo del océano es más animado de lo que uno podría pensar."
	DESCRIBE.POLARWALRUSHEAD = "Un triste ejemplo del fracaso por exceso de confianza."
	DESCRIBE.TOWER_POLAR_FLAG = "¡Qué movimiento tan sugerente!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Lamentablemente demasiado grande para un marcapáginas."
	DESCRIBE.RAINOMETER.POLARSTORM = "Oh, cielos... esto no puede ser bueno."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Espero que tengamos suficiente leña."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Sus recetas secretas no siempre son tan secretas."
	DESCRIBE.FILET_O_FLEA = "Puedo saborear la entomología."
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Es veneno."
	DESCRIBE.ICELETTUCE = "Frigidaria brassica. Sus hojas dejan a la menta en vergüenza."
	DESCRIBE.ICELETTUCE_OVERSIZED = "El resultado de la perseverancia, la insistencia bruta y, quizás, la terquedad."
	DESCRIBE.ICEBURRITO = "Sustento fresco, seguido de cierto dolor de cabeza por el frío."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Sorprendentemente apetecible."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Sorprendentemente apetecible."
	DESCRIBE.POLARCRABLEGS = "Los chicos han estado muy quisquillosos para probarlas. ¡Así queda más para mí!"
	DESCRIBE.POLARFLEAEGGSACK = "Un saco ovipositorio. Francamente desagradable."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Congelada más allá de toda medida."
	DESCRIBE.BLUEGEM_SHARDS = "La materia no se crea ni se destruye, solo se hace pedazos."
	DESCRIBE.EMPEROR_EGG = "La pobre criatura no eclosionará, pero aún puede encontrar un propósito."
	DESCRIBE.MOOSE_POLAR_ANTLER = "No era exactamente lo que entendía por \"estudiarlo\"... pero esto puede funcionar."
	DESCRIBE.PETALS_POLAR = "Cada parte de esta planta está cargada de colchicina... lo que significa que aconsejo no ingerirla."
	DESCRIBE.PETALS_POLAR_DRIED = "El proceso de secado realza el aroma."
	DESCRIBE.POLAR_DRYICE = "Dióxido de carbono sólido."
	DESCRIBE.POLARBEARFUR = "Debería lavarla... nunca se es demasiado prudente con las pulgas."
	DESCRIBE.POLARWARGSTOOTH = "Ni una sola caries. Eso sí se lo reconozco."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Tiene la forma adecuada para algunas aplicaciones."
	DESCRIBE.ARMORPOLAR = "¡Comodidad y protección!"
	DESCRIBE.COMPASS_POLAR = "Parece apuntar hacia un lugar distinto al de las otras brújulas."
	DESCRIBE.EMPEROR_PENGUINHAT = "Supongo que un gobernante debe mantener la cabeza fría."
	DESCRIBE.FROSTWALKERAMULET = "Fascinante. Solidifica el agua mediante una regulación térmica acelerada."
	DESCRIBE.ICICLESTAFF = "Un lanzamiento preciso vale más que dos errados."
	DESCRIBE.POLAR_SPEAR = "Rudimentaria, pero sumamente duradera en el frío."
	DESCRIBE.POLARAMULET = "En condiciones normales, calificaría estas curiosidades de absurdas."
	DESCRIBE.POLARBEARHAT = "Es lo suficientemente envolvente para mantener la ventisca fuera de mi cara."
	DESCRIBE.POLARCROWNHAT = "Aprovecha gradientes de frío para proteger y atacar conforme las partículas se comprimen."
	DESCRIBE.POLARFLEA_SACK = "No estoy muy segura de esto de... domesticar insectos."
	DESCRIBE.POLARICESTAFF = "Un buen golpe devuelve a todos sus modales."
	DESCRIBE.POLARMOOSEHAT = "Para conservar el calor mientras el frío arrecia."
	DESCRIBE.WALRUS_BAGPIPE = "Un instrumento de liderazgo, o eso parece."
	DESCRIBE.WALRUS_BEARTRAP = "Un mecanismo de resorte letal."
	DESCRIBE.WINTERS_FISTS = "No, querida, dije \"Festín\". Como en... ah, lo que sea."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "El símbolo de una costumbre social, apreciada tanto por los Ursidae como por los franceses."
	DESCRIBE.BOAT_ICE_ITEM = "El dispositivo de transporte más peligroso que he visto hasta ahora. Mis aplausos."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Horología combinada con magia. Verdaderamente fascinante.",
		RECHARGING = "Parece necesitar algo de tiempo para reponer su energía entre usos.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Qué extraño. ¿Alguien lo ha tocado recientemente?",
		INUSE = "Oh, cielos... ¿estaban todos preparados para esto?",
		REFUEL = "Lo sensato sería guardar bajo llave esta... cosa.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Hay posibilidades de que aún esté vivo."
	DESCRIBE.POLARICEPACK = "Hace maravillas cuando se sella en un espacio hermético."
	DESCRIBE.POLARTRINKET_1 = "Un peculiar y acogedor hombrecillo."
	DESCRIBE.POLARTRINKET_2 = "Una peculiar y acogedora mujercita."
	DESCRIBE.TRAP_POLARTEETH = "Una interesante aplicación de la criogenia."
	DESCRIBE.TURF_POLAR_CAVES = "El suelo. Se pisa."
	DESCRIBE.TURF_POLAR_DRYICE = "El suelo. Se pisa."
	DESCRIBE.TURF_POLAR_GRASS = "El suelo. Se pisa."
	DESCRIBE.WALL_POLAR = "Barreras de hielo, frígidas y formidables."
	DESCRIBE.WALL_POLAR_ITEM = "Componentes estructurales para barreras glaciales."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "No hay que olvidar los clásicos."
	DESCRIBE.WX78MODULE_NAUGHTY = "Es una mala influencia para los chicos."
