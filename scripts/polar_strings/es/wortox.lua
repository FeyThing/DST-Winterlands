local ANNOUNCE = STRINGS.CHARACTERS.WORTOX
local DESCRIBE = STRINGS.CHARACTERS.WORTOX.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.PENGUIN  = "¡Baila en el hielo conmigo, pajarito!"
	ANNOUNCE.BATTLECRY.POLARBEAR = "¡Osito o no, allá voy!"
	ANNOUNCE.BATTLECRY.WALRUS = "¿Me confundiste con una presa fácil? ¡Hiuju!"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "¿Una broma al bromista? ¡Esto no puede ser!"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Brinco... ¡a brincar vamos...!",
		"Hiu... ju... ¡brrrrr!",
		"Muévanse... malditas pezuñas...",
	}
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "¡Ji-ji! ¡Miren, el trasero real huye!"
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "¿A esto le llamas broma? ¡Eso fue de mal gusto!"
	ANNOUNCE.ANNOUNCE_POLARFLEA_LATCHED = "¡Hiuj-- uf!"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "¡Solo hay cierta cantidad de hielo que destruir, pero no aquí!"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "¿Ven? A veces deberían confiar en mí-"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_HUNTMOAR = "¡Mi nariz hormiguea de travesura!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_HUNTMOAR = "¿Estoy siguiendo mis propias huellas de pezuña?"
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "D-dios mío, debo mantenerme c-caliente y seco..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "¡Nada más de nieve! ¡Casi listo para seguir!"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "¿Lo vieron venir? ¡Apuesto a que no!",
		BURNT = "Tomó un giro espeluznante y tostado.",
		CHOPPED = "Abajo cae, a descansar en la nieve.",
		GENERIC = "Puede que tengas cuernos más largos, pero yo tengo un hacha.",
	}
	DESCRIBE.ANTLER_TREE_SAPLING = "Por ahora es bebé, pero pronto se volverá viejo y reseco."
	DESCRIBE.FLOWER_POLAR = "Qué deleite para la vista."
	DESCRIBE.ICELETTUCE_SEEDS = "Démosles tierra antes de que se echen a perder."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "¡Juro que se movió! ¿O me engañaron?"
	DESCRIBE.POLAR_ICICLE_ROCK = "Debiste haber aprovechado tu oportunidad antes o después."
	DESCRIBE.ROCK_POLAR = "¿Son gemas las que vislumbro bajo la helada niebla?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "¡Hiuju! ¿Qué será?"
	DESCRIBE.CAVE_ENTRANCE_POLAR = "¡De todas formas no hay nada aquí abajo, por ahora!" -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Un punto de vista para vándalos.",
		PENGUIN = "¡Qué maleducados! ¡Qué actitud!",
	}
	DESCRIBE.TUMBLEWEED_POLAR = "¡Un copo helado con vocación de diversión!"
	
--	Mobs
	
	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "¿Una figura de autoridad? Ooo, yo no estaría tan seguro.",
		HOSTILE = "¡A ver si me agarran!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "¡Por favor, no me piquen!"
	DESCRIBE.FROSTY_SIMPLE = "Frosty"
	DESCRIBE.GIRL_WALRUS = "Cuando sus gaitas suenan, todo el clan se despliega."
	DESCRIBE.MOOSE_POLAR = {
		ANTLER_LOST = "No te preocupes, querido, volverán a crecer.",
		GENERIC = "¡Qué cuernos tan grandes tienes! ¿Me los puedo quedar?",
	}
	DESCRIBE.MOOSE_SPECTER = "La mayoría de los mortales tampoco llegan a ver diablillos, que conste."
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Un nadador prismático de las profundidades heladas."
	DESCRIBE.POLARBEAR = {
		DEAD = "¡De vuelta al polvo! O a la nieve, si lo prefieren.",
		ENRAGED = "¡No les gustan las bromas ni un mordisco!",
		FOLLOWER = "Los dos somos compañeros difíciles de aguantar, ¡hiuju!",
		GENERIC = "Parecen suficientemente amables con mi especie.",
	}
	DESCRIBE.POLARBEARKING = "Los mortales dicen que podría exprimirme el alma, ¡hiuju...! N-no pienso averiguarlo."
	DESCRIBE.POLARFLEA = {
		GENERIC = "¡Oh no! ¡No, no, no!",
		HELD_INV = "Está bien. Pronto te consumiré a cambio.",
		HELD_BACKPACK = "Esa es una forma de acumular almas.",
	}
	DESCRIBE.POLARFLEA_MOTHER = "Yo no tengo nada que ver con esto...! ¿Verdad?"
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Un astuto pequeño compañero de patas.",
		FRIEND = "¿No me recuerdas? Oh, pero tienes tanta hambre...",
		GENERIC = "¡Atrápalo antes de que se entierre seis pezuñas bajo tierra!",
	}
	DESCRIBE.POLARWARG = "¡Tiene un aullido helado que congela el alma!"
	
--	Buildings
	
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Podría empeorar esto mucho con un simple truco."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "¿Llegué a la ceremonia de coronación del bufón?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "¡Hiuju, yo también puedo sacar pecho!"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "¿La modestia? ¡Nunca la conocí!"
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "¡Los mortales deberían haber pensado en esto antes! ¡Hiuju!",
		ON = "Ahuyenta el frío, querida llama.",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Esto debería mantenerme caliente dondequiera que vague."
	DESCRIBE.POLAR_THRONE = "Estos días no lo usa mucho."
	DESCRIBE.POLAR_THRONE_GIFTS = "¡Sí, sí, esos son regalos gratis!"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "¡Lleno de travesuras, sin duda!",
		OPEN = "Vaya, amigo, ¡qué sonrisa tan pícara tienes!",
	}
	DESCRIBE.POLARBEAR_RUG = "Antes vagaba libre, ahora está bajo mis pies."
	DESCRIBE.POLARBEARHEAD = "¡Qué desagradable!"
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "Ni esta guarida helada pudo escapar de un final ardiente.",
		GENERIC = "Un escondite para calentar el alma.",
	}
	DESCRIBE.POLARHEADSTICK = "¡Espero que este no sea para mí!"
	DESCRIBE.POLARICE_PLOW = "¡Cuidado! ¡Pronto se abrirá el portal a la dimensión de los peces!"
	DESCRIBE.POLARICE_PLOW_ITEM = "Menos divertido pero más discreto que los explosivos."
	DESCRIBE.POLARWALRUSHEAD = "Antes el cazador, ahora la presa."
	DESCRIBE.TOWER_POLAR_FLAG = "No entiendo el amor de los mortales por las banderas. ¡Puro humo!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Antes era algo pomposo, pero ahora no significa nada."
	DESCRIBE.RAINOMETER.POLARSTORM = "Mejor esconderme si hasta esta máquina no puede decidir."
	DESCRIBE.WINTEROMETER.POLARSTORM = "¡Solo intentas asustarme! ¿Verdad?"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "¡Reconozco una broma cuando la veo!"
	DESCRIBE.FILET_O_FLEA = "¡Oh no! ¡Yo no tengo nada que ver con esto, lo prometo!"
	DESCRIBE.HERMITCRABTEA_PETALS_POLAR = "Sabe a mor-té-aldad."
	DESCRIBE.ICELETTUCE = "Los mortales cultivarán plantas sin importar qué tan hostiles sean."
	DESCRIBE.ICELETTUCE_OVERSIZED = "El dolor fue verdadero para cultivar tal vegetal."
	DESCRIBE.ICEBURRITO = "Supongo que podría darle una mordida. ¡Una mordida de escarcha, hiuju!"
	DESCRIBE.KOALEFRIED_TRUNK_SUMMER = "Los humanos deberían estar tomando nota... ¡solo lo digo!"
	DESCRIBE.KOALEFRIED_TRUNK_WINTER = "Los humanos deberían estar tomando nota... ¡solo lo digo!"
	DESCRIBE.POLARCRABLEGS = "Está bien, está bien, tomaré un poco de ese cangrejo."
	DESCRIBE.POLARFLEAEGGSACK = "¡Ooo, esto me está dando una idea!"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "En el aire o en una gema, tu alma seguirá siendo mía."
	DESCRIBE.BLUEGEM_SHARDS = "¡Ups! Lo rompí otra vez."
	DESCRIBE.EMPEROR_EGG = "¿Volverán por él? Mmm. ¡Mejor agarrarlo!"
	DESCRIBE.MOOSE_POLAR_ANTLER = "¡Qué lástima, para ti!"
	DESCRIBE.PETALS_POLAR = "Me parecen más agradables en la tierra."
	DESCRIBE.PETALS_POLAR_DRIED = "Lo vi, lo vigilé, se secó."
	DESCRIBE.POLAR_DRYICE = "Tan frío como puede ser, es perfecto para mí."
	DESCRIBE.POLARBEARFUR = "Un pelaje grueso para retozar en la nieve."
	DESCRIBE.POLARWARGSTOOTH = "Lo admito, este podría ser un digno contendiente."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Este palo hace el trabajo de trote."
	DESCRIBE.ARMORPOLAR = "¡Cuando el daño es un problema, añade más pelaje!"
	DESCRIBE.EMPEROR_PENGUINHAT = "¡Larga vida al pez!"
	DESCRIBE.COMPASS_POLAR = "¡No tengo com-pasión por este artilugio traicionero!"
	DESCRIBE.FROSTWALKERAMULET = "Nuevos caminos se abren cuando el agua se congela."
	DESCRIBE.ICICLESTAFF = "¡Ojo! Los picos pueden dejar una marca muy traviesa."
	DESCRIBE.POLAR_SPEAR = "El hielo y los palos fueron hechos el uno para el otro."
	DESCRIBE.POLARAMULET = "Lo que importa es que crean en él, ¡hiuju!"
	DESCRIBE.POLARBEARHAT = "Es curiosamente cómodo para lo que es."
	DESCRIBE.POLARCROWNHAT = "Frío por fuera, congelado por dentro."
	DESCRIBE.POLARFLEA_SACK = "¿Qué hay adentro? ¡Eso es una sorpresa!"
	DESCRIBE.POLARICESTAFF = "¡No está bien dejar a nuestros invitados atrapados en el hielo!"
	DESCRIBE.POLARMOOSEHAT = "Una corona peluda para esconder el ceño helado."
	DESCRIBE.WALRUS_BAGPIPE = "¡Mis oídos se retuercen de agonía!"
	DESCRIBE.WALRUS_BEARTRAP = "¡Cuidado con los deditos! ¡Hay trampas abajito!"
	DESCRIBE.WINTERS_FISTS = "A veces la diferencia entre una broma y un asesinato frío es muy delgada."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "¡Ooo, Wes! ¡Deberías haberme contado antes sobre esas bromas!"
	DESCRIBE.BOAT_ICE_ITEM = "Pobres mortales sin capacidad de brincar..."
	DESCRIBE.POCKETWATCH_POLAR = {
		GENERIC = "¡Los mortales no dejan de inventar trucos tan graciosos!",
		RECHARGING = "Estos relojes, verán, necesitan tiempo para recargarse.",
	}
	DESCRIBE.POLARGLOBE = {
		GENERIC = "¡Un reino congelado, mío para sacudir! ¡Hiuju!",
		INUSE = "¡Qué tentadora y maldita chuchería!",
		REFUEL = "Está vacío... aunque no me pone triste.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "¿Crees que estás a salvo de mí, pececito?"
	DESCRIBE.POLARICEPACK = "¿Debo sacrificar espacio para la simple comida mortal?"
	DESCRIBE.POLARTRINKET_1 = "No veo alma alguna dentro, no no."
	DESCRIBE.POLARTRINKET_2 = "No veo alma alguna dentro, no no."
	DESCRIBE.TRAP_POLARTEETH = "¿Cruel? Tal vez. ¿Divertido? ¡Absolutamente!"
	DESCRIBE.TURF_POLAR_CAVES = "Suelo o techo, dependiendo de tu perspectiva."
	DESCRIBE.TURF_POLAR_DRYICE = "Suelo o techo, dependiendo de tu perspectiva."
	DESCRIBE.TURF_POLAR_GRASS = "Suelo o techo, dependiendo de tu perspectiva."
	DESCRIBE.WALL_POLAR = "¿Mantiene el frío afuera, o adentro?"
	DESCRIBE.WALL_POLAR_ITEM = "No sirve de nada ahí en el suelo."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "¿Hoy nos ponemos atrevidos, no?"
	DESCRIBE.WX78MODULE_NAUGHTY = "¿Eres el foco más brillante del montón?"
