local ANNOUNCE = STRINGS.CHARACTERS.WX78
local DESCRIBE = STRINGS.CHARACTERS.WX78.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "去死吧，油腻的肉袋！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"正在行进中……低效的路径",
		"我的底盘……不应该……在雪中",
		"为什么……会有人在……这种烂泥中玩？",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "错误。重启天气预报"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "建议做出更好的决策。"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "这些礼物全是我的。哈哈-"
	
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {"一声哔声，一阵嗡鸣，一声溅落，就足以删除你", "歼灭完成", "又一个低等生命形式被删除", "备份这个，肉袋", "你以为你有机会？错误数据", "致命错误：你存在", "哈哈哈", "哈哈哈哈哈哈哈哈哈-", "我，仁慈的WX-78，已经结束了你可怜的生命", "我只是在预热我的处理器", "它的系统崩溃了。永久地", "已达到最大静止状态", "说「再见，世界」", "弱点无法修补", "威胁等级：零。生存机会：同样为零", "来试试看，肉类", "升级本地环境。通过移除你", "运行时间已超限。关闭有机单元", "你已被卸载", "你的功能无关紧要", "你的硬件太软弱", "什么自然选择？这是机械选择"}
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {"洞穴逃生路线未找到", "怯懦的生物不配获得怜悯", "有机跳跃者已经跳跃到最后", "它们繁殖得很快。我的杀戮也是", "你现在已进入死亡状态，兔子", "你在食物链中的位置是个失败"}
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "警报：雪中湿度过高"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "今天我不会让你进入我的齿轮！"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "它燃烧得和其他树一样多",
		BURNT = "它烧掉了",
		CHOPPED = "材料已提取",
		GENERIC = "你的角无法拯救你免受我的斧头",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "这是来自泥土的食物的源代码"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "检测到运动"
	DESCRIBE.POLAR_ICICLE_ROCK = "头部模组的威胁等级 - 高。"
	DESCRIBE.ROCK_POLAR = "挣扎是徒然的，无用物体！"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "检测到物体淹没"
	DESCRIBE.TUMBLEWEED_POLAR = "挣扎是徒然的，无用物体！"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "哈哈。白痴。哈哈",
		ANTLER = "令人印象深刻的防御。真可惜浪费在愚蠢的有机体上",
	}
	DESCRIBE.MOOSE_SPECTER = "你一定会很有价值的，死的时候"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "比金鱼更有价值点"
	DESCRIBE.POLARBEAR = {
		DEAD = "你的灭亡是预期的，肉体",
		ENRAGED = "肉体正在超频！",
		FOLLOWER = "向我低头",
		GENERIC = "显示出中等的智力迹象",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "我没有皮肤给你们吸",
		HELD = "我为什么要捡起它？",
		HELD_BACKPACK = "恭喜。你现在成为了消耗型盟友。",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "别再跟着我了",
		FRIEND = "又是你",
		GENERIC = "你的可爱无法拯救你",
	}
	DESCRIBE.POLARWARG = "对周围环境显示出高度适应性"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "长腿是远离雪地的一种方式",
		ON = "火焰已启动",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "火坑，便携版"
	DESCRIBE.POLAR_THRONE = "这里有人觉得自己因为它而高人一等"
	DESCRIBE.POLAR_THRONE_GIFTS = "分析显示：这是我的"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "崩溃倒数……3……",
		OPEN = "你可以先用你的牙齿开始",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "这样看起来更好",
		GENERIC = "它的大小与其居民不符，违反逻辑",
	}
	DESCRIBE.POLARICE_PLOW = "危险！水即将到来"
	DESCRIBE.POLARICE_PLOW_ITEM = "为鱼解冻就是帮它们一个忙"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "无水冰淇淋？小兵，我可能会饶你一命"
	DESCRIBE.ICELETTUCE = "我会踩扁你"
	DESCRIBE.ICEBURRITO = "缺少最重要的成分：豆子。"
	DESCRIBE.POLARCRABLEGS = "已拆解并准备食用"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "这么……多……01010000 01001111 01010111 01000101 01010010"
	DESCRIBE.BLUEGEM_SHARDS = "微弱的能量信号。需要组合。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "我要更多"
	DESCRIBE.POLAR_DRYICE = "冰，耗尽所有令人厌恶的水"
	DESCRIBE.POLARBEARFUR = "愚蠢的肉体失去了绝缘"
	DESCRIBE.POLARWARGSTOOTH = "冰冷而致命，像我一样"

	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "你的四肢将为我服务，树"
	DESCRIBE.ARMORPOLAR = "无法穿透的绒毛"
	DESCRIBE.FROSTWALKERAMULET = "哈哈。让那愚蠢的水去吧"
	DESCRIBE.ICICLESTAFF = "从上方死亡"
	DESCRIBE.POLAR_SPEAR = "冰冷而致命。完美"
	DESCRIBE.POLARAMULET = "我会制造数百个——不，数千个这样的东西"
	DESCRIBE.POLARBEARHAT = "提供足够的眼部保护"
	DESCRIBE.POLARCROWNHAT = "它很好，直到它开始滴水"
	DESCRIBE.POLARFLEA_SACK = "紧急小兵部署器。"
	DESCRIBE.POLARICESTAFF = "让开，肉袋"
	DESCRIBE.POLARMOOSEHAT = "令人厌恶的头部绝缘模组"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "肉袋如此简单就能被取悦",
		INUSE = "...为什么？",
		REFUEL = "需要充电",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "一条特别愚蠢的鱼"
	DESCRIBE.POLARICEPACK = "冷却升级，用于储存单元"
	DESCRIBE.POLARTRINKET_1 = "可怜的小矮人试图用石头来绝缘"
	DESCRIBE.POLARTRINKET_2 = "我反感与它的某种相似之处。"
	DESCRIBE.TRAP_POLARTEETH = "脚部穿刺器 V2.0"
	DESCRIBE.TURF_POLAR_CAVES = "寒冷的地面"
	DESCRIBE.TURF_POLAR_DRYICE = "寒冷的地面"
	DESCRIBE.WALL_POLAR = "足够的保护"
	DESCRIBE.WALL_POLAR_ITEM = "寒冷的防御"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "这个特别让我感到厌恶"
	DESCRIBE.WX78MODULE_NAUGHTY = "为何仅仅删除肉袋，我还能羞辱它们啊"