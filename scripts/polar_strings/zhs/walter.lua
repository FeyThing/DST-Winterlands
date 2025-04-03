local ANNOUNCE = STRINGS.CHARACTERS.WALTER
local DESCRIBE = STRINGS.CHARACTERS.WALTER.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "小心沃比！我在和一只又大又可怕的熊战斗！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"沃比！你在哪里——啊，你在这里！",
		"我们应该往北走……不，往南！",
		"哇……",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "那真是……酷！甚至有点冷！"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "让我们试试更稳固的地方。"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "不错！差不多是我想要的。"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "我..我需要更厚的衣物……！"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "至少我的毛发已经解冻了。"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "一棵着火的树？在这里？在所有地方？",
		BURNT = "嗯。我很想知道这是怎么发生的。",
		CHOPPED = "斧头赢了这场战斗。",
		GENERIC = "这个幽魂……啊，这是一棵树。不过还是很酷。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "我们应该把它种在哪里，沃比？"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "我想知道它什么时候会掉下来。"
	DESCRIBE.POLAR_ICICLE_ROCK = "哇！你看到它掉下来了吗？"
	DESCRIBE.ROCK_POLAR = "看看里面有多少沃比！"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "嗯？沃比……这里面有什么？"
	DESCRIBE.TUMBLEWEED_POLAR = "可怕的雪花！我终于找到了它！"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "它是怎么失去角的？这真是一个悲剧的故事。",
		ANTLER = "嗯。看起来不太神秘！但也许如果它是白色的，藏在暴风雪中……",
	}
	DESCRIBE.MOOSE_SPECTER = "我知道！我知道……一直以来！哈哈！"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "嘿，看看那些可怕的眼睛！"
	DESCRIBE.POLARBEAR = {
		DEAD = "先生？先生，我想你需要我们的帮助！",
		ENRAGED = "你有多大的牙齿！",
		FOLLOWER = "你比他们在广播节目中说的更容易驯服。",
		GENERIC = "我是对的。那三个黑点，实际上，这是一只北极熊。"
		--Generally, POLARBEAR is translated as "北极熊",so if the character is from the real world, they would be referred to as a '北极熊' rather than an '极地熊' which doesn't specifically refer to a bear from the Arctic.
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "看看这个——呃，这些酷虫虫！",
		HELD = "我的手册说……现在想把它移除已经太晚了。",
		HELD_BACKPACK = "没有什么能阻止我和我的虫子们！",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "我想他喜欢我们！",
		FRIEND = "他可以再吃点零食。",
		GENERIC = "去吧，女孩！",
	}
	DESCRIBE.POLARWARG = "可怜的东西一定迷路了。"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "一个可携式的火坑。",
		ON = "呃...有人带便携式棉花糖袋吗？",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "总有一天沃比，你会搬运整个基地！"
	DESCRIBE.POLAR_THRONE = "你不觉得过一阵子就会感到无聊吗，麦斯威尔先生？"
	DESCRIBE.POLAR_THRONE_GIFTS = "东西可能不见了。"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "哦，这一定是我听说过的牙科博物馆！",
		OPEN = "嗨！你们对访客开放吗？",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "那是一种我见过的'霜烤'。呵呵。",
		GENERIC = "你觉得他们会用雪做家具吗？",
	}
	DESCRIBE.POLARICE_PLOW = "别担心，我知道该怎么做。"
	DESCRIBE.POLARICE_PLOW_ITEM = "也许沃比能用气味找到鱼？"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "冰淇淋，气泡水版本。"
	DESCRIBE.ICELETTUCE = "这会让莴苣结冻吗？你明白吗？因为……算了……"
	DESCRIBE.ICEBURRITO = "它一点都不会散开。"
	DESCRIBE.POLARCRABLEGS = "嗯！嘿，有人想听我的螃蟹恐怖故事吗？"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "从一颗魔法蓝宝石到……我不知道……一颗被诅咒的蓝宝石？"
	DESCRIBE.BLUEGEM_SHARDS = "我敢打赌我可以拼凑出这个谜团。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "这不必发展成这样。"
	DESCRIBE.POLAR_DRYICE = "让我们建造一个雪人！"
	DESCRIBE.POLARBEARFUR = "哇，看看里面有多少跳蚤！"
	DESCRIBE.POLARWARGSTOOTH = "提醒我，我得快点给你刷牙了，女孩。"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "一根好棍子，可以用来玩接球和……其他几件事。"
	DESCRIBE.ARMORPOLAR = "护甲也可以防护其他东西，对吧？"
	DESCRIBE.FROSTWALKERAMULET = "哦，呃……我也许应该用它做一个狗项圈。"
	DESCRIBE.ICICLESTAFF = "我们拿来射射看吧？呵呵。好主意，沃尔特。"
	DESCRIBE.POLAR_SPEAR = "抱歉沃比，你不能拥有这个。"
	DESCRIBE.POLARCROWNHAT = "那么，我们什么时候建造我的冰城堡？"
	DESCRIBE.POLARFLEA_SACK = "最好小心点，你正在我口袋虫子的攻击范围内。"
	DESCRIBE.POLARAMULET = "来自纪念品商店的小东西。"
	DESCRIBE.POLARBEARHAT = "沃比一直在对它咆哮..."
	DESCRIBE.POLARICESTAFF = "我为所有在这里的昆虫感到抱歉，它们只是忙着自己的事。"
	DESCRIBE.POLARMOOSEHAT = "毫无疑问是驼鹿毛。你闻到了吗？"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "嘿，摇一摇！",
		INUSE = "这意味着……我手上有个个闹鬼的饰品！",
		REFUEL = "雪在哪里……闹鬼的雪？",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "搞不好里面藏着一只迷你长毛象？"
	DESCRIBE.POLARICEPACK = "这不会让我的肉干永不腐烂，但至少更近了一步。"
	DESCRIBE.POLARTRINKET_1 = "他似乎准备好来打雪仗了。我也准备好了！"
	DESCRIBE.POLARTRINKET_2 = "等等……我认得你。"
	DESCRIBE.TRAP_POLARTEETH = "如果这个不能抓到海狸人，我就放弃！"
	DESCRIBE.TURF_POLAR_CAVES = "一片小天地。"
	DESCRIBE.TURF_POLAR_DRYICE = "一条让我腿上发抖的道路。"
	DESCRIBE.WALL_POLAR = "这雾气营造出一种很棒的阴森氛围。"
	DESCRIBE.WALL_POLAR_ITEM = "你别给我舔它，沃比！"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "好吧，这很符合季节。"