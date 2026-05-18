local ANNOUNCE = STRINGS.CHARACTERS.WENDY
local DESCRIBE = STRINGS.CHARACTERS.WENDY.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡No puedes huir de lo inevitable!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "Vamos a mandarte a dormir."
	ANNOUNCE.BATTLECRY.WALRUS = "¡Prepárense para morir! ¡Todos ustedes!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Ya se fue. Pero la vergüenza sigue pegada a mí."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Cadenas de frío... jalándome hacia abajo...",
		"Cada paso es más lento que el anterior...",
		"No me parece gracioso... Abby...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "Vivirá un día más, pero ahora en eterna vergüenza."
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¿Ya es el fin?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Suéltame!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Esa es una forma de ahogarse."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "...Esperaba otra cosa."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Que continúe la cacería. Tengo hambre."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "Mis sentidos se apagan de nuevo..."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "El frío se filtra hasta mi alma."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "La nieve fría se desangró."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Incluso en llamas, se mantiene erguido con dignidad.",
		BURNT = "No te desmorones, déjame acabar contigo.",
		CHOPPED = "Encontró su fin a nuestras manos.",
		GENERIC = "Creo que es... bonito.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Quizás yo esté completamente congelada antes de que termine de crecer."
	DESCRIBE.FLOWER_POLAR = "Pronto será enterrada viva bajo la nieve. Qué poético."
	DESCRIBE.ICELETTUCE_SEEDS = "Es una planta esperando ser."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Intentará llevarse otra vida en su caída."
	DESCRIBE.POLAR_ICICLE_ROCK = "Oh. Llegué demasiado tarde."
	DESCRIBE.ROCK_POLAR = "Algunos pedazos son más fríos que otros."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Sal."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Un agujero que está cerrado... extraño, ¿verdad?" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "¿Tendrán lugar estas murallas para otra alma fría?",
		PENGUIN = "Está bien. Los demás perecerán en tu lugar.",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "¡Quiero hacerlo pedazos!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "¿Planean tomar el continente?",
		HOSTILE = "¿Eres digno, gobernador?",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Ser picoteado por pedernal suena... desagradable."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Su canción es hipnotizante... ¡pero tan completamente desafinada!"
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Heehee...",
		GENERIC = "Esos cuernos te importan mucho, ¿eh?",
	}
	DESCRIBE.MOOSE_SPECTER = "No, Abigail, no creo que podamos quedarnos con él."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Qué bonitos ojos guardan tus cuencas."
	DESCRIBE.POLARBEAR = {
		DEAD = "Te echaremos de menos, quizás.",
		ENRAGED = "Sabía que esto era demasiado fácil.",
		FOLLOWER = "Ahora es mi peluche.",
		GENERIC = "Un depredador nacido del hielo.",
	}
	DESCRIBE.POLARBEARKING = "Las leyendas dicen que engañó a la muerte, siguiendo sus propias reglas."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¿No deberíamos estar corriendo?",
		HELD_INV = "Ejem, ¿me disculpas?",
		HELD_BACKPACK = "Por una vez, una mascota que quizás pueda mantener viva.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Debe correr más sangre de insecto."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "¿Quieres llevarme a algún lugar?",
		FRIEND = "Oh. ¿Te dejé morir de hambre?",
		GENERIC = "Una sombra astuta en la nieve.",
	}
	DESCRIBE.POLARWARG = "El campeón de la tundra."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Esto grita una desesperada necesidad de admiración."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Tiene pinta de ser el tipo que juega con la vida de los demás."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "¿Qué ha hecho para merecer semejante elogio?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "El mundo es su escenario. Hasta que se derrita."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "La llama hace mucho que se apagó.",
		ON = "Fuego en una canasta.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "En este estado no me dará mucho calor."
	DESCRIBE.POLAR_THRONE = "Podría sentarme aquí y morir congelada."
	DESCRIBE.POLAR_THRONE_GIFTS = "Qué tentador. Quizás abra solo uno."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Está alejado de los demás por alguna razón.",
		OPEN = "¿Puedes enseñarme tu arte?",
	}
	DESCRIBE.POLARBEAR_RUG = "Me gusta."
	DESCRIBE.POLARBEARHEAD = "Te lo prometo, cuidaré mejor al próximo."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ya no es refugio del frío mordiente.",
		GENERIC = "Hicieron sus tumbas aquí.",
	}
	DESCRIBE.POLARHEADSTICK = "Lo que importa es la anticipación."
	DESCRIBE.POLARICE_PLOW = "A ver si no me ahogo en las profundidades heladas."
	DESCRIBE.POLARICE_PLOW_ITEM = "Para encontrar peces, y quizás más si tenemos mala suerte."
	DESCRIBE.POLARWALRUSHEAD = "En algún lugar, un niño llora."
	DESCRIBE.TOWER_POLAR_FLAG = "Nada en el silencio, olvidada por todos."
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Oh, pisé esa pobre bandera. Lo haré de nuevo."
	DESCRIBE.RAINOMETER.POLARSTORM = "¿Vamos a morir?"
	DESCRIBE.WINTEROMETER.POLARSTORM = "El mundo se está congelando."
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Un bocado de tormenta de nieve."
	DESCRIBE.FILET_O_FLEA = "Quería una golosina, no una amenaza."
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Es para morirse."
	DESCRIBE.ICELETTUCE = "La cosecha de este año fue de lo más decepcionante."
	DESCRIBE.ICELETTUCE_OVERSIZED = "¿Qué hizo este cultivo para merecer tanto amor y cuidado?"
	DESCRIBE.ICEBURRITO = "Mi corazón congelado no sentirá el cambio."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Un destino delicioso. Más koalefantes deben conocerlo."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Un destino delicioso. Más koalefantes deben conocerlo."
	DESCRIBE.POLARCRABLEGS = "¡Le arrancamos las patas una por una!"
	DESCRIBE.POLARFLEAEGGSACK = "La vida espera adentro."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "Es un recipiente demasiado pequeño para tanta energía."
	DESCRIBE.BLUEGEM_SHARDS = "Roto como, hm... tantas otras cosas."
	DESCRIBE.EMPEROR_EGG = "Si hay algo adentro, lleva mucho tiempo muerto."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Pero puedes quedarte con esto si quieres."
	DESCRIBE.PETALS_POLAR = "Vivo... no vivo, vivo... bueno."
	DESCRIBE.PETALS_POLAR_DRIED = "Me gusta cómo huelen."
	DESCRIBE.POLAR_DRYICE = "Fantasmal."
	DESCRIBE.POLARBEARFUR = "Carga el peso de su pérdida, y de sus parásitos."
	DESCRIBE.POLARWARGSTOOTH = "¿Cómo se sentiría tener dagas por dientes?"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Otro hueso de árbol."
	DESCRIBE.ARMORPOLAR = "Estrangularse a uno mismo con calidez."
	DESCRIBE.COMPASS_POLAR = "A donde sea que apunte, parece tenerle bastante miedo."
	DESCRIBE.EMPEROR_PENGUINHAT = "La corona ha caído. No volverá a levantarse."
	DESCRIBE.FROSTWALKERAMULET = "Ni el agua puede escapar del frío abrazo de la muerte."
	DESCRIBE.ICICLESTAFF = "Ten cuidado con eso, Abigail."
	DESCRIBE.POLAR_SPEAR = "Con el tiempo se hará pedazos."
	DESCRIBE.POLARAMULET = "Macabro pero bien merecido."
	DESCRIBE.POLARBEARHAT = "Es... divertido."
	DESCRIBE.POLARCROWNHAT = "Extenderé el abrazo del invierno."
	DESCRIBE.POLARFLEA_SACK = "Un almacén para pequeños parásitos."
	DESCRIBE.POLARICESTAFF = "Un pulso de frío que requiere esfuerzo. Muy parecido a mi corazón."
	DESCRIBE.POLARMOOSEHAT = "Ni yo sé de quién está hecho."
	DESCRIBE.WALRUS_BAGPIPE = "Su canción resuena con tristeza."
	DESCRIBE.WALRUS_BEARTRAP = "Como una tumba esperando ser llenada..."
	DESCRIBE.WINTERS_FISTS = "¿Qué tal un poco de lucha de brazos, señor Wolfgang?"
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¿Debería escribir algo encima? Como: \"Ven y apuñálame\"."
	DESCRIBE.BOAT_ICE_ITEM = "Esto saldrá terriblemente mal. Voy."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Es reconfortante ver los segundos pasar.",
		RECHARGING = "Su energía se ha agotado.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Esto se ve tan frágil...",
		INUSE = "Ya veo. Romperlo tendría consecuencias duraderas.",
		REFUEL = "Ya no puedo agitarlo más. Qué lástima.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Estás más seguro adentro, pez. No intentes escapar."
	DESCRIBE.POLARICEPACK = "Te espera una larga existencia de frío y oscuridad en el refri."
	DESCRIBE.POLARTRINKET_1 = "Lo llevaría hasta el fin del mundo."
	DESCRIBE.POLARTRINKET_2 = "Lo llevaría hasta el fin del mundo."
	DESCRIBE.TRAP_POLARTEETH = "¿Me dejas terminarlos a mí? Por favorcito..."
	DESCRIBE.TURF_POLAR_CAVES = "Suelo frío."
	DESCRIBE.TURF_POLAR_DRYICE = "Piedra fría bajo mis pies."
	DESCRIBE.TURF_POLAR_GRASS = "Suelo frío."
	DESCRIBE.WALL_POLAR = "Ay, no se derretirán fácilmente."
	DESCRIBE.WALL_POLAR_ITEM = "Partes de una prisión de hielo para encerrarme."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Algunos adornos reconfortan el alma, mientras que otros..."
	DESCRIBE.WX78MODULE_NAUGHTY = "Se ve tan frágil... esperemos que no le ocurra ningún trágico accidente."
