local ANNOUNCE = STRINGS.CHARACTERS.WALTER
local DESCRIBE = STRINGS.CHARACTERS.WALTER.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "小心沃比！我在和一隻又大又可怕的熊戰鬥！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"沃比！你在哪裡——啊，你在這裡！",
		"我們應該往北走……不，往南！",
		"哇……",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "那真是……酷！甚至有點冷！"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "讓我們試試更穩固的地方。"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "不錯！差不多是我想要的。"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "我..我需要更厚的衣物……！"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "至少我的毛髮已經解凍了。"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "一棵著火的樹？在這裡？在所有地方？",
		BURNT = "嗯。我很想知道這是怎麼發生的。",
		CHOPPED = "斧頭贏了這場戰鬥。",
		GENERIC = "這個幽魂……啊，這是一棵樹。不過還是很酷。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "我們應該把它種在哪裡，沃比？"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "我想知道它什麼時候會掉下來。"
	DESCRIBE.POLAR_ICICLE_ROCK = "哇！你看到它掉下來了嗎？"
	DESCRIBE.ROCK_POLAR = "看看裡面有多少沃比！"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "嗯？沃比……這裡面有什麼？"
	DESCRIBE.TUMBLEWEED_POLAR = "可怕的雪花！我終於找到了它！"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "它是怎麼失去角的？這真是一個悲劇的故事。",
		ANTLER = "嗯。看起來不太神秘！但也許如果它是白色的，藏在暴風雪中……",
	}
	DESCRIBE.MOOSE_SPECTER = "我知道！我知道……一直以來！哈哈！"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "嘿，看看那些可怕的眼睛！"
	DESCRIBE.POLARBEAR = {
		DEAD = "先生？先生，我想你需要我們的幫助！",
		ENRAGED = "你有多大的牙齒！",
		FOLLOWER = "你比他們在廣播節目中說的更容易馴服。",
		GENERIC = "我是對的。那三個黑點，實際上，這是一隻北極熊。"
		--Generally, POLARBEAR is translated as "北極熊",so if the character is from the real world, they would be referred to as a '北極熊' rather than an '極地熊' which doesn't specifically refer to a bear from the Arctic.
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "看看這個——呃，這些酷蟲蟲！",
		HELD = "我的手冊說……現在想把它移除已經太晚了。",
		HELD_BACKPACK = "沒有什麼能阻止我和我的蟲子們！",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "我想他喜歡我們！",
		FRIEND = "他可以再吃點零食。",
		GENERIC = "去吧，女孩！",
	}
	DESCRIBE.POLARWARG = "可憐的東西一定迷路了。"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "一個可攜式的火坑。",
		ON = "呃...有人帶便攜式棉花糖袋嗎？",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "總有一天沃比，你會搬運整個基地！"
	DESCRIBE.POLAR_THRONE = "你不覺得過一陣子就會感到無聊嗎，麥斯威爾先生？"
	DESCRIBE.POLAR_THRONE_GIFTS = "東西可能不見了。"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "哦，這一定是我聽說過的牙科博物館！",
		OPEN = "嗨！你們對訪客開放嗎？",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "那是一種我見過的'霜烤'。呵呵。",
		GENERIC = "你覺得他們會用雪做家具嗎？",
	}
	DESCRIBE.POLARICE_PLOW = "別擔心，我知道該怎麼做。"
	DESCRIBE.POLARICE_PLOW_ITEM = "也許沃比能用氣味找到魚？"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "冰淇淋，氣泡水版本。"
	DESCRIBE.ICELETTUCE = "這會讓萵苣結凍嗎？你明白嗎？因為……算了……"
	DESCRIBE.ICEBURRITO = "它一點都不會散開。"
	DESCRIBE.POLARCRABLEGS = "嗯！嘿，有人想聽我的螃蟹恐怖故事嗎？"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "從一顆魔法藍寶石到……我不知道……一顆被詛咒的藍寶石？"
	DESCRIBE.BLUEGEM_SHARDS = "我敢打賭我可以拼湊出這個謎團。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "這不必發展成這樣。"
	DESCRIBE.POLAR_DRYICE = "讓我們建造一個雪人！"
	DESCRIBE.POLARBEARFUR = "哇，看看裡面有多少跳蚤！"
	DESCRIBE.POLARWARGSTOOTH = "提醒我，我得快點給你刷牙了，女孩。"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "一根好棍子，可以用來玩接球和……其他幾件事。"
	DESCRIBE.ARMORPOLAR = "護甲也可以防護其他東西，對吧？"
	DESCRIBE.FROSTWALKERAMULET = "哦，呃……我也許應該用它做一個狗項圈。"
	DESCRIBE.ICICLESTAFF = "我們拿來射射看吧？呵呵。好主意，沃爾特。"
	DESCRIBE.POLAR_SPEAR = "抱歉沃比，你不能擁有這個。"
	DESCRIBE.POLARCROWNHAT = "那麼，我們什麼時候建造我的冰城堡？"
	DESCRIBE.POLARFLEA_SACK = "最好小心點，你正在我口袋蟲子的攻擊範圍內。"
	DESCRIBE.POLARAMULET = "來自紀念品商店的小東西。"
	DESCRIBE.POLARBEARHAT = "沃比一直在對它咆哮..."
	DESCRIBE.POLARICESTAFF = "我為所有在這裡的昆蟲感到抱歉，它們只是忙著自己的事。"
	DESCRIBE.POLARMOOSEHAT = "毫無疑問是駝鹿毛。你聞到了嗎？"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "嘿，搖一搖！",
		INUSE = "這意味著……我手上有個個鬧鬼的飾品！",
		REFUEL = "雪在哪裡……鬧鬼的雪？",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "搞不好裡面藏著一隻迷你長毛象？"
	DESCRIBE.POLARICEPACK = "這不會讓我的肉乾永不腐爛，但至少更近了一步。"
	DESCRIBE.POLARTRINKET_1 = "他似乎準備好來打雪仗了。我也準備好了！"
	DESCRIBE.POLARTRINKET_2 = "等等……我認得你。"
	DESCRIBE.TRAP_POLARTEETH = "如果這個不能抓到海狸人，我就放棄！"
	DESCRIBE.TURF_POLAR_CAVES = "一片小天地。"
	DESCRIBE.TURF_POLAR_DRYICE = "一條讓我腿上發抖的道路。"
	DESCRIBE.WALL_POLAR = "這霧氣營造出一種很棒的陰森氛圍。"
	DESCRIBE.WALL_POLAR_ITEM = "你別給我舔它，沃比！"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "好吧，這很符合季節。"