local ANNOUNCE = STRINGS.CHARACTERS.WARLY
local DESCRIBE = STRINGS.CHARACTERS.WARLY.DESCRIBE

--	Announcements

	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "Wiesz jak patrzą na sprzedaż futra z niedźwiedzi?"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Alors là! Zemsta będzie słodka!"
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"Aller... presque...",
		"Bon sang... uf...",
		"Hrrrr...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "Brr! Kto zostawił drzwi od zamrażarki otwarte?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Wolałbym połowić gdzieś indziej."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Merci-- oh. Powinienembył też przynieść prezenty!"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Q-quel froid! Potrzebuję większej kurtki..."
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "Aaahhh... co my byśmy zrobili bez ognia?"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "Lepiej się nacieszyć tym ogniem póki tu jest.",
		BURNT = "Zkarmelizowany, nie?",
		CHOPPED = "Ciachnięty!",
		GENERIC = "Oh! Prawie w nie wbiegłem.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "Będzie z ciebie świetne, świerzutkie warzywo."
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "Moje podziękowania za przypomnienie."
	DESCRIBE.POLAR_ICICLE_ROCK = "I jak teraz masz zamiar wrócić tam na góre?"
	DESCRIBE.ROCK_POLAR = "Może poćwiczę rzeźbiarstwo podczas wydobywania?"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Coś jadalnego w śniegu?"
	DESCRIBE.TUMBLEWEED_POLAR = "Może wyprawa tam nie była aż taka zła!"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "Straciło swoją ozdobe.",
		ANTLER = "Wspaniałe zwierzę, które z pewnością zapewni wyraziste, dzikie smaki.",
	}
	DESCRIBE.MOOSE_SPECTER = "Mon dieu, wygląda po prostu wykwintnie!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Poisson frais!"
	DESCRIBE.POLARBEAR = {
		DEAD = "W końcu będę mógł sprzedać jego futro.",
		ENRAGED = "Ma apetyt na walke!",
		FOLLOWER = "Ma nienasycony apetyt.",
		GENERIC = "Oboje jesteśmy ciekawi, jak smakuje drugi\n... czy to tylko ja?",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "Oh non!",
		HELD = "Bon appétit, oraz adieu!",
		HELD_BACKPACK = "Wydaje mi się, że zapadają w sen zimowy.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "Po prostu nie można odmówić dobrego posiłku, non?",
		FRIEND = "Co powiesz na posiłek jak za dawnych czasów?",
		GENERIC = "Sprytny mały renard.",
	}
	DESCRIBE.POLARWARG = "Mam dreszcze i to nie przez to zimno..."
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "Przydałyby się jakieś gałązki.",
		ON = "Et voilà!",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "Dobry dodatek do mojej przenośnej kuchni."
	DESCRIBE.POLAR_THRONE = "Nie będę siedział na tronie bez stołu."
	DESCRIBE.POLAR_THRONE_GIFTS = "No wiesz... byłem grzeczny w tym roku, non?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "Muszą tam mieć prawdziwą boucherie...",
		OPEN = "Możesz mieć to, czego nie planuję gotować.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "A wydawało mi się, że czuję sardynki.",
		GENERIC = "Czy to naprawde dałoby radę podczas burzy śnieżnej?",
	}
	DESCRIBE.POLARICE_PLOW = "Mam nadzieję, że przyniosłem wystarczająco dużo przynęty..."
	DESCRIBE.POLARICE_PLOW_ITEM = "Dzień wędkowania pod lodem brzmi kusząco!"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "Lody dla fajnych dzieci!"
	DESCRIBE.ICELETTUCE = "Brr... przydałby się sos..."
	DESCRIBE.ICEBURRITO = "Ostatni raz pozwalam Wilsonowi nazywać moje przepisy."
	DESCRIBE.POLARCRABLEGS = "Mwah! Simplement par-fait!"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "O jacie, stanowczo za zimne jak na mój gust!"
	DESCRIBE.BLUEGEM_SHARDS = "Przydałby się jakiś klej."
	DESCRIBE.MOOSE_POLAR_ANTLER = "Bardziej czekałem na spróbowanie mięsa."
	DESCRIBE.POLAR_DRYICE = "Co za duże kostki lodu!"
	DESCRIBE.POLARBEARFUR = "Najprzytulniejsza kulka śniegu."
	DESCRIBE.POLARWARGSTOOTH = "To pozostawiłoby wgniecenie."
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "Salut, vieille branche!"
	DESCRIBE.ARMORPOLAR = "Jakaś futrzasta ochrona."
	DESCRIBE.FROSTWALKERAMULET = "To przenosi zamrażanie na wyższy poziom!"
	DESCRIBE.ICICLESTAFF = "Il pleut il mouille? Nie, jest zabujcze!"
	DESCRIBE.POLAR_SPEAR = "Pełnia zabawy, dopóki nie zacznie kapać."
	DESCRIBE.POLARAMULET = "Nie chciałbyś być w pobliżu, kiedy ja wyjmę kły."
	DESCRIBE.POLARBEARHAT = "Czy to widzi moje jedzenie przed byciem zjedzonym?"
	DESCRIBE.POLARCROWNHAT = "Czy ktoś się bał mojego chłodnego spojrzenia?"
	DESCRIBE.POLARFLEA_SACK = "Lepiej w środku niż na mnie."
	DESCRIBE.POLARICESTAFF = "Pardon, ale muszę chwile odetchnąć."
	DESCRIBE.POLARMOOSEHAT = "Lepiej, żeby w tych rejonach nie było żadnych niebezpiecznych łowców."
	
	--	Others
	DESCRIBE.ARCTIC_FOOL_FISH = "Klasyczny, nieszkodliwy żart! A przynajmniej powienien być..."
	DESCRIBE.POLARGLOBE = {
		GENERIC = "Bedzie z tego dobra dekoracja stołu biesiadnego.",
		INUSE = "No cóż, lepiej przygotuję dla wszystkich zupę.",
		REFUEL = "A non! Nie odzyskasz swojego śniegu sama.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "Nie ma wątpliwości co do jego świeżości."
	DESCRIBE.POLARICEPACK = "Pewne umocnienie przeciwko mojemu najgorszemu wrogowi."
	DESCRIBE.POLARTRINKET_1 = "Czy w Twoim zaśnieżonym ogrodzie rosły kwiaty?"
	DESCRIBE.POLARTRINKET_2 = "Zakładam, że twój trawnik nie był zielony przez cały rok."
	DESCRIBE.TRAP_POLARTEETH = "Chwyta jak widelec, tnie jak nóż rzeźnicki."
	DESCRIBE.TURF_POLAR_CAVES = "Jest jak składnik, tylko, że ziemi."
	DESCRIBE.TURF_POLAR_DRYICE = "Jest jak składnik, tylko, że ziemi."
	DESCRIBE.WALL_POLAR = "Aaa. Świetnie."
	DESCRIBE.WALL_POLAR_ITEM = "Mam nadzieję, że nie roztopi się w najbliższym czasie."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "Lukier na naszą świąteczną choinkę."
	DESCRIBE.WX78MODULE_NAUGHTY = "No to jest po prostu za dużo pikanterii dla jednej buzi. Albo głośnika, nie wiem."