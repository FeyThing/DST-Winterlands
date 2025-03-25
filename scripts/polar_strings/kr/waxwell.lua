local ANNOUNCE = STRINGS.CHARACTERS.WAXWELL
local DESCRIBE = STRINGS.CHARACTERS.WAXWELL.DESCRIBE

-- 발표

    -- 행동
    ANNOUNCE.BATTLECRY.POLARBEAR = "뇌는 발보다 우위에 있지!"

    -- 세계, 이벤트
    ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
        "오해하지 마라... 외투와 지팡이가 좀 있었으면 좋겠군...",
        "내 하인들이 있었다면 훨씬 수월했을 텐데.",
        "눈이든, 얼음이든... 정장을 망쳐버리니.",
    }
    ANNOUNCE.ANNOUNCE_POLARGLOBE = "또 누가 이 저주받은 물건을 만지는 거지?"
    ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "저 얼음을 깨고 싶진 않군."
    ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "뭔가 꿍꿍이가 있는 것 같군."

    -- 버프
    ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "이 상황에 어울리는 복장이 아니군."
    ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "(한숨) 교훈은 얻었다."

-- 월드 생성

    -- 식물
    DESCRIBE.ANTLER_TREE = {
        BURNING = "내 안락함을 위해 희생된 셈이지.",
        BURNT = "쓸모가 없... 아니, 잠깐만...",
        CHOPPED = "그 정도론 부족하군, 나무야.",
        GENERIC = "흠. 엉성한 것이... 겨우 붙어 있군.",
    }
    DESCRIBE.ICELETTUCE_SEEDS = "내가 이걸 심으라고?"

    -- 바위와 돌
    DESCRIBE.POLAR_ICICLE = "단순하지만 훌륭하군."
    DESCRIBE.POLAR_ICICLE_ROCK = "두 번째 기회는 없지."
    DESCRIBE.ROCK_POLAR = "막 도착한 신선한 물건이군."

    -- 기타
    ANNOUNCE.DESCRIBE_IN_POLARSNOW = "눈 속에 뭔가... 있다."
    DESCRIBE.TUMBLEWEED_POLAR = "기묘하긴 한데, 전혀 중요하지 않군."

-- 생물

    DESCRIBE.MOOSE_POLAR = {
        GENERIC = "이젠 별로 위협적이지 않군.",
        ANTLER = "큰 뿔, 큰 태도지.",
    }
    DESCRIBE.MOOSE_SPECTER = "흠. 제법... 위엄 있군."
    DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "수조 애호가 친구라면 돈을 아끼지 않겠지."
    DESCRIBE.POLARBEAR = {
        DEAD = "남은 건 자연이 처리하겠지.",
        ENRAGED = "좋아, 이제 이빨을 드러내는군.",
        FOLLOWER = "말했잖나. 낚시는 안 한다고.",
        GENERIC = "흥미로운 무리군.",
    }
    DESCRIBE.POLARFLEA = {
        GENERIC = "안 돼! 절대 안 돼!",
        HELD = "아프긴 하겠지만, 애완용으론 무리지.",
        HELD_BACKPACK = "내가 저걸 품고 다니라고?",
    }
    DESCRIBE.POLARFOX = {
        FOLLOWER = "이제 우리 운명은 함께하는 셈이지.",
        FRIEND = "오랜만이군, 친구.",
        GENERIC = "길 막지 마.",
    }
    DESCRIBE.POLARWARG = "자연의 적응력이란 참 놀랍군."

-- 건물

    DESCRIBE.POLAR_BRAZIER = {
        GENERIC = "솔직히, 화로는 마음에 들어.",
        ON = "원시적이지만... 효과는 있군.",
    }
    DESCRIBE.POLAR_BRAZIER_ITEM = "이젠 짐꾼이라도 된 기분이군."
    DESCRIBE.POLAR_THRONE = "아래에서 보니 이런 모습이었군?"
    DESCRIBE.POLAR_THRONE_GIFTS = "이번엔 또 무슨 수작이지?"
    DESCRIBE.POLARAMULET_STATION = {
        GENERIC = "호의적인 외관이라니, 흥미롭군.",
        OPEN = "...안 본 걸로 하자.",
    }
    DESCRIBE.POLARBEARHOUSE = {
        BURNT = "타버린 태양이 이곳만은 비켜갔으면.",
        GENERIC = "안에서 썩은 냄새가 나는군. 윽.",
    }
    DESCRIBE.POLARICE_PLOW = "비켜, 아니면 물고기 밥이 될 테니까."
    DESCRIBE.POLARICE_PLOW_ITEM = "절박한 시국엔 파괴가 답이지."

-- 아이템

    -- 음식
    DESCRIBE.DRYICECREAM = "저걸로 머리라도 깨겠군."
    DESCRIBE.ICELETTUCE = "이제 얼음 씹는 시대인가?"
    DESCRIBE.ICEBURRITO = "맛이 없진 않을 것 같긴 한데..."
    DESCRIBE.POLARCRABLEGS = "녹인 버터랑 같이면 완벽하겠군."

    -- 제작
    DESCRIBE.BLUEGEM_OVERCHARGED = "내 것이었지. 조금 바뀌었을 뿐."
    DESCRIBE.BLUEGEM_SHARDS = "반짝이는군."
    DESCRIBE.MOOSE_POLAR_ANTLER = "내 안의 마법을 추출해 봐야겠군."
    DESCRIBE.POLAR_DRYICE = "생각해보니... 내 얼음 조각상은 아직 없었군."
    DESCRIBE.POLARBEARFUR = "이건 정말- 으악! 벼룩이 한가득이군!"
    DESCRIBE.POLARWARGSTOOTH = "패션 아이템으로도 나쁘지 않군."

    -- 장비
    DESCRIBE.ANTLER_TREE_STICK = "이거라면 쓸모가 있겠군."
    DESCRIBE.ARMORPOLAR = "기능성 있고, 약간은 세련됐군."
    DESCRIBE.FROSTWALKERAMULET = "물고기들에겐 유감이지만, 어쩔 수 없지."
    DESCRIBE.ICICLESTAFF = "상한 토마토보다 더 끔찍한 운명이군."
    DESCRIBE.POLAR_SPEAR = "솔직히 말해서, 내 정장을 찢을지도 모르겠군. 그나마."
    DESCRIBE.POLARAMULET = "이 줄에 마법이 깃들었군. 무슨 마법인지는 모르지만."
    DESCRIBE.POLARBEARHAT = "진심으로 혐오스럽군."
    DESCRIBE.POLARCROWNHAT = "강력하고 우아하지만, 무척 불편하다."
    DESCRIBE.POLARFLEA_SACK = "얼어 죽는 것보단 나을... 수도 있겠지."
    DESCRIBE.POLARICESTAFF = "적절한 주문이... 엉뚱한 손에 들어갔군."
    DESCRIBE.POLARMOOSEHAT = "음. 매우... 투박하군."

    -- 기타
    DESCRIBE.POLARGLOBE = {
        GENERIC = "건.드.리지. 마.",
        INUSE = "역시... 안 좋은 예감은 틀리지 않지.",
        REFUEL = "바다에 던져버릴까?",
    }
    DESCRIBE.OCEANFISH_IN_ICE = "수치스럽지도 않냐, 물고기야?"
    DESCRIBE.POLARICEPACK = "세균이 좀 더 오래 못 살아남겠군."
    DESCRIBE.POLARTRINKET_1 = "어딜 가도 이 친구들한텐 못 도망치겠군."
    DESCRIBE.POLARTRINKET_2 = "어딜 가도 이 아가씨들한텐 못 도망치겠군."
    DESCRIBE.TRAP_POLARTEETH = "악의적이군. 마음에 들어!"
    DESCRIBE.TURF_POLAR_CAVES = "땅이지, 뭐."
    DESCRIBE.TURF_POLAR_DRYICE = "그나마 유용한 것 중 하나군."
    DESCRIBE.WALL_POLAR = "이 분위기, 마음에 든다."
    DESCRIBE.WALL_POLAR_ITEM = "얼음 벽돌 사이즈군. 좋아."
    DESCRIBE.WINTER_ORNAMENTPOLAR = "은근히 멋있고, 고상하군."
    DESCRIBE.WX78MODULE_NAUGHTY = "그 로봇, 좀 조립이 필요해 보이는데."

