local ANNOUNCE = STRINGS.CHARACTERS.WINONA
local DESCRIBE = STRINGS.CHARACTERS.WINONA.DESCRIBE

--	Announcements

    --	Actions
    ANNOUNCE.BATTLECRY.POLARBEAR = "Chodź i walcz na łapki!"

    --	World, Events
    ANNOUNCE.ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED = "Ha! Musiałam wyglądać jak prawdziwy głupek, chodząc z tym!!"
    ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
        "Nie moge stać... nie będę stać... okej, stoję.",
        "Ja nie spowalniam... tylko utrzymuję tempo...",
        "Fju... przydałoby mi się trochę odetchnąć!",
    }
	ANNOUNCE.ANNOUNCE_EMPEROR_ESCAPE = "Tyle puchu i żadnego przyłożenia się!"
    ANNOUNCE.ANNOUNCE_POLARGLOBE = "Fju! Już koniec. I... pada śnieg?"
    ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "Nie. Zły pomysł."
    ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "Przynajmniej niektórzy szefowie zostawiają prezenty."

    --	Buffs
    ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "Jeeju! Nie jestem odpowiednio ubrana na TO!"
    ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "A teraz czas na wyżymaczkę..."

--	Worldgen

    --	Plants
    DESCRIBE.ANTLER_TREE = {
        BURNING = "Płoń, mały drzewcu, płoń!",
        BURNT = "Rozsypuję popiół na śniegu.",
        CHOPPED = "Było więcej kory niż... no wiesz.", -- LukaS: This joke ABSOLUTELY does not work in polish lol
        GENERIC = "Wygląda na ostre, ale ja jestem ostrzejsza.",
    }
    DESCRIBE.ICELETTUCE_SEEDS = "Nie mam pojęcia, w co to wyrośnie."

    --	Rocks and stones
    DESCRIBE.POLAR_ICICLE = "No tak. Mój kask!"
    DESCRIBE.POLAR_ICICLE_ROCK = "Mam nadzieję, że dostanę dodatek za pracę w niebezpiecznych warunkach."
    DESCRIBE.ROCK_POLAR = "Nie mam nic przeciwko."

    --	Misc
    ANNOUNCE.DESCRIBE_IN_POLARSNOW = "Cokolwiek jest pod spodem, możemy tylko zgadywać."
	DESCRIBE.CAVE_ENTRANCE_POLAR = "O rany, jeszcze nie mogę tam zejść." -- TEMP QUOTE
	DESCRIBE.TOWER_POLAR = {
		GENERIC = "Wysokie wieże i śliskie podłogi nie idą w parze.",
		PENGUIN = "Żongluj sę póki zajmuję się twoją zgrają.",
	}
    DESCRIBE.TUMBLEWEED_POLAR = "Mówią, że każdy z nich jest wyjątkowy. I na zewnątrz i wewnątrz."

--	Mobs

	DESCRIBE.EMPEROR_PENGUIN = {
		GENERIC = "Jedyne co widzę to popisywanie się bogactwami.",
		HOSTILE = "Łaoł, on wie jak się poruszać!",
	}
	DESCRIBE.EMPEROR_PENGUIN_GUARD = "Dziobie, kłuje. Ale co gorsza: jego pióro łaskocze!"
    DESCRIBE.MOOSE_POLAR = {
        GENERIC = "Teraz to się wkopałeś, huh?",
        ANTLER = "Wygląda na mocnego. Czas się przekonać, czy jest naprawdę.",
    }
    DESCRIBE.MOOSE_SPECTER = "Na razie chcę go po prostu poobserwować."
    DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "Jak dla mnie trochę za bardzo błyszczący, ale nadal jest w menu."
    DESCRIBE.POLARBEAR = {
        DEAD = "Ubity do rekordu!",
        ENRAGED = "Ojoj, mamy niedźwiedzie problemy!",
        FOLLOWER = "A więc, yy, jaka jest twoja ulubiona ryba?",
        GENERIC = "Nie bądź wobec mnie taki chłodny.",
    }
    DESCRIBE.POLARFLEA = {
        GENERIC = "Wiem lepiej niż żeby zbliżać się to nich.",
        HELD = "Ajaj! Spadaj!",
        HELD_BACKPACK = "Ja tutaj rządzę. Gryziesz kiedy ja każę.",
    }
    DESCRIBE.POLARFOX = {
        FOLLOWER = "Ty załatwiasz mi króliki, ja załatwiam ci obiad, proste.",
        FRIEND = "Czy zapomniałam o swojej części naszego małego porozumienia?",
        GENERIC = "Wraca tutaj, ty mały urwisie!",
    }
    DESCRIBE.POLARWARG = "Nie mam wątpliwości co do jego miętowego oddechu."

--	Buildings

	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_FRUITY = "Wygląda na to, że ktoś zapomniał swojego paska w tym ważnym dniu."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_JUGGLE = "Ten koleś uwielbiałby być w świetle moich reflektorów."
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_MAGESTIC = "O. Przepraszam. Czyżbym zbyt głośno przewracała oczami?"
	DESCRIBE.CHESSPIECE_EMPEROR_PENGUIN_SPIN = "Mam nadzieję, że jest dobrze przykręcony."
    DESCRIBE.POLAR_BRAZIER = {
        GENERIC = "Czas zapalić ogień!",
        ON = "Ten model wygląda znajomo... musi mi się wydawać.",
    }
    DESCRIBE.POLAR_BRAZIER_ITEM = "Przydatne źródło światła."
    DESCRIBE.POLAR_THRONE = "Pokaz siły i lenistwa."
    DESCRIBE.POLAR_THRONE_GIFTS = "Mali pomocnicy dbali o ich czystość."
    DESCRIBE.POLARAMULET_STATION = {
        GENERIC = "Lepiej mi na zewnątrz niż w tej nędznej chałupie.",
        OPEN = "Kolego, słyszałeś kiedyś o odpowiednim oświetleniu? Strasznie tam w środku.",
    }
    DESCRIBE.POLARBEARHOUSE = {
        BURNT = "Hm. Pewnie kolejny pożar.",
        GENERIC = "Coś mi tu śmierdzi rybą.",
    }
    DESCRIBE.POLARICE_PLOW = "Powinnam się ociupinkę odsunąć."
    DESCRIBE.POLARICE_PLOW_ITEM = "Wystarczy tego chowanego, rybki."
	DESCRIBE.TOWER_POLAR_FLAG = "Patrz jak leci!"
	DESCRIBE.TOWER_POLAR_FLAG_ITEM = "Nie mam dla ciebie dużego zastosowania, mała flago."
	DESCRIBE.RAINOMETER.POLARSTORM = "Jeju, co jest z nim?"
	DESCRIBE.WINTEROMETER.POLARSTORM = "Nie jest AŻ TAK zimno, prawda?"

--	Items

    --	Food
    DESCRIBE.DRYICECREAM = "Śnieg staję się poważnym niczym po zjedzeniu tego."
    DESCRIBE.ICELETTUCE = "W idealnym stanie? Jest praktycznie kriokonserwowany!"
    DESCRIBE.ICEBURRITO = "Dokładnie to, czego potrzebowałam do zakończenia dnia."
    DESCRIBE.POLARCRABLEGS = "Dobrze mi z tylko drobną ilością luksusu."

    --	Crafting
    DESCRIBE.BLUEGEM_OVERCHARGED = "Nie będę tego trzymała bez rękawiczek."
    DESCRIBE.BLUEGEM_SHARDS = "Jestem pewna, że samo zimno skleiło by je do siebie z powrotem."
	DESCRIBE.EMPEROR_EGG = "(puk puk) To tutaj to materiał najwyższej jakości."
    DESCRIBE.MOOSE_POLAR_ANTLER = "Walczyłeś dzielnie, koleżko."
    DESCRIBE.POLAR_DRYICE = "Zabrać je na taśmę lodowo-montażową."
    DESCRIBE.POLARBEARFUR = "Jest ciepłe, ale, najważniejsze, że jest moje."
    DESCRIBE.POLARWARGSTOOTH = "Nie sądzę, żeby używał ich do jedzenia roślin."

    --	Equipments
    DESCRIBE.ANTLER_TREE_STICK = "To może się okazać przydatne."
    DESCRIBE.ARMORPOLAR = "Jest to najmocniejsza skóra jaką da się zrobić."
	DESCRIBE.COMPASS_POLAR = "Rany, jak mam cię śledzić, skoro ciągle się trzęsiesz?!"
	DESCRIBE.EMPEROR_PENGUINHAT = "Wyglądam dość chłodno. Dosłownie."
    DESCRIBE.FROSTWALKERAMULET = "To mnie przypilnuje, żebym nie zawaliła przy pracy. Ha!"
    DESCRIBE.ICICLESTAFF = "Nie lekceważyłabym warunków wietrznych z tym cudkiem."
    DESCRIBE.POLAR_SPEAR = "Pff. Okej. Przypuszczając, że żyjesz w zamrażalce..."
    DESCRIBE.POLARAMULET = "Powiedział, że każdy jest wyjątkowy czy coś w tym stylu."
    DESCRIBE.POLARBEARHAT = "Wygląda na to, że co dwie głowy to nie jedna."
    DESCRIBE.POLARCROWNHAT = "Nie da się spocić jeśli nie możesz się pocić."
    DESCRIBE.POLARFLEA_SACK = "Zadzierasz ze mną, zadzierasz z moimi plecakowymi pełzakami."
    DESCRIBE.POLARICESTAFF = "Musisz zamrozić, żeby zadowolić."
    DESCRIBE.POLARMOOSEHAT = "Hej, Woodie. Czy nadal masz cały tył?"
	DESCRIBE.WINTERS_FISTS = "Narzędzie do robienia śnieżek... które uderzają jak cegły."

    --	Others
    DESCRIBE.ARCTIC_FOOL_FISH = "Makrela drwiny atakuje, gdy się tego najmniej spodziewamy."
    DESCRIBE.POLARGLOBE = {
        GENERIC = "Ha! Charlie uwielbiała te malutkie rzeczy.",
        INUSE = "Oj ty...",
        REFUEL = "Nie do końca wiem jak się opróżniła. Ale tak będzie lepiej.",
    }
    DESCRIBE.OCEANFISH_IN_ICE = "Hę. Darmowa ryba!"
    DESCRIBE.POLARICEPACK = "Ten mały kawałek lodu przebył długą drogę."
    DESCRIBE.POLARTRINKET_1 = "Ładny szalik tam masz. Z chęcią bym taki chciała."
    DESCRIBE.POLARTRINKET_2 = "Ee, Wygląda na to, że doszło do pomyłki z dwiema liniami produkcyjnymi."
    DESCRIBE.TRAP_POLARTEETH = "Okrutne, ale sprytne."
    DESCRIBE.TURF_POLAR_CAVES = "To kawałek ziemi."
    DESCRIBE.TURF_POLAR_DRYICE = "To kawałek drogi."
    DESCRIBE.WALL_POLAR = "Taa, to dość lodowe."
    DESCRIBE.WALL_POLAR_ITEM = "Czas montażu."
    DESCRIBE.WINTER_ORNAMENTPOLAR = "Nic nie krzyczy zima tak jak ten."
    DESCRIBE.WX78MODULE_NAUGHTY = "WX, musisz przestać zostawiać te rzeczy leżące dookoła!"