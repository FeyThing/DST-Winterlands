local ANNOUNCE = STRINGS.CHARACTERS.WAXWELL
local DESCRIBE = STRINGS.CHARACTERS.WAXWELL.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "Estás pisando hielo delgado, amigo."
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡La mente le gana a las garras!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡Mis condolencias!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Ja, ja. Muy gracioso. Sigan riendo... ¿quién hizo esto?"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"No lo malinterpreten... pero podría usar un abrigo... y un bastón...",
		"Mis sirvientes facilitarían mucho esto...",
		"La nieve... el hielo... arruinan un traje...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¿Un gobernante? Por favor. Hizo malabares como un bufón emplumado."
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¿Quién está jugando con esa maldita cosa otra vez?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Suéltame, alimaña!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Preferiría no romper ese hielo."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Siento que hay algo más detrás de esto."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "¿Se me está poniendo... más grande la nariz, o qué?"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Y así, de vuelta a la mediocridad."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "No estoy vestido adecuadamente para esto."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "(Suspiro) Lección aprendida."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Se sacrificó por mi comodidad.",
		BURNT = "Ya no servirá de mucho, a menos que...",
		CHOPPED = "Tendrás que esforzarte más que eso, árbol.",
		GENERIC = "Bah. Cosa desvencijada... apenas se sostiene.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Insiste en crecer a pesar del frío."
	DESCRIBE.FLOWER_POLAR = "Vaya, hola."
	DESCRIBE.ICELETTUCE_SEEDS = "¿Se supone que debo plantarlas?"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Simple pero brillante."
	DESCRIBE.POLAR_ICICLE_ROCK = "No tendrás una segunda oportunidad."
	DESCRIBE.ROCK_POLAR = "Recién salido del proveedor."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Es... algo en la nieve."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Aún no terminaron de trabajar en eso." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Grandioso, frío y efímero. Como... (suspiro).",
		PENGUIN = "Construir todo un escenario para una actuación tan lamentable.",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Una exhibición caprichosa, pero completamente irrelevante."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "¿Qué parecido? ¿Es el traje? No, ¡es la clase!",
		HOSTILE = "Definitivamente no fue por su sangre fría.",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Los llamo \"Peon-güinos\"."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Bien por él... bien por él."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Ya no intimida tanto.",
		GENERIC = "Grandes cuernos, gran actitud.",
	}
	DESCRIBE.MOOSE_SPECTER = "Hmph. Qué... majestuoso."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Un conocido acuarista mío pagaría una fortuna por eso."
	DESCRIBE.POLARBEAR = {
		DEAD = "La naturaleza se encargará del resto.",
		ENRAGED = "Oh, bien. Están sacando los dientes.",
		FOLLOWER = "Por última vez: ¡NO vamos a ir a pescar!",
		GENERIC = "Son un grupo bastante curioso.",
	}
	DESCRIBE.POLARBEARKING = "Nunca había oído hablar de este tipo."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡No! ¡No!",
		HELD_INV = "Dolerá, pero no pienso quedármela como mascota.",
		HELD_BACKPACK = "No me van a obligar a cargar con esa cosa.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Esta criatura es combustible de pesadillas... en sentido figurado."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Ahora estamos juntos en esto.",
		FRIEND = "Cuánto tiempo sin verte, amigo.",
		GENERIC = "Sigue tu camino.",
	}
	DESCRIBE.POLARWARG = "Qué maravillosa adaptación."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Les aseguro que no hay estatuas así de mí. Creo."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "¿Tendrá algún significado metafórico?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "No asumiría que tomó algo de inspiración en mi obra..."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Disfruta tus días de grandeza mientras los tengas."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "No voy a mentir, me gustan los braseros.",
		ON = "Tribal. Pero funciona bien.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Cada vez me siento más como una bestia de carga."
	DESCRIBE.POLAR_THRONE = "¿Así se ve desde abajo?"
	DESCRIBE.POLAR_THRONE_GIFTS = "¿A qué juego estará jugando esta vez?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Vaya, vaya. Menuda guarida tan hospitalaria.",
		OPEN = "...Fingiré que no vi lo que hay adentro.",
	}
	DESCRIBE.POLARBEAR_RUG = "Una decoración muy... de buen gusto."
	DESCRIBE.POLARBEARHEAD = "Algunos lo llamarían un trofeo."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ojalá el sol abrasador perdonara este lugar.",
		GENERIC = "Huele a algo podrido adentro. Ugh.",
	}
	DESCRIBE.POLARHEADSTICK = "El potencial puede ser tan intimidante."
	DESCRIBE.POLARICE_PLOW = "Mejor aléjate, o serás comida de peces."
	DESCRIBE.POLARICE_PLOW_ITEM = "Los tiempos desesperados requieren medidas destructivas."
	DESCRIBE.POLARWALRUSHEAD = "En mi defensa, no me reconoció."
	DESCRIBE.TOWER_POLAR_FLAG = "Se veía mejor desde lejos."
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Buena tela. Sabía lo que hacía."
	DESCRIBE.RAINOMETER.POLARSTORM = "Ahí viene."
	DESCRIBE.WINTEROMETER.POLARSTORM = "Oh vaya..."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Con eso podrías romperle el cráneo a alguien."
	DESCRIBE.FILET_O_FLEA = "¿Que no me muera de hambre? Creo que preferiría hacerlo."
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Es un gusto adquirido."
	DESCRIBE.ICELETTUCE = "¿O sea que ahora comemos agua crujiente?"
	DESCRIBE.ICELETTUCE_OVERSIZED = "Y esta cosa ni siquiera quería que la cultiváramos."
	DESCRIBE.ICEBURRITO = "No asumo que sepa mal, pero..."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Qué cantidad de grasa. Oh, pero igual me lo como."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Qué cantidad de grasa. Oh, pero igual me lo como."
	DESCRIBE.POLARCRABLEGS = "Quedaría perfecto con mantequilla derretida."
	DESCRIBE.POLARFLEAEGGSACK = "Jamás volveré a sentirme limpio..."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Recuperaré lo que es mío, aunque haya cambiado un poco."
	DESCRIBE.BLUEGEM_SHARDS = "Brilla."
	DESCRIBE.EMPEROR_EGG = "No se puede hacer tortilla con huevos irrompibles."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Debo extraer la magia que hay dentro."
	DESCRIBE.PETALS_POLAR = "¿Alguien quiere un té?"
	DESCRIBE.PETALS_POLAR_DRIED = "Están todas marchitas."
	DESCRIBE.POLAR_DRYICE = "Me recuerda... que nunca me han esculpido en hielo."
	DESCRIBE.POLARBEARFUR = "A ver, esto es-- ¡Puaj! ¡Tantas pulgas!"
	DESCRIBE.POLARWARGSTOOTH = "Debo admitir que luce bastante elegante."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Ah, puede ser útil."
	DESCRIBE.ARMORPOLAR = "Funcional, y algo refinado."
	DESCRIBE.COMPASS_POLAR = "Me promete algo superior al Norte."
	DESCRIBE.EMPEROR_PENGUINHAT = "Qué cosa tan... emplumada."
	DESCRIBE.FROSTWALKERAMULET = "Una pena para los peces que dejo atrás. Pero bueno."
	DESCRIBE.ICICLESTAFF = "Un destino peor que los tomates podridos."
	DESCRIBE.POLAR_SPEAR = "Debo admitir que en el mejor caso solo rasgará mi traje."
	DESCRIBE.POLARAMULET = "Le hicieron algo al cordón. Exactamente qué, no sé."
	DESCRIBE.POLARBEARHAT = "Estoy profundamente asqueado."
	DESCRIBE.POLARCROWNHAT = "Poderosa y elegante, pero también incómoda."
	DESCRIBE.POLARFLEA_SACK = "Apenas preferible a morir congelado."
	DESCRIBE.POLARICESTAFF = "El hechizo correcto, en manos equivocadas."
	DESCRIBE.POLARMOOSEHAT = "Hm. Muy... rústico."
	DESCRIBE.WALRUS_BAGPIPE = "Puede que no me recuerden, pero me obedecerán."
	DESCRIBE.WALRUS_BEARTRAP = "Arruina una pierna y un buen par de pantalones."
	DESCRIBE.WINTERS_FISTS = "Un pelín demasiado brutal... en serio."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "Un hechizo para la vergüenza ajena."
	DESCRIBE.BOAT_ICE_ITEM = "No me gusta el sonido que hace, especialmente ese crujido."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Cuidado, madame. Sé a dónde lleva este camino al final.",
		RECHARGING = "Parece que ella tendrá que esperar, por una vez.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "No. Lo. Toques.",
		INUSE = "Sabía que era mala idea.",
		REFUEL = "Debería lanzarte al mar.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "¿No te da vergüenza, pez?"
	DESCRIBE.POLARICEPACK = "Esto mantendrá las bacterias a raya por más tiempo."
	DESCRIBE.POLARTRINKET_1 = "De verdad que no hay manera de escapar de estos tipos."
	DESCRIBE.POLARTRINKET_2 = "De verdad que no hay manera de escapar de estas chicas."
	DESCRIBE.TRAP_POLARTEETH = "¡Qué maldad. Me gusta!"
	DESCRIBE.TURF_POLAR_CAVES = "Suelo."
	DESCRIBE.TURF_POLAR_DRYICE = "Al menos este es útil."
	DESCRIBE.TURF_POLAR_GRASS = "Áspero."
	DESCRIBE.WALL_POLAR = "Me gustan por su toque de ambiente."
	DESCRIBE.WALL_POLAR_ITEM = "Cubos de hielo del tamaño de una pared. Ajá."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Sutil pero pintoresco."
	DESCRIBE.WX78MODULE_NAUGHTY = "Ese robot necesita ponerse las pilas."
