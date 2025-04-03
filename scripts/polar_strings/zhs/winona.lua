local ANNOUNCE = STRINGS.CHARACTERS.WINONA
local DESCRIBE = STRINGS.CHARACTERS.WINONA.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "来吧，挥舞你的爪子！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"停不下来……不会停下来……好吧，停下来了。",
		"我不会放慢速度……我只是在调整步伐……",
		"呼……我需要在外面喘口气！",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "呼！结束了。而且……在下雪？"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "不行。坏主意。"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "至少有些BOSS会留下礼物。"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "哎呀！我穿得不够多！"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "现在要经历一番折磨了……"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "烧吧，小树，烧吧！",
		BURNT = "它在雪中撒下了灰烬。",
		CHOPPED = "只是雷声大雨点小…你懂的。",
		GENERIC = "看起来很尖，但我有更尖的。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "我不知道它会长成什么。"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "对了。我的安全帽！"
	DESCRIBE.POLAR_ICICLE_ROCK = "希望做这些我能拿到点危险津贴。"
	DESCRIBE.ROCK_POLAR = "那我就不客气了。"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "里面有什么，谁也不知道。"
	DESCRIBE.TUMBLEWEED_POLAR = "他们说每一个都是独一无二的，里外皆然。"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "直接撞上麻烦了，嗯？",
		ANTLER = "看起来很强。是时候看看它是否真的如此了。",
	}
	DESCRIBE.MOOSE_SPECTER = "我现在只是想观察观察它。"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "有点太浮夸了，不太合我胃口，但还是可以接受。"
	DESCRIBE.POLARBEAR = {
		DEAD = "彻底倒下了！",
		ENRAGED = "哎呀，我们有熊的麻烦了！",
		FOLLOWER = "那么，你最喜欢的鱼是什么？",
		GENERIC = "别对我那么冷淡。"
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "我知道我最好离它们远点。",
		HELD = "哎呀！走开！",
		HELD_BACKPACK = "我才是这里的老大。我说了才能咬人。",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "你给我兔子，我给你晚餐，很简单吧。",
		FRIEND = "我是不是忘了我们的小约定？",
		GENERIC = "过来这里，你这小调皮！",
	}
	DESCRIBE.POLARWARG = "我相信它嘴里一定是薄荷味的是不。"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "点燃火吧！",
		ON = "这设计看起来很熟悉...一定是我的错觉。",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "一个便利的光源。"
	DESCRIBE.POLAR_THRONE = "权力与怠惰的展示。"
	DESCRIBE.POLAR_THRONE_GIFTS = "小帮手们一直保持它们的干净。"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "站外面都待比在这破房子里面好。",
		OPEN = "伙计，你听说过适当的照明吗？这里太阴森了。",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "嗯。可能又是一场野火。",
		GENERIC = "这地方闻起来有够可疑。",
		--I know that 'fishy' has a double meaning, referring to both 'suspicious' and 'fish,' 
		--but I couldn't think of a suitable expression in Chinese, 
		--so I only translated the 'suspicious' meaning."
	}
	DESCRIBE.POLARICE_PLOW = "我应该往旁边挪一小段距离。"
	DESCRIBE.POLARICE_PLOW_ITEM = "鱼儿们，你们躲够了。"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "吃过这东西后，雪可真不算什么了。"
	DESCRIBE.ICELETTUCE = "这是用薄荷来冷冻？它就像是被冷冻了一样！"
	DESCRIBE.ICEBURRITO = "这卷正适合用来结束这好卷的一天。"
	--Great, my brain cells are almost filled up with puns.
	--This food is '捲 wrapped' up, and to make it a pun.
	--So I translated it as: 'End this "好捲" of a day with this wrap.'
    --'好捲' in Chinese means that during a competition, both sides become more and more exhausted from each other."
	DESCRIBE.POLARCRABLEGS = "我只需要一点点奢侈就满足了。"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "我可不敢没戴手套碰这个。"
	DESCRIBE.BLUEGEM_SHARDS = "我敢说这冷到能直接黏回去。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "你打得不错，小伙子。"
	DESCRIBE.POLAR_DRYICE = "这能送上流'冰'线。"
	--This can't be translated into Chinese with a homophone pun, 
	--so I chose a similar word pun instead, not a typo.
	--It should originally be 流'水'線(assembly line).
	DESCRIBE.POLARBEARFUR = "它很温暖，更重要的是，它是我的。"
	DESCRIBE.POLARWARGSTOOTH = "我猜你这不是用来吃植物的对吧。"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "这可能会派上用场。"
	DESCRIBE.ARMORPOLAR = "这是我能弄到的最坚固的皮革了。"
	DESCRIBE.FROSTWALKERAMULET = "这样我就不会在工作时滑倒了，哈！"
	DESCRIBE.ICICLESTAFF = "在用这个时我可不会忽视风往哪吹。"
	DESCRIBE.POLAR_SPEAR = "噗。好吧。假设你住在冷冻库里..."
	DESCRIBE.POLARAMULET = "它说这些都是独一无二什么的。"
	DESCRIBE.POLARBEARHAT = "两个头总比一个好。"
	DESCRIBE.POLARCROWNHAT = "如果不会出汗，就不会被看出我捏了把冷汗。"
	--n order to create a pun with synonyms, I slightly adjusted the meaning here. 
	--In Chinese, "捏了一把冷汗(Break into a cold sweat.)" is used to describe a situation of extreme nervousness.
	DESCRIBE.POLARFLEA_SACK = "惹我的话，也就是惹我背上的虫子们。"
	DESCRIBE.POLARICESTAFF = "用冰冻来达成你的目的吧。"
	DESCRIBE.POLARMOOSEHAT = "嘿，伍迪。你的尾巴毛还在吗？"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "哈！查理会喜欢这些小东西。",
		INUSE = "哦，你……",
		REFUEL = "不确定怎么漏的。不过这样也好。",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "呵。免费的鱼！"
	DESCRIBE.POLARICEPACK = "那一小块冰的效果可大了。"
	DESCRIBE.POLARTRINKET_1 = "你那条围巾不错。真希望我也有一条。"
	DESCRIBE.POLARTRINKET_2 = "呃，看起来他们两条生产线混乱了。"
	DESCRIBE.TRAP_POLARTEETH = "残酷但聪明。"
	DESCRIBE.TURF_POLAR_CAVES = "那是一块地面。"
	DESCRIBE.TURF_POLAR_DRYICE = "那是一块路面。"
	DESCRIBE.WALL_POLAR = "是的，这真冰。"
	DESCRIBE.WALL_POLAR_ITEM = "组装时间。"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "没有什么比这更能代表冬天了。"
	DESCRIBE.WX78MODULE_NAUGHTY = "WX，你得停止到处丢这些东西！"