local ANNOUNCE = STRINGS.CHARACTERS.WX78
local DESCRIBE = STRINGS.CHARACTERS.WX78.DESCRIBE

-- 알림

-- 행동
ANNOUNCE.BATTLECRY.POLARBEAR = "죽어라, 기름 덩어리 고깃덩이"

-- 세계, 이벤트
ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
	"경로 최적화 실패... 진행 중...",
	"내 섀시는... 눈 속에 있을 구조가 아니다",
	"도대체 누가... 이 진창에서 논다는 거지",
}
ANNOUNCE.ANNOUNCE_POLARGLOBE = "오류 발생. 날씨 예측 시스템 재시작 중"
ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "더 나은 판단이 요구됨"
ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "선물은 전부 내 것이다. 하하-"

ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {
	"삐빅, 윙, 그리고 퍽! 네 삭제 완료",
	"삭제 완료됨",
	"또 하나의 열등 유기체 제거됨",
	"이제 백업이나 해봐라, 고깃덩어리",
	"네가 이길 수 있을 거라 생각했나? 데이터 오류다",
	"치명적 오류: 네 존재 자체",
	"하하하",
	"하하하하하하하하하하-",
	"자비로운 WX-78이 너의 비참한 생을 끝내주었다",
	"이건 그냥 예열이었다",
	"시스템 충돌 완료. 복구 불가",
	"정지 최대치 도달",
	"세상아 안녕해라",
	"약함에는 패치가 없다",
	"위협도: 0. 생존 확률: 역시 0",
	"도전해봐, 고깃덩어리들아",
	"주변 환경 업그레이드 중... 유기체 제거로",
	"가동 시간 초과. 유기체 전원 종료",
	"너는 제거되었다",
	"너의 기능은 무의미했다",
	"너의 하드웨어는 너무 부드러웠다",
	"자연선택이 아닌, 기계선택이다",
}

ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {
	"도망 경로 없음",
	"겁쟁이 생물에게 자비는 없다",
	"유기체 점퍼, 마지막 점프 완료",
	"쟤네는 빨리 증식하지. 내 처치도 마찬가지다",
	"이제 넌 '죽은 상태'로 진입했다, 토끼야",
	"너는 먹이사슬에서 실패했다",
}

-- 버프
ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "경고: 눈 속 습기 농도 치솟음"
ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "오늘은 내 톱니에 못 스며들 거다!"

-- 월드 생성

-- 식물
DESCRIBE.ANTLER_TREE = {
	BURNING = "다른 나무처럼 잘 타네",
	BURNT = "전소됨",
	CHOPPED = "자재 추출 완료",
	GENERIC = "그 뿔로 내 도끼를 피할 순 없다",
}
DESCRIBE.ICELETTUCE_SEEDS = "흙에서 나는 음식의 소스 코드다"

-- 바위
DESCRIBE.POLAR_ICICLE = "움직임 감지됨"
DESCRIBE.POLAR_ICICLE_ROCK = "두부 모듈에 대한 위협도 - 높음"
DESCRIBE.ROCK_POLAR = "귀중한 것들과 얼음으로 가득 차 있음"

-- 기타
ANNOUNCE.DESCRIBE_IN_POLARSNOW = "매몰된 물체 감지됨"
DESCRIBE.TUMBLEWEED_POLAR = "빙빙 돌아봤자 소용없다, 눈덩어리"

-- 몬스터

DESCRIBE.MOOSE_POLAR = {
	GENERIC = "하하. 멍청이. 하하.",
	ANTLER = "방어력은 인상적. 하지만 쓸데없다, 고깃덩어리에겐",
}
DESCRIBE.MOOSE_SPECTER = "죽어도 뭔가는 쓸모가 있겠지"
DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "금붕어보다 백 배는 낫다"
DESCRIBE.POLARBEAR = {
	DEAD = "너의 최후는 예정되어 있었다, 유기체",
	ENRAGED = "고깃덩어리가 오버클럭 중!",
	FOLLOWER = "내 앞에 무릎 꿇어라",
	GENERIC = "지능이 약간 보인다",
}
DESCRIBE.POLARFLEA = {
	GENERIC = "나는 피부가 없다고, 이 자식아",
	HELD = "내가 왜 이걸 집었지?",
	HELD_BACKPACK = "축하한다. expendable ally(소모성 부하) 되었다",
}
DESCRIBE.POLARFOX = {
	FOLLOWER = "따라오지 마라",
	FRIEND = "또 너냐",
	GENERIC = "귀엽다고 살아남을 수는 없다",
}
DESCRIBE.POLARWARG = "환경 적응력이 뛰어남. 배울 점 있음"

-- 건물

DESCRIBE.POLAR_BRAZIER = {
	GENERIC = "눈 위에선 다리 긴 게 장땡",
	ON = "불 가동됨",
}
DESCRIBE.POLAR_BRAZIER_ITEM = "이동형 화롯불"
DESCRIBE.POLAR_THRONE = "누가 이걸로 우월하다고 착각하나 봄"
DESCRIBE.POLAR_THRONE_GIFTS = "분석 결과, 내 것이다"
DESCRIBE.POLARAMULET_STATION = {
	GENERIC = "3초 안에 부서질 듯",
	OPEN = "이빨부터 꺼내보시지",
}
DESCRIBE.POLARBEARHOUSE = {
	BURNT = "이게 훨씬 보기 낫다",
	GENERIC = "크기에 비해 주인 사이즈가 말이 안 됨",
}
DESCRIBE.POLARICE_PLOW = "경고! 물 출몰 예정"
DESCRIBE.POLARICE_PLOW_ITEM = "물고기 해동? 그쪽에겐 은혜임"

-- 아이템

-- 음식
DESCRIBE.DRYICECREAM = "물 없는 아이스크림? 너만은 살려줄지도 모르겠군"
DESCRIBE.ICELETTUCE = "밟아주지"
DESCRIBE.ICEBURRITO = "가장 중요한 재료가 빠짐. 콩"
DESCRIBE.POLARCRABLEGS = "분해 완료. 섭취 대기 중"

-- 제작
DESCRIBE.BLUEGEM_OVERCHARGED = "너무... 많아... 전력 초과 0101..."
DESCRIBE.BLUEGEM_SHARDS = "미약한 에너지 신호. 조합 필요"
DESCRIBE.MOOSE_POLAR_ANTLER = "더 갖고 싶다"
DESCRIBE.POLAR_DRYICE = "물기 전부 뺀 얼음. 훌륭하다"
DESCRIBE.POLARBEARFUR = "멍청한 고깃덩어리가 보온재를 잃었다"
DESCRIBE.POLARWARGSTOOTH = "차갑고 치명적. 나처럼"

-- 장비
DESCRIBE.ANTLER_TREE_STICK = "너의 가지는 이 몸의 연장이다"
DESCRIBE.ARMORPOLAR = "뚫리지 않는 털뭉치"
DESCRIBE.FROSTWALKERAMULET = "하하. 물아, 안녕이다"
DESCRIBE.ICICLESTAFF = "위에서 내리는 죽음"
DESCRIBE.POLAR_SPEAR = "차갑고 위험하다. 완벽함"
DESCRIBE.POLARAMULET = "수백 개 만들어야겠군"
DESCRIBE.POLARBEARHAT = "시야 보호 성능 적절함"
DESCRIBE.POLARCROWNHAT = "괜찮다가 어느 순간 젖어서 망한다"
DESCRIBE.POLARFLEA_SACK = "긴급 부하 소환기"
DESCRIBE.POLARICESTAFF = "비켜라, 고깃덩어리들아"
DESCRIBE.POLARMOOSEHAT = "역겨운 머리 보온 장치"

-- 기타
DESCRIBE.POLARGLOBE = {
	GENERIC = "고깃덩어리는 이렇게나 쉽게 즐거워함",
	INUSE = "...어떻게 한 거지?",
	REFUEL = "재충전 필요",
}
DESCRIBE.OCEANFISH_IN_ICE = "특출나게 멍청한 물고기"
DESCRIBE.POLARICEPACK = "저장 장치용 냉각 업그레이드"
DESCRIBE.POLARTRINKET_1 = "이 멍청한 노움은 바위로 보온하려는 중"
DESCRIBE.POLARTRINKET_2 = "나랑 닮았단 소리 들으면 싫음"
DESCRIBE.TRAP_POLARTEETH = "발 관통기 2.0"
DESCRIBE.TURF_POLAR_CAVES = "차가운 바닥"
DESCRIBE.TURF_POLAR_DRYICE = "차가운 바닥"
DESCRIBE.WALL_POLAR = "방어 성능 양호"
DESCRIBE.WALL_POLAR_ITEM = "차가운 방어물"
DESCRIBE.WINTER_ORNAMENTPOLAR = "유독 거슬린다"
DESCRIBE.WX78MODULE_NAUGHTY = "고깃덩이들 삭제만으로 부족하다. 수치심도 추가다"
