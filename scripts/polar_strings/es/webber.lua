local ANNOUNCE = STRINGS.CHARACTERS.WEBBER
local DESCRIBE = STRINGS.CHARACTERS.WEBBER.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Hey! ¡Nada de picotazos!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Ya es hora de que hibernes!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡Este camino es nuestro!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "¿Qué? ¿Cómo? ¿QUIÉN?"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"¿Estamos... dando vueltas en círculos?",
		"Hola...? ¿Hay alguien aquí?",
		"No queremos perder a nuestros amigos en la nieve...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡Esto demuestra que las aves no nos pueden ganar!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¡El suelo se tambaleó como gelatina!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "Está bien, está bien, ¡ganaste!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Aquí es muy arriesgado."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Bueno, qué amable-"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "¡Ahora olemos todo! Y uf..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Oh. El aire ya no huele a caca."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Mamá se enojaría si me viera así..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "¿Podemos jugar en la nieve otra vez... pero con abrigo?"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "¡Muy impresionante!",
		BURNT = "Seguro se romperá pronto.",
		CHOPPED = "Uh oh, perdió una pelea.",
		GENERIC = "A los alces no les gustan. Pero nosotros los encontramos bonitos.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Casi no lo vimos entre tanta nieve..."
	DESCRIBE.FLOWER_POLAR = "Estuvieron durmiendo una buena siesta bajo la nieve."
	DESCRIBE.ICELETTUCE_SEEDS = "Podríamos cultivar algo con estas."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Mejor andamos con cuidado."
	DESCRIBE.POLAR_ICICLE_ROCK = "Hielo malvado y pequeño."
	DESCRIBE.ROCK_POLAR = "¡Qué hallazgo tan helado!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "¡Vimos algo! ¿Pero qué?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Aún no podemos ir más profundo, ¿quizás después?" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Tendríamos cuidado de no resbalarnos aquí arriba.",
		PENGUIN = "¡Hey! ¡No a la cara!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Dudo que ese se derrita en nuestra lengua."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "¡También nosotros tenemos un gran ejército! Pero el castillo aún está en construcción...",
		HOSTILE = "¡A ver quién gana, ¿de acuerdo?",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "¡No robamos ningún huevo! ¡Lo prometemos!"
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Parece que está muy a gusto con sus aletas."
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "¡Se golpeó la cabeza! Pobrecito alce...",
		ANTLER_LOST = "¡Son mucho más grandes de lo que imaginábamos!",
	}
	DESCRIBE.MOOSE_SPECTER = "Se ve un poco espeluznante..."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "¡Pescamos un tesoro de las profundidades!"
	DESCRIBE.POLARBEAR = {
		DEAD = "Ew... está cubierto de pulgas.",
		ENRAGED = "¡Lo sentimos! ¡Lo sentimos!",
		FOLLOWER = "¡Tenemos un osito de peluche gigante!",
		GENERIC = "¿Somos bienvenidos en su pequeña ciudad?",
	}
	DESCRIBE.POLARBEARKING = "Otros nos dijeron que convirtió el verano en una alfombra."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Ay!",
		HELD_INV = "¡La próxima vez mantenemos los bolsillos cerrados!",
		HELD_BACKPACK = "Mamá siempre decía que no metiéramos bichos en la mochila...",
	}
	DESCRIBE.POLARFLEA_MOTHER = "¡AAAAAHHH! Oh-- ¡así deben sentirse los demás con nuestra reina!"
	DESCRIBE.POLARFOX = {
		FOLLOWER = "¿Quieres hacer ángeles en la nieve?",
		FRIEND = "¡Nos recuerda!",
		GENERIC = "Apuesto a que tiene hambre.",
	}
	DESCRIBE.POLARWARG = "¿Quién iba a saber que el yeti tenía un cachorrito?"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Oh. Deberíamos apartar la mirada. ¿Verdad?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "¿Quién hace mejores malabares entre el emperador, Wes y Wolfgang?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "También es el rey de los presumidos."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "¡Lástima que las estatuas no puedan bailar!"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "¿Está encendido? ¡No lo vemos desde aquí abajo!",
		ON = "¡Ahhh, necesitábamos esto!",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Cualquier lugar puede ser un hogar."
	DESCRIBE.POLAR_THRONE = "Hay que escalar bastante para llegar."
	DESCRIBE.POLAR_THRONE_GIFTS = "Para... -W. ¡Ese tiene que ser nosotros!"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "¡Se parece a la cabaña que Walter describió alrededor de la fogata!",
		OPEN = "¿Pueden dejar de ver nuestros colmillos?",
	}
	DESCRIBE.POLARBEAR_RUG = "Sería una gran cama si estuviera un poco más rellena."
	DESCRIBE.POLARBEARHEAD = "¿Qué hizo para merecer esto?"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Descansa en paz... la araña del techo.",
		GENERIC = "Estaríamos mejor adentro que aquí afuera.",
	}
	DESCRIBE.POLARHEADSTICK = "Casi da más miedo estando vacío."
	DESCRIBE.POLARICE_PLOW = "Mejor nos alejamos, no queremos ver a los peces desde TAN cerca."
	DESCRIBE.POLARICE_PLOW_ITEM = "Una máquina para liberar a los peces del hielo."
	DESCRIBE.POLARWALRUSHEAD = "En cierta forma se lo merecía."
	DESCRIBE.TOWER_POLAR_FLAG = "¡Saludémoslo de vuelta!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Entonces... ¿ya es nuestro el imperio?"
	DESCRIBE.RAINOMETER.POLARSTORM = "¿No deberíamos avisarles a los demás sobre esto?"
	DESCRIBE.WINTEROMETER.POLARSTORM = "¿Pasa algo malo, señor Medidor Térmico?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "¡No se cae aunque lo tengamos al revés!"
	DESCRIBE.FILET_O_FLEA = "No está mal... aunque es un poco peludo."
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "No digas que no te gusta antes de probarlo, esa es la regla."
	DESCRIBE.ICELETTUCE = "¿Comer nuestras verduras? Pero si es todo azul."
	DESCRIBE.ICELETTUCE_OVERSIZED = "¡Hurra! Espera. ¿Vamos a comer ensalada toda la semana? No hurra."
	DESCRIBE.ICEBURRITO = "¡La leyenda dice que este burrito nunca se desarma!"
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Con razón todos los morsas están tan gorditos."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Con razón todos los morsas están tan gorditos."
	DESCRIBE.POLARCRABLEGS = "¡Tiene más patas que nosotros para repartir!"
	DESCRIBE.POLARFLEAEGGSACK = "Es más saludable que sus dulces, creo."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "¡Más brillante y más fría!"
	DESCRIBE.BLUEGEM_SHARDS = "Quizás podríamos haber tenido más cuidado."
	DESCRIBE.EMPEROR_EGG = "¿O sea que dejaron a los niños? ¿Así nada más?"
	DESCRIBE.MOOSE_POLAR_ANTLER = "¡Tenemos tus cuernos! Y... la vida, además."
	DESCRIBE.PETALS_POLAR = "A él le gusta el sabor, a mí solo me gusta cómo se ven."
	DESCRIBE.PETALS_POLAR_DRIED = "¿Las recogimos nosotros?"
	DESCRIBE.POLAR_DRYICE = "Esos quedan descartados en las guerras de nieve."
	DESCRIBE.POLARBEARFUR = "Nos conseguimos una almohada."
	DESCRIBE.POLARWARGSTOOTH = "De seguro es más afilado que el nuestro."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "¡Después de todos estos años... el palo perfecto!"
	DESCRIBE.ARMORPOLAR = "Nos gustaría usarlo para siempre... peludamente."
	DESCRIBE.COMPASS_POLAR = "Le cuesta encontrar el camino."
	DESCRIBE.EMPEROR_PENGUINHAT = "¿Eso significa que ganamos?"
	DESCRIBE.FROSTWALKERAMULET = "Mejor tener las patas frías que empapadas."
	DESCRIBE.ICICLESTAFF = "¡Ay! ¡Eso parece muy afilado!"
	DESCRIBE.POLAR_SPEAR = "¡Es como un carámbano gigante con palo!"
	DESCRIBE.POLARAMULET = "Ninguna araña resultó herida en el proceso."
	DESCRIBE.POLARBEARHAT = "¡GRRRR!! ¿Los asustamos?"
	DESCRIBE.POLARCROWNHAT = "Las arañas no son muy fanáticas del frío."
	DESCRIBE.POLARFLEA_SACK = "Para cargar a todo un batallón en nuestra espalda."
	DESCRIBE.POLARICESTAFF = "Red de hielo de emergencia."
	DESCRIBE.POLARMOOSEHAT = "Un sombrero hecho con los amigos del señor Woodie."
	DESCRIBE.WALRUS_BAGPIPE = "¡Queremos tocarlo!"
	DESCRIBE.WALRUS_BEARTRAP = "¿Quién va a picarlo?"
	DESCRIBE.WINTERS_FISTS = "No es tan incómodo cuando tienes las manos peludas."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¡Todo son bromas hasta que te toca a ti!"
	DESCRIBE.BOAT_ICE_ITEM = "Con suficientes de estos podríamos cruzar el océano de un salto."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "¿Cambiaríamos algo si pudiéramos volver en el tiempo?",
		RECHARGING = "Está descansando.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "La nieve se mueve, despacio. Demasiado despacio...",
		INUSE = "¿Eso me pondrá en la lista de los traviesos?",
		REFUEL = "Necesita nieve especial.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "¡Liberemos a Willy!"
	DESCRIBE.POLARICEPACK = "Es gracioso de sostener... p-por un momento al menos."
	DESCRIBE.POLARTRINKET_1 = "¡Queremos ropa grande como esa también!"
	DESCRIBE.POLARTRINKET_2 = "¡Queremos ropa grande como esa también!"
	DESCRIBE.TRAP_POLARTEETH = "Nuestra telaraña de hielo sigue creciendo."
	DESCRIBE.TURF_POLAR_CAVES = "Un poco de suelo que excavamos."
	DESCRIBE.TURF_POLAR_DRYICE = "¡No pises las grietas!"
	DESCRIBE.TURF_POLAR_GRASS = "Un poco de suelo que excavamos."
	DESCRIBE.WALL_POLAR = "¡Las murallas de nuestro Fuerte Helado!"
	DESCRIBE.WALL_POLAR_ITEM = "Primera regla del Fuerte Helado: no lamer las paredes."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Nos gusta mantenerlo (un poco) simple."
	DESCRIBE.WX78MODULE_NAUGHTY = "Huh. ¿Así se ven las entrañas de un robot?"
