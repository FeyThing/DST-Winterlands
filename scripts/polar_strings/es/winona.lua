local ANNOUNCE = STRINGS.CHARACTERS.WINONA
local DESCRIBE = STRINGS.CHARACTERS.WINONA.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Las cosas se están poniendo plumosas!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Ven a pelear!"
	ANNOUNCE.BATTLECRY.WALRUS = "¡El cazador se convierte en presa, ¿eh?"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "¡Ja! Debo haber parecido una tonta cargando esto."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"No puedo parar... no quiero... está bien, me detengo.",
		"No estoy aflojando... solo marcando el ritmo...",
		"Uf... ¡necesito un respiro de ahí adentro!",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡Tanta pluma para tan poca columna vertebral!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¡Uf! Terminó. ¿Y está... nevando?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "Qué asco, no es una buena vista desde aquí arriba..."
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "No. Mala idea."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Al menos algunos jefes dejan regalos."
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "Huh. Estoy captando ESE olor como nunca antes."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "El olor se fue. Por fin."
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "¡Ay! ¡No estoy vestida para esto!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Y ahora a pasar por el escurridor..."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "¡Arde, arbolito, arde!",
		BURNT = "Está esparciendo cenizas en la nieve.",
		CHOPPED = "Tenía más ladrido que... ya sabes.",
		GENERIC = "Se ve afilado, pero yo tengo cosas más afiladas.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "¿Crecería más rápido bajo el sol?"
	DESCRIBE.FLOWER_POLAR = "Debe estar calentando por aquí."
	DESCRIBE.ICELETTUCE_SEEDS = "No tengo idea de qué crecería de esto."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Claro. ¡Mi casco!"
	DESCRIBE.POLAR_ICICLE_ROCK = "Espero que me estén pagando un bono de peligro por todo esto."
	DESCRIBE.ROCK_POLAR = "No me molesta para nada."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Lo que sea que esté debajo, es un misterio."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Ay, todavía no puedo ir más profundo." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Torres altas y pisos resbaladizos no combinan bien.",
		PENGUIN = "Sigue malabarando mientras me encargo de tus matones.",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Dicen que cada uno es único. Por fuera y por dentro."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Solo mostrando tu riqueza, ya veo.",
		HOSTILE = "¡Vaya, tiene movimientos!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Pica, apuñala. Pero peor: ¡su pluma hace cosquillas!"
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Me está mirando como si fuera la cena de esta noche."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Se metió de cabeza en problemas, ¿eh?",
		GENERIC = "Se ve duro. Hora de averiguarlo.",
	}
	DESCRIBE.MOOSE_SPECTER = "Por ahora solo quiero observarlo."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Demasiado llamativo para mi gusto, pero igual está en el menú."
	DESCRIBE.POLARBEAR = {
		DEAD = "¡Noqueado!",
		ENRAGED = "¡Ay, tenemos problemas con el oso!",
		FOLLOWER = "Entonces, ¿cuál es tu pescado favorito?",
		GENERIC = "No me des la espalda fría.",
	}
	DESCRIBE.POLARBEARKING = "Dicen que él mismo excavó toda esa cueva de hielo. Pero no me lo creo."
	DESCRIBE.POLARFLEA = {
		GENERIC = "Sé mejor que acercarme a esas cosas.",
		HELD_INV = "¡Qué asco! ¡Fuera!",
		HELD_BACKPACK = "Aquí mando yo. Muerdes cuando yo lo diga.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "¡Qué cosa tan horrible!"
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Tú consigues conejos y yo preparo la cena. Simple.",
		FRIEND = "¿Acaso olvidé mi parte del trato?",
		GENERIC = "¡Ven aquí, pequeño pícaro!",
	}
	DESCRIBE.POLARWARG = "No tengo dudas de que tiene aliento mentolado."
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Parece que alguien olvidó su cinturón en el gran día."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "A ese le encantaría verse bajo mis reflectores."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "Oh. Perdón. ¿Estaba poniendo los ojos en blanco muy fuerte?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Espero que esté bien atornillado."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "¡Enciende el fuego!",
		ON = "El diseño me resulta familiar... debo estar imaginándolo.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Una fuente de luz práctica."
	DESCRIBE.POLAR_THRONE = "Una muestra de poder y pereza."
	DESCRIBE.POLAR_THRONE_GIFTS = "Los pequeños ayudantes los han mantenido limpios."
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Estoy mejor afuera que en esta choza de mala calidad.",
		OPEN = "Amigo, ¿alguna vez oíste hablar de la iluminación adecuada? Da miedo aquí adentro.",
	}
	DESCRIBE.POLARBEAR_RUG = "Ese es un tapete bastante grande."
	DESCRIBE.POLARBEARHEAD = "Hablando de cosas de miedo. ¡Uf!"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Hm. Probablemente otro incendio forestal.",
		GENERIC = "Hay algo sospechoso en esto.",
	}
	DESCRIBE.POLARHEADSTICK = "Veo que alguien está planeando con cabeza."
	DESCRIBE.POLARICE_PLOW = "Debería alejarme un poco."
	DESCRIBE.POLARICE_PLOW_ITEM = "Ya basta de esconderse, pececitos."
	DESCRIBE.POLARWALRUSHEAD = "¿Esto resuelve el problema de la morsa? ¿O necesitamos más?"
	DESCRIBE.TOWER_POLAR_FLAG = "¡Míralo ondear!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "No tengo mucho uso para ti, banderita."
	DESCRIBE.RAINOMETER.POLARSTORM = "¿Qué le pasa?"
	DESCRIBE.WINTEROMETER.POLARSTORM = "No hace TANTO frío, ¿o sí?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "La nieve no es nada después de comer esto."
	DESCRIBE.FILET_O_FLEA = "Debí haber revisado la olla dos veces."
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "¡Me desconecto de esto!"
	DESCRIBE.ICELETTUCE = "¿En perfectas condiciones? ¡Está prácticamente crioconservada!"
	DESCRIBE.ICELETTUCE_OVERSIZED = "¡Espero que a todos les guste la ensalada!"
	DESCRIBE.ICEBURRITO = "Justo lo que necesitaba para cerrar el día."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "¡¿Y esas morsas hacen esto con solo sus dos aletas?!"
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "¡¿Y esas morsas hacen esto con solo sus dos aletas?!"
	DESCRIBE.POLARCRABLEGS = "Estoy bien con solo un pequeño toque de lujo."
	DESCRIBE.POLARFLEAEGGSACK = "Estas cositas se resbalan más que un jabón mojado."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "No voy a agarrar esto sin guantes."
	DESCRIBE.BLUEGEM_SHARDS = "Estoy bastante segura de que el frío solo los pegaría de nuevo."
	DESCRIBE.EMPEROR_EGG = "(Toc toc) Aquí hay material de primera."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Peleaste bien, amigo."
	DESCRIBE.PETALS_POLAR = "No huele a nada..."
	DESCRIBE.PETALS_POLAR_DRIED = "Están bien secos."
	DESCRIBE.POLAR_DRYICE = "Ponlo en la línea de ensamblaje de hielo."
	DESCRIBE.POLARBEARFUR = "Es cálido, y lo más importante: es mío."
	DESCRIBE.POLARWARGSTOOTH = "No creo que los usara para comer plantas."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Esto podría ser útil."
	DESCRIBE.ARMORPOLAR = "Tan resistente como puede llegar a ser el cuero."
	DESCRIBE.COMPASS_POLAR = "¿Cómo puedo leerte temblando así?!"
	DESCRIBE.EMPEROR_PENGUINHAT = "Me veo bien. Literalmente."
	DESCRIBE.FROSTWALKERAMULET = "Esto evitará que resbale en el trabajo. ¡Ja!"
	DESCRIBE.ICICLESTAFF = "No descuidaría las condiciones del viento con esto."
	DESCRIBE.POLAR_SPEAR = "Pfft. Está bien. Si vives en un congelador..."
	DESCRIBE.POLARAMULET = "Dijeron que todos son únicos o algo así."
	DESCRIBE.POLARBEARHAT = "Supongo que dos cabezas son mejor que una."
	DESCRIBE.POLARCROWNHAT = "No puedes sudar si no puedes sudar para nada."
	DESCRIBE.POLARFLEA_SACK = "Si te metes conmigo, te metes con mis bichos."
	DESCRIBE.POLARICESTAFF = "Hay que congelar para complacer."
	DESCRIBE.POLARMOOSEHAT = "Oye, Woodie. ¿Todavía tienes toda tu parte trasera?"
	DESCRIBE.WALRUS_BAGPIPE = "Mis oídos todavía zumban por culpa de esto."
	DESCRIBE.WALRUS_BEARTRAP = "Eso te va a atrapar bien."
	DESCRIBE.WINTERS_FISTS = "Una herramienta para hacer bolas de nieve... que golpean como bloques de cemento."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "La caballa de la burla ataca cuando menos lo esperamos."
	DESCRIBE.BOAT_ICE_ITEM = "Le doy máximo treinta segundos."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "No me molestaría echarle un vistazo por dentro.",
		RECHARGING = "No parece estar funcionando ahora mismo.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "¡Ja! A Charlie le encantaban estas cositas.",
		INUSE = "Oh, tú...",
		REFUEL = "No sé cómo se filtró. Pero así está mejor.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Huh. ¡Pescado gratis!"
	DESCRIBE.POLARICEPACK = "Ese poquito de hielo llegó muy lejos."
	DESCRIBE.POLARTRINKET_1 = "Qué bonita bufanda. Ojalá yo tuviera una también."
	DESCRIBE.POLARTRINKET_2 = "Er, parece que confundieron dos líneas de producción."
	DESCRIBE.TRAP_POLARTEETH = "Cruel pero ingenioso."
	DESCRIBE.TURF_POLAR_CAVES = "Un trozo de suelo."
	DESCRIBE.TURF_POLAR_DRYICE = "Un trozo de camino."
	DESCRIBE.TURF_POLAR_GRASS = "Un trozo de suelo herboso."
	DESCRIBE.WALL_POLAR = "Sí, bastante bonito en hielo."
	DESCRIBE.WALL_POLAR_ITEM = "Hora de armar."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Nada dice invierno como esto."
	DESCRIBE.WX78MODULE_NAUGHTY = "¡WX, deja de dejar estas cosas tiradas!"
