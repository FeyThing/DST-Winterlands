local ANNOUNCE = STRINGS.CHARACTERS.GENERIC
local DESCRIBE = STRINGS.CHARACTERS.GENERIC.DESCRIBE

-- 알림

-- 행동
ANNOUNCE.BATTLECRY.POLARBEAR = "이 싸움, 곰곰이 생각해야 할지도 몰라."

-- 세계, 이벤트
ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
    "믿어... 이건... 지름길이야.",
    "흐윽...",
    "허억...",
}
ANNOUNCE.ANNOUNCE_POLARGLOBE = "지진에 오한까지—방금 무슨 일이?!"
ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "이 얼음은 다른 데가 더 어울릴 텐데."
ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "음. 그리 나쁘진 않았군."

ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {"wx78 전용"}
ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {"wx78 전용"}

-- 버프
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "브르르... 이건 진짜 눈웃음(눈+농담)이 아냐!"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "말라버렸어. 눈에 한해서지만."

-- 월드 생성

-- 식물
DESCRIBE.ANTLER_TREE = {
    BURNING = "불이라면 싫진 않지.",
    BURNT = "이곳 풍경과는 많이 대조적이군.",
    CHOPPED = "다른 나무가 눈치채기 전에 도망가야겠어.",
    GENERIC = "이 나무, 싸움을 걸고 있는 것 같은데?",
}
DESCRIBE.ICELETTUCE_SEEDS = "씨앗이긴 한데… 뭔가 과학적이야."

-- 바위와 돌
DESCRIBE.POLAR_ICICLE = "방금 움직인 것 같지 않았어?"
DESCRIBE.POLAR_ICICLE_ROCK = "응, 확실히 움직였어."
DESCRIBE.ROCK_POLAR = "갓 수확한 보석들!"

-- 기타
ANNOUNCE.DESCRIBE_IN_POLARSNOW = "여기서 뭔가 봤던 것 같은데."
DESCRIBE.TUMBLEWEED_POLAR = "모든 과학 법칙을 무시하고 있어!"

-- 몬스터

DESCRIBE.MOOSE_POLAR = {
    GENERIC = "뿔 잃은 사슴, 살아가기 참 힘들겠지.",
    ANTLER = "부딪히지 않게 거리를 두는 게 좋겠어.",
}
DESCRIBE.MOOSE_SPECTER = "지역 전설이 사실이었군."
DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "저 눈은 값어치가 꽤 나갈 텐데!"
DESCRIBE.POLARBEAR = {
    DEAD = "그냥 눈더미 같네... 아, 아니군.",
    ENRAGED = "이 친구, 말도 잘하고 물기도 해!",
    FOLLOWER = "이쪽은 내 곰 친구야.",
    GENERIC = "무시무시하면서도... 포근하게 생겼네.",
}
DESCRIBE.POLARFLEA = {
    GENERIC = "지금 도망쳐야 해!",
    HELD = "턱이 벌써 피부 밑으로 파고들었어!",
    HELD_BACKPACK = "이 아이디어, 왠지 잘 될 것 같은 느낌이야. 아마도.",
}
DESCRIBE.POLARFOX = {
    FOLLOWER = "작은 게임 한 판 해볼까?",
    FRIEND = "익숙한 얼굴인데. 나도 그런가?",
    GENERIC = "아하! 이리 와!",
}
DESCRIBE.POLARWARG = "저 정도 털이면 추위도 문제 없겠지."

-- 건물

DESCRIBE.POLAR_BRAZIER = {
    GENERIC = "주머니 크기의 화로야.",
    ON = "이젠 너무 뜨거워서 주머니에 넣을 순 없겠네. 불 꺼야겠어.",
}
DESCRIBE.POLAR_BRAZIER_ITEM = "과학에 따르면, 휴대 가능하면 뭐든 더 좋지."
DESCRIBE.POLAR_THRONE = "꽤 편해 보이는데."
DESCRIBE.POLAR_THRONE_GIFTS = "저기 있는 게 내 이름인가? 저 발톱 글씨체론 모르겠어."
DESCRIBE.POLARAMULET_STATION = {
    GENERIC = "이 오두막이 어떻게 안 무너지는지 진짜 미스터리야.",
    OPEN = "어… 죄송합니다. 집 잘못 찾았어요.",
}
DESCRIBE.POLARBEARHOUSE = {
    BURNT = "세상에!",
    GENERIC = "여기가 더 따뜻할 것 같진 않은데.",
}
DESCRIBE.POLARICE_PLOW = "저 아래 뭐가 있는지 과학적으로 궁금하네."
DESCRIBE.POLARICE_PLOW_ITEM = "숨은 물고기가 제일 맛있지."

-- 아이템

-- 음식
DESCRIBE.DRYICECREAM = "이산화탄소 맛이라니, 이건 따라올 수 없지."
DESCRIBE.ICELETTUCE = "양념이 좀 과한데?"
DESCRIBE.ICEBURRITO = "이 이름, 정말 맘에 드는데!"
DESCRIBE.POLARCRABLEGS = "다리 열 개니까 다 같이 나눠 먹을 수 있겠네!"

-- 제작
DESCRIBE.BLUEGEM_OVERCHARGED = "말 바꿔야겠어. 이건 진짜 차가운 에너지로 반짝거려!"
DESCRIBE.BLUEGEM_SHARDS = "광물학적으로 흥미로운 퍼즐이야."
DESCRIBE.MOOSE_POLAR_ANTLER = "무겁다!"
DESCRIBE.POLAR_DRYICE = "정말 멋진 걸 만들 수 있을 것 같아."
DESCRIBE.POLARBEARFUR = "포근해… 진심으로!"
DESCRIBE.POLARWARGSTOOTH = "정말 날카롭네!"

-- 장비
DESCRIBE.ANTLER_TREE_STICK = "과학적으로 완벽한 나뭇가지야."
DESCRIBE.ARMORPOLAR = "이거야말로 제대로 된 장비지!"
DESCRIBE.FROSTWALKERAMULET = "이 현상은 과학적으로 설명할 수 있어... 하지만 안 할래."
DESCRIBE.ICICLESTAFF = "유용하지. 그 ‘사건’만 잊는다면 말이지."
DESCRIBE.POLAR_SPEAR = "완전 거대한 찔러막대기야!"
DESCRIBE.POLARAMULET = "뭔가를 하고 있어, 확실히 뭔가..."
DESCRIBE.POLARBEARHAT = "잡아먹히는 것도 장점이 있네!"
DESCRIBE.POLARCROWNHAT = "이걸로 뇌가 얼어버리진 않겠지?"
DESCRIBE.POLARFLEA_SACK = "작고 앙증맞은 아군들로 채우자!"
DESCRIBE.POLARICESTAFF = "이건 내 지팡이 중에서도 가장 ‘시원한’ 지팡이지!"
DESCRIBE.POLARMOOSEHAT = "예술성이 느껴지는 북극 모자군."

-- 기타
DESCRIBE.POLARGLOBE = {
    GENERIC = "계속 돌고 있네.",
    INUSE = "다신 하지 말자, 이거!",
    REFUEL = "눈은 다 어디 간 거야?",
}
DESCRIBE.OCEANFISH_IN_ICE = "물고기 큐브로군."
DESCRIBE.POLARICEPACK = "나까지 보존되진 않겠지만, 그래도 유용해."
DESCRIBE.POLARTRINKET_1 = "겨울 전설이 깃든 유물일지도 몰라."
DESCRIBE.POLARTRINKET_2 = "겨울 전설이 깃든 유물일지도 몰라."
DESCRIBE.TRAP_POLARTEETH = "이건 정말 차가운 환영 인사야..."
DESCRIBE.TURF_POLAR_CAVES = "또 다른 동굴 지면이군."
DESCRIBE.TURF_POLAR_DRYICE = "이 근방 얼음 중에선 제일 단단해."
DESCRIBE.WALL_POLAR = "이 안에 있으면 정말 안전하고... 춥기도 하네."
DESCRIBE.WALL_POLAR_ITEM = "냉정함을 유지하려면 이게 최고지."
DESCRIBE.WINTER_ORNAMENTPOLAR = "이거면 나무 장식이 완벽해질 거야."
DESCRIBE.WX78MODULE_NAUGHTY = "이 작은 기계 안에 과학이 한가득이야!"

