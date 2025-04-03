local ANNOUNCE = STRINGS.CHARACTERS.GENERIC
local DESCRIBE = STRINGS.CHARACTERS.GENERIC.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "这可能熊熊有问题。"
	--This was originally a pun where "bear" simultaneously referred to "bear" (noun, the animal) and "bear" (verb, meaning to produce or endure). 
	--To preserve the pun in Chinese, I adapted it to "熊熊" (an adjective meaning "very sudden"). 
	--The phrase "熊熊有" can imply a very sudden appearance while also referencing the presence of a bear (noun, the animal).
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"相信我……这是一条……捷径。",
		"嗯……",
		"哈……",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "震动和颤抖——刚刚发生了什么？！"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "在这冰行不通，换个地方吧。"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "嗯。没有那么糟糕嘛。"
	
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {"only_used_by_wx78"}
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {"only_used_by_wx78"}
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "哇！这可不是开玩笑！"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "我干了，但只是雪的问题。"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "谁会拒绝火呢。",
		BURNT = "这与周围的环境形成了强烈对比。",
		CHOPPED = "最好在其他树木注意到之前快点溜走。",
		GENERIC = "这棵树在挑衅我。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "这是一颗什么东西的种子。"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "刚才它动了吗？"
	DESCRIBE.POLAR_ICICLE_ROCK = "是的，它肯定动了。"
	DESCRIBE.ROCK_POLAR = "新鲜的宝石等待收获。"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "我想我在这里看到了什么。"
	DESCRIBE.TUMBLEWEED_POLAR = "这不科学。"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "失去了角，它一定很难受。",
		ANTLER = "我最好远离它的路径。",
	}
	DESCRIBE.MOOSE_SPECTER = "看来当地的传说是真的。"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "那些眼睛值一大笔钱！"
	DESCRIBE.POLARBEAR = {
		DEAD = "一堆雪……不，等等。",
		ENRAGED = "他叫得多大声咬合力就有多强！",
		FOLLOWER = "这是我的熊麻吉。",
		GENERIC = "一个可怕又可爱的家伙。",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "该逃咯！",
		HELD = "它的下颚已经深入我的皮肤了。",
		HELD_BACKPACK = "我对这个想法充满信心，它一定会成功。",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "来玩个小游戏吧。",
		FRIEND = "他有一张熟悉的面孔。看起来我也是。",
		GENERIC = "啊哈！过来！",
	}
	DESCRIBE.POLARWARG = "有了这样的毛皮，寒冷一定不算什么。"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "一个口袋大小的火坑。",
		ON = "现在太热了不能放进口袋里。除非我熄灭火焰。",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "科学表明，便携式的东西总是更好的。"
	DESCRIBE.POLAR_THRONE = "看起来很舒适。"
	DESCRIBE.POLAR_THRONE_GIFTS = "那是我的名字吗？我看不清那爪子写的字。"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "这个小屋怎么还不倒真是个谜。",
		OPEN = "呃，我的错。错误的地址。",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "我的鱼啊！",
		GENERIC = "我怀疑在里面也不会比较暖和。",
	}
	DESCRIBE.POLARICE_PLOW = "我对下面有什么东西非常好奇。"
	DESCRIBE.POLARICE_PLOW_ITEM = "最好的鱼总是藏起来的那条。"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "二氧化碳的风味，难以超越。"
	DESCRIBE.ICELETTUCE = "这调味有点太过头了。"
	DESCRIBE.ICEBURRITO = "我真喜欢这个名字。"
	DESCRIBE.POLARCRABLEGS = "有十条腿的好处是，每个人都有份。"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "我收回之前的话。这个闪耀着寒冷的能量！"
	DESCRIBE.BLUEGEM_SHARDS = "一个矿物学的谜题。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "这东西真重！"
	DESCRIBE.POLAR_DRYICE = "我可以用这个建造一些非~常酷的东西。"
	DESCRIBE.POLARBEARFUR = "真舒适，它很毛暖。"
	DESCRIBE.POLARWARGSTOOTH = "它更锋利了！"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "科学能够解释为什么这根棍子是完美的。"
	DESCRIBE.ARMORPOLAR = "就是这个东西！"
	DESCRIBE.FROSTWALKERAMULET = "科学知道该如何解释这个现象……但我不知道。"
	DESCRIBE.ICICLESTAFF = "非常有用，前提是别提那次「事故」。"
	DESCRIBE.POLAR_SPEAR = "那是一根大冰棒！"
	DESCRIBE.POLARAMULET = "它在做……某件事情，肯定的。"
	DESCRIBE.POLARBEARHAT = "被吃掉也有意想不到的优点呢。"
	DESCRIBE.POLARCROWNHAT = "那么，什么能保护我不脑冻呢？"
	DESCRIBE.POLARFLEA_SACK = "用来装那些咬人的小盟友。"
	DESCRIBE.POLARICESTAFF = "我喜欢我所有的法杖，但这根是最冷的。"
	DESCRIBE.POLARMOOSEHAT = "相当有艺术感的头饰。"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "它还在动。",
		INUSE = "我们不要再这样了！",
		REFUEL = "雪去哪里了？",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "那是一个鱼冰块。"
	DESCRIBE.POLARICEPACK = "遗憾的是，这对保存我的状态没什么帮助。"
	DESCRIBE.POLARTRINKET_1 = "一个浸透了冬季传说的文物，肯定的。"
	DESCRIBE.POLARTRINKET_2 = "一个浸透了冬季传说的文物，肯定的。"
	DESCRIBE.TRAP_POLARTEETH = "这可真是'冷'淡的接待……"
	DESCRIBE.TURF_POLAR_CAVES = "又一种洞穴类型。"
	DESCRIBE.TURF_POLAR_DRYICE = "比这里大多数冰都要坚硬。"
	DESCRIBE.WALL_POLAR = "我在这里感到安全又寒冷。"
	DESCRIBE.WALL_POLAR_ITEM = "它能让我保持'冷'静。"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "这个应该正好能让树更有气氛。"
	DESCRIBE.WX78MODULE_NAUGHTY = "这么多科学知识塞进了一个小玩意儿。"