local ANNOUNCE = STRINGS.CHARACTERS.WARLY
local DESCRIBE = STRINGS.CHARACTERS.WARLY.DESCRIBE

-- 선언

	-- 행동
	ANNOUNCE.BATTLECRY.POLARBEAR = "곰 가죽을 팔 땐 조심하라고 하던데?"

	-- 세계, 이벤트
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"가자... 거의 다 왔어...",
		"세상에... 우웩...",
		"흐르르르...",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "으으! 누가 냉동고 문 열어놨나?"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "딴 데 가서 낚시하는 게 낫겠어."
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "메르시~ 어이쿠! 나도 선물을 가져올 걸 그랬네!"

	-- 버프
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "이-이런 추위는... 코트가 더 두꺼워야 해!"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "후우... 불 없이는 정말 못 살아!"

-- 월드 생성

	-- 식물
	DESCRIBE.ANTLER_TREE = {
		BURNING = "불 피워놓은 김에 따뜻하게 즐겨야지.",
		BURNT = "바삭하네, 그치?",
		CHOPPED = "팍 하고 부딪혔지!",
		GENERIC = "오! 거의 부딪칠 뻔했어.",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "신선한 채소가 자라겠군."

	-- 바위와 돌
	DESCRIBE.POLAR_ICICLE = "상쾌한 각성이야, 고맙다."
	DESCRIBE.POLAR_ICICLE_ROCK = "자, 다시 올라올 수 있으려나?"
	DESCRIBE.ROCK_POLAR = "캐는 김에 얼음 조각 연습할까?"

	-- 기타
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "이 안에 먹을 수 있는 거라도 있나?"
	DESCRIBE.TUMBLEWEED_POLAR = "밖으로 나온 것도 나쁘지만은 않군!"

-- 몬스터

	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "장식이 없어졌네.",
		ANTLER = "훌륭한 야생 풍미가 나올 거 같은 짐승이야.",
	}
	DESCRIBE.MOOSE_SPECTER = "몽 디유, 정말 예술이야!"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "포아송 프레~ (신선한 생선)!"
	DESCRIBE.POLARBEAR = {
		DEAD = "드디어 저 가죽을 팔 수 있겠군.",
		ENRAGED = "싸움이 고픈 녀석이야!",
		FOLLOWER = "식욕이 정말 끝내주네.",
		GENERIC = "서로의 맛이 궁금한 건 나뿐인가?\n...그런가?",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "오, 논!",
		HELD = "본 아페티~ 그리고 잘 가라!",
		HELD_BACKPACK = "겨울잠 자는 중인 것 같아.",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "좋은 식사를 거절할 순 없지, 그렇지?",
		FRIEND = "옛날처럼 한 끼 어떠신가?",
		GENERIC = "교활한 작은 여우구만~",
	}
	DESCRIBE.POLARWARG = "추워서 떨리는 건지, 저 놈 때문인지 모르겠어..."

-- 건물

	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "잔가지가 좀 필요하겠는걸.",
		ON = "에 부알라~ (자, 됐어!)",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "내 야외 주방에 딱이야."
	DESCRIBE.POLAR_THRONE = "식탁 없는 왕좌엔 안 앉는다!"
	DESCRIBE.POLAR_THRONE_GIFTS = "흠... 나 올해 착하게 살았는걸?"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "안엔 정육점 같은 분위기겠지...",
		OPEN = "내가 요리 안 할 것들은 가져가도 돼.",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "정어리 냄새 나더라니!",
		GENERIC = "진짜 눈보라 견딜 수 있긴 할까?",
	}
	DESCRIBE.POLARICE_PLOW = "미끼를 충분히 가져왔으려나..."
	DESCRIBE.POLARICE_PLOW_ITEM = "얼음낚시 하루 어떠신가~?"

-- 아이템

	-- 음식
	DESCRIBE.DRYICECREAM = "멋쟁이들을 위한 아이스크림이지!"
	DESCRIBE.ICELETTUCE = "으으... 드레싱이라도 뿌려야겠는데."
	DESCRIBE.ICEBURRITO = "다신 윌슨에게 이름 맡기지 않을 거야."
	DESCRIBE.POLARCRABLEGS = "음~ 심플몽 빠르-페! (완벽해!)"

	-- 제작
	DESCRIBE.BLUEGEM_OVERCHARGED = "세상에, 너무 차가워서 못 먹겠어!"
	DESCRIBE.BLUEGEM_SHARDS = "접착제 좀 있으면 좋겠는데."
	DESCRIBE.MOOSE_POLAR_ANTLER = "난 고기가 더 기대됐는데..."
	DESCRIBE.POLAR_DRYICE = "얼음덩어리가 아주 크구먼!"
	DESCRIBE.POLARBEARFUR = "눈덩이 같으면서도 엄청 포근해."
	DESCRIBE.POLARWARGSTOOTH = "이건 진짜 자국 남기겠는걸!"

	-- 장비
	DESCRIBE.ANTLER_TREE_STICK = "살뤼, 옛 친구~ (반가워, 나무야!)"
	DESCRIBE.ARMORPOLAR = "털 장비로 따뜻하게!"
	DESCRIBE.FROSTWALKERAMULET = "이젠 '프로스팅'도 수준이 달라졌군!"
	DESCRIBE.ICICLESTAFF = "이유 없는 비가 아니라, 이건 치명적이야!"
	DESCRIBE.POLAR_SPEAR = "녹기 전까지는 즐겁지!"
	DESCRIBE.POLARAMULET = "내 송곳니 보이면 다들 놀랄걸?"
	DESCRIBE.POLARBEARHAT = "내 음식이 나를 이렇게 보나?"
	DESCRIBE.POLARCROWNHAT = "드디어 인내심 폭발할 줄 알았어?"
	DESCRIBE.POLARFLEA_SACK = "몸 위보단 안에 있는 게 낫지."
	DESCRIBE.POLARICESTAFF = "실례합니다만, 신선한 공기 좀 쐬고 오겠습니다."
	DESCRIBE.POLARMOOSEHAT = "이 근처에 사냥꾼 없었으면 좋겠는데..."

	-- 기타
	DESCRIBE.POLARGLOBE = {
		GENERIC = "식탁 장식으로 좋겠는걸!",
		INUSE = "좋아. 모두를 위한 수프나 끓일까?",
		REFUEL = "아니 아니! 눈은 안 돌려줄 거야.",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "이 신선함은 의심할 여지가 없지."
	DESCRIBE.POLARICEPACK = "가장 무서운 적에 맞설 방어책."
	DESCRIBE.POLARTRINKET_1 = "너의 눈 덮인 정원에 꽃이 피었니?"
	DESCRIBE.POLARTRINKET_2 = "잔디밭이 1년 내내 푸르진 않았겠지?"
	DESCRIBE.TRAP_POLARTEETH = "포크처럼 잡고, 도끼처럼 자르지!"
	DESCRIBE.TURF_POLAR_CAVES = "땅의 재료 같아."
	DESCRIBE.TURF_POLAR_DRYICE = "땅의 재료 같아."
	DESCRIBE.WALL_POLAR = "아아~ 이건 진짜 얼음 아닌가?"
	DESCRIBE.WALL_POLAR_ITEM = "당분간은 안 녹을 거야."
	DESCRIBE.WINTER_ORNAMENTPOLAR = "축제 트리에 딱 어울리는 서리 장식!"
	DESCRIBE.WX78MODULE_NAUGHTY = "입 하나론 너무 과한 풍미잖아... 아니, 스피커였나?"
