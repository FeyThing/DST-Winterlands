if not STRINGS.CHARACTERS.WIRLYWINGS then
	return
end

local ANNOUNCE = STRINGS.CHARACTERS.WIRLYWINGS
local DESCRIBE = STRINGS.CHARACTERS.WIRLYWINGS.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Cuac!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Qué dientes tan grandes tienes!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡MEEK! ¡Aléjate! ¡No soy comida!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Oh, bueno... eso explica algunas cosas."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"...¿Ya llegamos...?",
		"¿Podemos parar a hacer ángeles de nieve?",
		"Mmmmm-mm...!",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "Uf... ¡y no vuelvas a waddle por aquí!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¡Meek! ¿Qué está pasando?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡MEEK! ¡ME ATRAPÓ!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "¿No sería peligroso aquí?"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Muchas gracias, ¡quien sea!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "¿Quieren jugar a las escondidas con los animales del bosque?"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "¿Dónde están...? Bueno, ¡ganaron!"
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "¡Eek! ¡Se me está metiendo nieve en el gorro!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Brr... solo necesito un poco más de ropa."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "¡Bueno, al menos podemos calentarnos!",
		BURNT = "Alguna vez fue blanco como la nieve misma.",
		CHOPPED = "Ya no lo está, tenlo por seguro.",
		GENERIC = "Este árbol parece que nunca estuvo vivo.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "¡Guau! ¡El árbol muerto! ¡Está volviendo a crecer!"
	DESCRIBE.FLOWER_POLAR = "¡No sabía que las flores podían crecer aquí!"
	DESCRIBE.ICELETTUCE_SEEDS = "Una semilla de lechuga."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "¡MEEK...! ¡Qué susto me dio!"
	DESCRIBE.POLAR_ICICLE_ROCK = "Hace un tiempo estaba allá arriba."
	DESCRIBE.ROCK_POLAR = "Es un espejo, o mi hermana gemela está atrapada adentro. ¡Jeje!"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Es nieve. ¿O no? Mmm."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "No, gracias, de todas formas." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Guau. Incluso guaau.",
		PENGUIN = "¡Qué injusto! ¡Vuelve abajo!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "¡Vamos! ¡Alguien! ¡Atrápalo!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Hola. Mmm. ¿Waah?",
		HOSTILE = "¡No me tiren al calabozo!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Bien encontrado, pájaro con casco."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "¿Quién sigue? ¿El abuelo? ¿El pez dorado?"
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Lección aprendida, ¿mmm?",
		GENERIC = "Son más grandes de lo que pensaba...",
	}
	DESCRIBE.MOOSE_SPECTER = "Guau. ¡Alce de hadas!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "¡Qué pez tan bonito! ¿Lo podemos poner en una pecera?"
	DESCRIBE.POLARBEAR = {
		DEAD = "Vamos, despiértate...",
		ENRAGED = "¡Meek! ¡Cuidado!",
		FOLLOWER = "Iremos a pescar si prometes no morderme. ¿De acuerdo?",
		GENERIC = "Se ven anormalmente amigables.",
	}
	DESCRIBE.POLARBEARKING = "No tener enemigos no es excusa para no tener buenos amigos."
	DESCRIBE.POLARFLEA = {
		GENERIC = "Tiene forma de amigo. Pero no es amigo.",
		HELD_INV = "¡MEEK! ¡No voy a compartir mi sangre!",
		HELD_BACKPACK = "Mejor aquí que bajo mi gorro.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Mejor cerrar todos mis bolsillos... por si acaso."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "¡Jeje! ¿Qué encontrarás después?",
		FRIEND = "¡Mm! ¡Hola! ¡Te extrañé!",
		GENERIC = "Hola- ¡no! ¡No te vayas, podemos ser amigos!",
	}
	DESCRIBE.POLARWARG = "¡Esa es una gran bomba de hielo!"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Mm. No importa."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Debería practicar mis malabares de nuevo cuando Wes esté por aquí."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "¡Yo también quiero posar para una estatua de hielo!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "¿Puedo pedir una estatua mía después?"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "¿Es eso pelo quemado en el tazón?",
		ON = "Justo el calor que necesitaba.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "¡Puf! ¡Ahora puedo cargarlo!"
	DESCRIBE.POLAR_THRONE = "¡Yo no me siento aquí!"
	DESCRIBE.POLAR_THRONE_GIFTS = "¡Tantos regalos! Debe haber uno para mí, ¿mmm?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Aquí dentro debe sentirse solo.",
		OPEN = "¿Qué hay para hoy, Señor?",
	}
	DESCRIBE.POLARBEAR_RUG = "A los otros osos probablemente no les guste mucho..."
	DESCRIBE.POLARBEARHEAD = "¡Qué maleducado!"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Este hogar ha visto días mejores.",
		GENERIC = "Esta puerta ha visto días mejores.",
	}
	DESCRIBE.POLARHEADSTICK = "¿Por qué no poner un letrero de bienvenida?"
	DESCRIBE.POLARICE_PLOW = "¡Cuidado, el suelo se está agrietando!"
	DESCRIBE.POLARICE_PLOW_ITEM = "¿Qué podría esconderse bajo el hielo?"
	DESCRIBE.POLARWALRUSHEAD = "Curioso, este no me da casi ningún remordimiento."
	DESCRIBE.TOWER_POLAR_FLAG = "¡Jeje, me está saludando!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Te llevaré conmigo, antes de que lo haga el viento."
	DESCRIBE.RAINOMETER.POLARSTORM = "¡Sr. Wilson, su máquina está actuando raro de nuevo!"
	DESCRIBE.WINTEROMETER.POLARSTORM = "¡Para! ¡Me estás haciendo temblar también!"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Está tan frío que quema un poco..."
	DESCRIBE.FILET_O_FLEA = "Así que ahí estaba. ¡Bueno!"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Mejor compartirlo con un monstruo malvado."
	DESCRIBE.ICELETTUCE = "El peor enemigo de mi barquito de papel."
	DESCRIBE.ICELETTUCE_OVERSIZED = "De nada..."
	DESCRIBE.ICEBURRITO = "La próxima vez probaré uno de cereza."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Te agarré la nariz, en un plato."
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Te agarré la nariz, en un plato."
	DESCRIBE.POLARCRABLEGS = "Mmm... crujiente... espera, no. ¡Es el caparazón!"
	DESCRIBE.POLARFLEAEGGSACK = "Eso podría ser asco-til."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "¡Cubo de hielo MUY elegante!"
	DESCRIBE.BLUEGEM_SHARDS = "Creo que estas dos piezas van juntas. Pero esta otra..."
	DESCRIBE.EMPEROR_EGG = "Ten cuidado de no soltar al bebé."
	DESCRIBE.MOOSE_POLAR_ANTLER = "¿Para qué sirven estos siquiera?"
	DESCRIBE.PETALS_POLAR = "Teníamos de esas creciendo en casa."
	DESCRIBE.PETALS_POLAR_DRIED = "Especias diminutas."
	DESCRIBE.POLAR_DRYICE = "¿Es como piedra cortada pero hecha de aire?"
	DESCRIBE.POLARBEARFUR = "Está hecho de comodidad."
	DESCRIBE.POLARWARGSTOOTH = "Un pedazo de la boca de ese gran monstruo."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Con un buen palo se puede hacer mucho."
	DESCRIBE.ARMORPOLAR = "¡Ahora me siento el doble de segura!"
	DESCRIBE.COMPASS_POLAR = "No está apuntando hacia casa."
	DESCRIBE.EMPEROR_PENGUINHAT = "Para vestirme como una emperatriz."
	DESCRIBE.FROSTWALKERAMULET = "Espero que aguante otro paseo o dos."
	DESCRIBE.ICICLESTAFF = "Yo no iría a jugar bajo esa lluvia..."
	DESCRIBE.POLAR_SPEAR = "No es una paleta con sabor a cereza. Eso es sangre."
	DESCRIBE.POLARAMULET = "¿Me dirías qué hace, Señor?"
	DESCRIBE.POLARBEARHAT = "Estar en la boca de alguien no es nada nuevo para mí."
	DESCRIBE.POLARCROWNHAT = "No rompas mi burbuja personal."
	DESCRIBE.POLARFLEA_SACK = "Prefiero darles su propio espacio antes que quitarme el mío."
	DESCRIBE.POLARICESTAFF = "¡Mi palo tuvo una mejora!"
	DESCRIBE.POLARMOOSEHAT = "¿Puedes ver mucho con eso, cara de capucha?"
	DESCRIBE.WALRUS_BAGPIPE = "Uno, dos, ¡y uno dos tres! (Inhala)"
	DESCRIBE.WALRUS_BEARTRAP = "Cosas de metal malas."
	DESCRIBE.WINTERS_FISTS = "Ahora puedo escuchar el aullido del viento mientras las agito..."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "Una broma cruel para hacerle a los amigos."
	DESCRIBE.BOAT_ICE_ITEM = "Esto debería ser seguro, por unos pocos segundos."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "¡Qué reloj tan elegante! Muy bonito, Sra. Wanda.",
		RECHARGING = "¿Quizás no es el momento indicado?",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Ni siquiera necesito agitarlo.",
		INUSE = "¿Por qué lo agitamos?",
		REFUEL = "Ahora nada malo pasaría por agitarlo.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "¿Podemos ayudarlo a salir?"
	DESCRIBE.POLARICEPACK = "Ojalá cupiera en mi lonchera."
	DESCRIBE.POLARTRINKET_1 = "¡Qué bien abrigado se ve con esa bufanda!"
	DESCRIBE.POLARTRINKET_2 = "¡Qué bien abrigado se ve con ese gorro!"
	DESCRIBE.TRAP_POLARTEETH = "No es un buen lugar para hacer ángeles de nieve."
	DESCRIBE.TURF_POLAR_CAVES = "Comida para gusanos topos."
	DESCRIBE.TURF_POLAR_DRYICE = "No es como el camino a la escuela."
	DESCRIBE.TURF_POLAR_GRASS = "Comida para plantas y gusanos."
	DESCRIBE.WALL_POLAR = "Esta podría tener oportunidad en el cuento de los tres cerditos."
	DESCRIBE.WALL_POLAR_ITEM = "Podríamos hacer un iglú, pero sin techo."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "El adorno perfecto no exis- ¡oh!"
	DESCRIBE.WX78MODULE_NAUGHTY = "Dulces de robot de mi amigo metálico."
