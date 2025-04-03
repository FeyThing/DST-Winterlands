local ANNOUNCE = STRINGS.CHARACTERS.WAXWELL
local DESCRIBE = STRINGS.CHARACTERS.WAXWELL.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "脑子比爪子重要！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"别误解我的意思……但我需要一件外套……还有一根手杖……",
		"我的仆人可以让这变得容易得多……",
		"雪……冰……毁了我的西装……",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "又是谁在玩这个该死的东西？"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "我宁愿不打破那冰。"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "我感觉这事不单纯。"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "我穿得不足够合适。"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "(叹气) 这是一个教训。"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "它为了我的舒适而牺牲了自己。",
		BURNT = "它不会再更有用了……除非……。",
		CHOPPED = "树啊，你得做得更好。",
		GENERIC = "哼。破烂的东西……它几乎无法支撑。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "我应该把它种下吗？"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "简单却绝妙。"
	DESCRIBE.POLAR_ICICLE_ROCK = "你不会有第二次机会。"
	DESCRIBE.ROCK_POLAR = "新鲜的供应品。"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "这是……雪中的一个东西。"
	DESCRIBE.TUMBLEWEED_POLAR = "一个异想天开的展示，但完全不重要。"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "现在根本不具威胁。",
		ANTLER = "大角，大角度。",
	}
	DESCRIBE.MOOSE_SPECTER = "哼。多么……威严。"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "我一位水族学家的朋友会为此付出一大笔钱。"
	DESCRIBE.POLARBEAR = {
		DEAD = "大自然会照顾你剩下的。",
		ENRAGED = "哦，好吧。他们正在拔牙。",
		FOLLOWER = "我说最后一次。我们不会去钓鱼！",
		GENERIC = "他们是一群有趣的家伙。",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "不！不！",
		HELD = "这会痛，但我不会把它当宠物养。",
		HELD_BACKPACK = "你不能逼我留着那东西。",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "我们现在是一体的。",
		FRIEND = "好久不见，朋友。",
		GENERIC = "一路走好。",
	}
	DESCRIBE.POLARWARG = "多么美妙的适应。"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "我从不说谎，我喜欢火盆",
		ON = "很原始。不过效果不错。",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "我开始觉得自己像个驮兽了"
	DESCRIBE.POLAR_THRONE = "所以从这里往下看是这样的？"
	DESCRIBE.POLAR_THRONE_GIFTS = "这次又在玩什么把戏？"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "哎呀，哎呀，真是一个好客的住所。",
		OPEN = "...我会假装我没看到里面的东西。",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "如果炎热的阳光能饶过这个地方就好了。",
		GENERIC = "我闻到里面有什么腐烂的东西。恶。",
	}
	DESCRIBE.POLARICE_PLOW = "最好站远点，否则你会变成鱼食。"
	DESCRIBE.POLARICE_PLOW_ITEM = "绝望时刻需要破坏性措施。"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "你可以用那东西打碎头骨。"
	DESCRIBE.ICELETTUCE = "所以，我们现在吃的是脆脆的水？"
	DESCRIBE.ICEBURRITO = "我不认为它的味道很差，但……"
	DESCRIBE.POLARCRABLEGS = "配上融化的奶油会很完美。"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "我正在拿回我应得的东西，即使它变了一点。"
	DESCRIBE.BLUEGEM_SHARDS = "闪闪发光。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "我应该提取里面的魔法。"
	DESCRIBE.POLAR_DRYICE = "这让我想到……我从没用冰来雕刻自己的雕像过。"
	DESCRIBE.POLARBEARFUR = "现在这是——啊！这么多跳蚤！"
	DESCRIBE.POLARWARGSTOOTH = "我说，看起来相当时尚。"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "啊，这可以派上用场。"
	DESCRIBE.ARMORPOLAR = "实用，而且挺精致。"
	DESCRIBE.FROSTWALKERAMULET = "对被我踩在脚下的鱼来说真是可怜。不过，哦，好吧。"
	DESCRIBE.ICICLESTAFF = "比烂番茄更糟的命运。"
	DESCRIBE.POLAR_SPEAR = "我承认，它可能会撕裂我的西装。"
	DESCRIBE.POLARAMULET = "他们在绳子上施了些魔法。具体是什么，我不太确定。"
	DESCRIBE.POLARBEARHAT = "我真的很反感。"
	DESCRIBE.POLARCROWNHAT = "强大而优雅，但也不舒服。"
	DESCRIBE.POLARFLEA_SACK = "几乎不比冻死好到哪去。"
	DESCRIBE.POLARICESTAFF = "正确的咒语，却在错误的手中。"
	DESCRIBE.POLARMOOSEHAT = "嗯。非常……乡村风格。"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "不。要。碰。它。",
		INUSE = "我就知道这是个坏主意。",
		REFUEL = "我应该把你扔进海里。",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "鱼，你不觉得尴尬吗？"
	DESCRIBE.POLARICEPACK = "这将让细菌远离更久一些。"
	DESCRIBE.POLARTRINKET_1 = "这些家伙真的无处可逃。"
	DESCRIBE.POLARTRINKET_2 = "这些女孩真的无处可逃。"
	DESCRIBE.TRAP_POLARTEETH = "恶意。不过我喜欢！"
	DESCRIBE.TURF_POLAR_CAVES = "草皮。"
	DESCRIBE.TURF_POLAR_DRYICE = "至少这个是有用的。"
	DESCRIBE.WALL_POLAR = "我喜欢它们带来的氛围感。"
	DESCRIBE.WALL_POLAR_ITEM = "墙壁大小的冰块。是的。"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "这挺微妙的，但很精巧。"
	DESCRIBE.WX78MODULE_NAUGHTY = "那个机器人需要重新整理一下。"