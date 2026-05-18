local ANNOUNCE = STRINGS.CHARACTERS.WOLFGANG
local DESCRIBE = STRINGS.CHARACTERS.WOLFGANG.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Wah-ja-ja!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Es momento de una buena pelea!"
	ANNOUNCE.BATTLECRY.WALRUS = "Gran error. ¡Wolfgang te caza ahora!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "¿Hmm? ¡Jaj! Le ganaste a Wolfgang."
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"¡Los pies ya están fríos!",
		"D-debo... vencer a la nieve.",
		"Brrr...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "La corona era muy grande para los hombros del pajarito."
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¿El cielo siempre fue tan azul?"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Eek! ¡La lengua tiene bíceps!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "El hielo ya está muy débil aquí."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "¡Me gusta el regalo!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "La presa está cerca. ¡Puedo olerla!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "¿Se cayó la nariz?"
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "A Wolfgang no le gusta la nieve en los zapatos."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "¡Jaj! Nadie puede detener a Wolfgang."
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "¡Los cuernos están ardiendo!",
		BURNT = "El árbol se ve más aterrador ahora.",
		CHOPPED = "Wolfgang necesita mejores oponentes.",
		GENERIC = "¿Árbol con cuernos? ¿El árbol quiere pelear?",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Crecerá fuerte y frío."
	DESCRIBE.FLOWER_POLAR = "Es bonita, cuando no está escondida."
	DESCRIBE.ICELETTUCE_SEEDS = "Son semillitas pequeñas para enterrar."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "¿Mmm? Debe haber sido el viento."
	DESCRIBE.POLAR_ICICLE_ROCK = "¿Oh, la roca de hielo quiere saludar?"
	DESCRIBE.ROCK_POLAR = "Demasiado frío para levantar."
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "¿Algo se está escondiendo?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "Hm... el agujero todavía no está terminado." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "El castillo es fuerte como Wolfgang, pero se derrite, no como Wolfgang.",
		PENGUIN = "¡Para, amigo! Podemos hacer un show de circo juntos.",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "Lo podría aplastar fácilmente."
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Él es el jefe de la pista aquí.",
		HOSTILE = "¡Músculos contra aletas!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Alguien tiene que defender a los débiles."
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "¿La señora también tiene bigote? Wolfgang necesita un momento para pensar..."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "Está llorando cubitos de hielo.",
		GENERIC = "Una buena bestia para luchar.",
	}
	DESCRIBE.MOOSE_SPECTER = "¡AAAH! ¡ Wolfgang lo siente!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Tiene una cara espeluznante."
	DESCRIBE.POLARBEAR = {
		DEAD = "¡El oso era fuerte. Pero Wolfgang es más fuerte!",
		ENRAGED = "Es... un poco intimidante.",
		FOLLOWER = "A Wolfgang le gusta luchar de brazos con el amigo.",
		GENERIC = "¡Wolfgang respeta al oso!",
	}
	DESCRIBE.POLARBEARKING = "¿Es verdad que el oso luchó con dos vargos a la vez... con una sola mano?"
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Eek!",
		HELD_INV = "No se soltará sin pelear.",
		HELD_BACKPACK = "Wolfgang no aplastará al bicho, si el bicho se porta bien.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Oh mamá..."
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Pequeño pero lindo.",
		FRIEND = "Ay, tiene demasiada hambre para seguir.",
		GENERIC = "¡Ja! ¡Es una criatura pequeña!",
	}
	DESCRIBE.POLARWARG = "¿El cachorro tiene abrigo nuevo?"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Es muy inapropiado."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "¡Wolfgang también puede hacerlo. ¡Con estas estatuas!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "¿Alguien quiere esculpir a Wolfgang flexionando?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Mejor no apoyar el hombro en eso."
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Es un tazón para llenar de fuego.",
		ON = "Tazón de luz y calor.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "¡Lo hizo pequeño!"
	DESCRIBE.POLAR_THRONE = "Es asiento para trasero grande."
	DESCRIBE.POLAR_THRONE_GIFTS = "¡Si Wolfgang puede levantarlo, Wolfgang puede tomarlo!"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Tengo mal presentimiento sobre esto.",
		OPEN = "Está un poco o-oscuro aquí...",
	}
	DESCRIBE.POLARBEAR_RUG = "Ja. A este lo recuerdo."
	DESCRIBE.POLARBEARHEAD = "Ha visto días más felices."
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "El pez grande tuvo una vida difícil.",
		GENERIC = "El oso venció al pez grande.",
	}
	DESCRIBE.POLARHEADSTICK = "Aquí va algo fuerte, no Wolfgang sin embargo."
	DESCRIBE.POLARICE_PLOW = "¿De verdad es tan profundo...?"
	DESCRIBE.POLARICE_PLOW_ITEM = "Para cavar hoyos profundos."
	DESCRIBE.POLARWALRUSHEAD = "¡Ja! El hombre blandengue yace en los caños. ¡Es lo que más le gusta al hombre blandengue!"
	DESCRIBE.TOWER_POLAR_FLAG = "Wolfgang cree que es bonito."
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Está bien, te conseguiremos un nuevo hogar."
	DESCRIBE.RAINOMETER.POLARSTORM = "¿Está temblando el mundo entero?"
	DESCRIBE.WINTEROMETER.POLARSTORM = "¿Por qué tiembla? ¿Estoy temblando yo?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "¡No se derrite, pero hace psshh en el aire!"
	DESCRIBE.FILET_O_FLEA = "La proteína es proteína. ¿Verdad?"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Huele bien, ¿debe saber bien?"
	DESCRIBE.ICELETTUCE = "Las hojas están muy crujientes..."
	DESCRIBE.ICELETTUCE_OVERSIZED = "¡Lo llevaré a la olla! Pero con guantes."
	DESCRIBE.ICEBURRITO = "Es el primer burrito que sobrevive el agarre de Wolfgang."
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Mmm. ¡Wolfgang debería ir de caza más seguido!"
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Mmm. ¡Wolfgang debería ir de caza más seguido!"
	DESCRIBE.POLARCRABLEGS = "Del bicho asustador con patas al bicho sabroso con patas."
	DESCRIBE.POLARFLEAEGGSACK = "¡No estoy listo para ser madre!"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "¡Hace cosquillas en la mano!"
	DESCRIBE.BLUEGEM_SHARDS = "Es muy pequeño. ¡Necesito hacer uno grande!"
	DESCRIBE.EMPEROR_EGG = "¡Oh no, dejaron al bebé congelado atrás!"
	DESCRIBE.MOOSE_POLAR_ANTLER = "Muy apenado."
	DESCRIBE.PETALS_POLAR = "Sigue siendo bonito en las manos, pero menos."
	DESCRIBE.PETALS_POLAR_DRIED = "Wolfgang aprecia la delicada fragancia."
	DESCRIBE.POLAR_DRYICE = "Más fuerte que el hielo."
	DESCRIBE.POLARBEARFUR = "¡Ja-ja! Ahora haré una alfombra."
	DESCRIBE.POLARWARGSTOOTH = "Diente del cachorro más grande."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Buen palo para caminar y golpear."
	DESCRIBE.ARMORPOLAR = "No se pongan demasiado cómodos ahora, músculos."
	DESCRIBE.COMPASS_POLAR = "Incómodo tanto de leer como de sostener. ¡Brrrr!"
	DESCRIBE.EMPEROR_PENGUINHAT = "¿Rey de los pájaros que caminan chistoso? ¡Es una gran responsabilidad para Wolfgang!"
	DESCRIBE.FROSTWALKERAMULET = "El hielo mejor no se desmorone bajo los poderosos pasos de Wolfgang."
	DESCRIBE.ICICLESTAFF = "No es tan divertido como lanzar puñetazos."
	DESCRIBE.POLAR_SPEAR = "¡Es hielo pero con punta!"
	DESCRIBE.POLARAMULET = "¡Wolfgang lo usa mejor!"
	DESCRIBE.POLARBEARHAT = "No se preocupen, no soy el oso, solo soy Wolfgang."
	DESCRIBE.POLARCROWNHAT = "Mantiene el mal viento afuera y el buen viento adentro."
	DESCRIBE.POLARFLEA_SACK = "Circo de pulgas portátil."
	DESCRIBE.POLARICESTAFF = "Volveré a traer el invierno a la existencia."
	DESCRIBE.POLARMOOSEHAT = "¿El oso perdió su sombrero?"
	DESCRIBE.WALRUS_BAGPIPE = "¡Wolfgang sopla, y toda Escocia lo seguirá!"
	DESCRIBE.WALRUS_BEARTRAP = "No puede detener a Wolfgang... pero Wolfgang mejor evitarlo."
	DESCRIBE.WINTERS_FISTS = "Siempre listo para pelear, y para lanzar bolas de nieve."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¡El payaso puede ser bueno en su juego, pero Wolfgang hará su mejor esfuerzo!"
	DESCRIBE.BOAT_ICE_ITEM = "Wolfgang no tiene miedo, sus piernas solo están frías..."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "Es solo un relojito.",
		RECHARGING = "El relojito está durmiendo ahora.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "A Wolfgang le gusta la bola de nieve bonita.",
		INUSE = "¿Wolfgang sacudió demasiado fuerte?",
		REFUEL = "Es solo una bola extraña.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Pensé que pescar en el hielo sería más difícil."
	DESCRIBE.POLARICEPACK = "Mantiene las cosas muy frescas por más tiempo."
	DESCRIBE.POLARTRINKET_1 = "¡Demasiado orgulloso del bigote para esconderlo del frío!"
	DESCRIBE.POLARTRINKET_2 = "La pequeña mujer de nieve no le tiene miedo al frío."
	DESCRIBE.TRAP_POLARTEETH = "Para convertir al monstruo en saco de golpes."
	DESCRIBE.TURF_POLAR_CAVES = "Piedras frías para pisar."
	DESCRIBE.TURF_POLAR_DRYICE = "Piedras frías para pisar."
	DESCRIBE.TURF_POLAR_GRASS = "Piedras frías para pisar."
	DESCRIBE.WALL_POLAR = "¡Veo a un hombre guapo atrapado adentro!"
	DESCRIBE.WALL_POLAR_ITEM = "¡Gran trozo de hielo!"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Es bonito. Muy frágil."
	DESCRIBE.WX78MODULE_NAUGHTY = "¿Son botanas de robot, verdad?"
