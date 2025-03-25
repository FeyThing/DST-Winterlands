local ANNOUNCE = STRINGS.CHARACTERS.WEBBER
local DESCRIBE = STRINGS.CHARACTERS.WEBBER.DESCRIBE

-- 발표

    -- 행동
    ANNOUNCE.BATTLECRY.POLARBEAR = "곰아, 이제 겨울잠 잘 시간이야!"

    -- 세계, 이벤트
    ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
        "우리가... 계속 빙글빙글 도는 거야?",
        "저기요...? 아무도 없나요?",
        "눈 속에서 친구들을 잃고 싶지 않아...",
    }
    ANNOUNCE.ANNOUNCE_POLARGLOBE = "땅이 젤리처럼 흔들렸어!"
    ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "여긴 너무 위험해."
    ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "오! 이거 꽤 괜찮은걸-"

    -- 버프
    ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "엄마가 날 이렇게 보면 혼날 텐데..."
    ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "다시 눈 놀이 해도 돼? 이번엔 외투 입고!"

-- 월드 생성

    -- 식물
    DESCRIBE.ANTLER_TREE = {
        BURNING = "무섭게 생겼어!",
        BURNT = "곧 부러질지도 몰라.",
        CHOPPED = "어이쿠, 싸움에서 졌나 봐.",
        GENERIC = "무스들은 안 좋아하지만, 우리는 좋아해!",
    }
    DESCRIBE.ICELETTUCE_SEEDS = "심으면 뭔가 자랄지도!"

    -- 바위와 돌
    DESCRIBE.POLAR_ICICLE = "조심해서 지나가야 해."
    DESCRIBE.POLAR_ICICLE_ROCK = "못된 얼음이다!"
    DESCRIBE.ROCK_POLAR = "정말 멋진 얼음 발견이야!"

    -- 기타
    ANNOUNCE.DESCRIBE_IN_POLARSNOW = "무언가 봤어! 근데 뭐였지?"
    DESCRIBE.TUMBLEWEED_POLAR = "혀에 올려놔도 절대 안 녹을 거야."

-- 생물

    DESCRIBE.MOOSE_POLAR = {
        GENERIC = "머리를 부딪혔나 봐! 불쌍한 무스...",
        ANTLER = "생각했던 것보다 훨씬 커!",
    }
    DESCRIBE.MOOSE_SPECTER = "조금... 으스스해 보여."
    DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "바다 속 보물 낚았다!"
    DESCRIBE.POLARBEAR = {
        DEAD = "으... 벼룩투성이야.",
        ENRAGED = "미안해! 미안해에에!",
        FOLLOWER = "우리에겐 커다란 곰 인형이 생겼어!",
        GENERIC = "여기 마을에 우리도 들어가도 돼?",
    }
    DESCRIBE.POLARFLEA = {
        GENERIC = "으악!",
        HELD = "다음부턴 주머니 안 열 거야!",
        HELD_BACKPACK = "엄마가 학교 가방엔 벌레 넣지 말랬는데...",
    }
    DESCRIBE.POLARFOX = {
        FOLLOWER = "눈 위에 천사 만들래?",
        FRIEND = "우릴 기억하고 있어!",
        GENERIC = "배고픈가 봐.",
    }
    DESCRIBE.POLARWARG = "설마 예티가 강아지를 키울 줄은 몰랐지!"

-- 건물

    DESCRIBE.POLAR_BRAZIER = {
        GENERIC = "불 켜졌어? 아래에선 안 보여!",
        ON = "하아~ 이거 필요했어!",
    }
    DESCRIBE.POLAR_BRAZIER_ITEM = "어디든 우리 집이 될 수 있어."
    DESCRIBE.POLAR_THRONE = "정말 높아 보여!"
    DESCRIBE.POLAR_THRONE_GIFTS = "‘-W’에게... 그거 우리 맞지?"
    DESCRIBE.POLARAMULET_STATION = {
        GENERIC = "왈터가 불가에서 말한 오두막이랑 닮았어!",
        OPEN = "자꾸 이빨 쳐다보지 말라구!",
    }
    DESCRIBE.POLARBEARHOUSE = {
        BURNT = "천장에 있던 거미야... 안녕...",
        GENERIC = "밖보단 안이 훨씬 나을 것 같아.",
    }
    DESCRIBE.POLARICE_PLOW = "너무 가까이 가면 물고기랑 눈 마주칠지도 몰라!"
    DESCRIBE.POLARICE_PLOW_ITEM = "물고기를 얼음에서 꺼내주는 기계야!"

-- 아이템

    -- 음식
    DESCRIBE.DRYICECREAM = "거꾸로 들어도 안 떨어져!"
    DESCRIBE.ICELETTUCE = "채소 먹으래서 먹는데... 왜 파란색이야?"
    DESCRIBE.ICEBURRITO = "전설에 따르면 절대 안 터진대!"
    DESCRIBE.POLARCRABLEGS = "우린 다리보다 많지 않으니까 친구들이랑 나눠 먹어야지!"

    -- 제작
    DESCRIBE.BLUEGEM_OVERCHARGED = "반짝반짝! 시원해 보여!"
    DESCRIBE.BLUEGEM_SHARDS = "우리가 좀 더 조심했어야 했나?"
    DESCRIBE.MOOSE_POLAR_ANTLER = "뿔을 얻었어! 그리고... 목숨도!"
    DESCRIBE.POLAR_DRYICE = "눈싸움에선 금지야!"
    DESCRIBE.POLARBEARFUR = "푹신푹신 베개다!"
    DESCRIBE.POLARWARGSTOOTH = "우리 이빨보다 훨씬 날카롭다!"

    -- 장비
    DESCRIBE.ANTLER_TREE_STICK = "이게 진짜 완벽한 막대기야!"
    DESCRIBE.ARMORPOLAR = "평생 입고 싶어!"
    DESCRIBE.FROSTWALKERAMULET = "차가운 발이 젖은 발보다 나아!"
    DESCRIBE.ICICLESTAFF = "으악! 진짜 뾰족해 보여!"
    DESCRIBE.POLAR_SPEAR = "막대기에 커다란 고드름이 달린 것 같아!"
    DESCRIBE.POLARAMULET = "거미는 안 다쳤어요! 진짜로!"
    DESCRIBE.POLARBEARHAT = "으르렁!! 놀랐지?!"
    DESCRIBE.POLARCROWNHAT = "거미는 추운 거 별로 안 좋아해..."
    DESCRIBE.POLARFLEA_SACK = "등에 작은 친구들 다 태울 수 있어!"
    DESCRIBE.POLARICESTAFF = "얼음 거미줄 비상용!"
    DESCRIBE.POLARMOOSEHAT = "우디 아저씨 친구로 만든 모자래."

    -- 기타
    DESCRIBE.POLARGLOBE = {
        GENERIC = "눈이 천천히 움직여... 너무 천천히...",
        INUSE = "우리... 나쁜 아이 명단에 들어가는 거야?",
        REFUEL = "특별한 눈이 필요해!",
    }
    DESCRIBE.OCEANFISH_IN_ICE = "윌리를 풀어주자!"
    DESCRIBE.POLARICEPACK = "들고 있는 느낌이 재밌어... 잠깐은!"
    DESCRIBE.POLARTRINKET_1 = "우리도 저렇게 큰 옷 입고 싶어!"
    DESCRIBE.POLARTRINKET_2 = "우리도 저렇게 큰 옷 입고 싶어!"
    DESCRIBE.TRAP_POLARTEETH = "우리 얼음 거미줄이 점점 커진다!"
    DESCRIBE.TURF_POLAR_CAVES = "땅을 파서 나온 땅이야!"
    DESCRIBE.TURF_POLAR_DRYICE = "금 가면 밟지 마!"
    DESCRIBE.WALL_POLAR = "우리 눈성의 벽이다!"
    DESCRIBE.WALL_POLAR_ITEM = "첫 번째 규칙: 벽 핥지 마!"
    DESCRIBE.WINTER_ORNAMENTPOLAR = "심플하게 꾸미는 게 좋아!"
    DESCRIBE.WX78MODULE_NAUGHTY = "헉. 로봇 속은 저렇게 생겼나?"

