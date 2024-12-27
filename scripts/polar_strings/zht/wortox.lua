local ANNOUNCE = STRINGS.CHARACTERS.WORTOX
local DESCRIBE = STRINGS.CHARACTERS.WORTOX.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "不管你是哪種熊，我來了！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"跳……我們出發了……！",
		"哼……哼……哇哇哇！",
		"動起來……這頑固的蹄子……",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "你叫這個惡作劇？那只是粗魯！"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "我，我的天啊，我必須保持溫暖和乾燥……"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "不再有雪了！可以出發了！"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "你看到了嗎？我打賭你沒看到！",
		BURNT = "變得又詭異又脆脆的。",
		CHOPPED = "倒下了，安息在雪中。",
		GENERIC = "你可能有更長的角，但我有把斧頭。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "讓我們給它一些土壤，在它壞掉前。"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "我發誓它抖了一下！還是我被欺騙了？"
	DESCRIBE.POLAR_ICICLE_ROCK = "你應該早點或晚點抓住機會。"
	DESCRIBE.ROCK_POLAR = "我在寒冷的霧氣下看到的那些是寶石嗎？"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "哼哼！那會是什麼呢？"
	DESCRIBE.TUMBLEWEED_POLAR = "一片有趣的冰霜雪花！"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "別擔心，親愛的，它們會再長回來的。",
		ANTLER = "你的角有多大啊！我可以要它們嗎？",
	}
	DESCRIBE.MOOSE_SPECTER = "大多數凡人可沒機會見到小惡魔，你可得記得這點。"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "來自深邃冰冷水域的彩虹泳者。"
	DESCRIBE.POLARBEAR = {
		DEAD = "回到塵埃中！或者雪中，如果你願意。",
		ENRAGED = "他們可不喜歡惡作劇！",
		FOLLOWER = "我們都是熊孩子呢，哼哼！",
		--There’s a pun here with the word "bearable," which is used to describe something difficult to endure and contains the root word "bear." 
		--I translated this sentence as "We are all 熊孩子(bear children)." 
		--In Chinese, "熊孩子" refers to rude, impolite children, so this creates a pun effect.
		GENERIC = "他們對我的種族似乎很友好。",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "哦不！不不不！",
		HELD = "没關係，我很快就會反過來吞噬你。",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "一個狡猾的小夥伴。",
		FRIEND = "你不記得我了嗎？哦，你看起來很餓……",
		GENERIC = "在它把自己埋在六蹄子深的地方前抓住牠!",
	}
	DESCRIBE.POLARWARG = "牠發出了凍人的叫聲！"
	
--	Buildings
	
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "毫無疑問，這裡充滿了惡作劇！",
		OPEN = "哦，我的朋友，你的微笑真狡猾！",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "即使是這個冰冷的巢穴也無法逃脫被火舌吞噬的結局。",
		GENERIC = "一個能溫暖靈魂的藏身之處。",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "凡人會培養植物，無論它們會長成多麼卑鄙的樣子。"
	DESCRIBE.ICEBURRITO = "我想我會咬一口。凍傷一口，哼哼！"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "無論是在空氣中或在寶石中，你的靈魂仍然會是我的。"
	DESCRIBE.BLUEGEM_SHARDS = "哎呀！我又把它弄壞了。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "那可真可惜，對你來說！"
	DESCRIBE.POLAR_DRYICE = "冷得不能再冷，但很適合我。"
	DESCRIBE.POLARBEARFUR = "厚厚的毛皮，適合在雪中嬉戲。"
	DESCRIBE.POLARWARGSTOOTH = "我承認，這個可能是一個值得的對手。"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "這根棍子能完成工作。"
	DESCRIBE.FROSTWALKERAMULET = "當水變冷時，新的道路會展開。"
	DESCRIBE.ICICLESTAFF = "小心！這尖刺可是會在你身上留下調皮導致的痕跡。"
	DESCRIBE.POLAR_SPEAR = "冰和棍子是天生一對。"
	DESCRIBE.POLARAMULET = "重要的是你了相信它，哼哼！"
	DESCRIBE.POLARCROWNHAT = "外冷，內凍。"
	DESCRIBE.POLARICESTAFF = "把我們的客人困在冰中可不太好！"
	DESCRIBE.POLARMOOSEHAT = "一個毛茸茸的王冠，用來隱藏著冰冷的皺眉。"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "一個冰凍的領域，等待著搖晃！哼哼！",
		INUSE = "多麼誘人的詛咒小玩意！",
		REFUEL = "它是空的……這並不讓我不高興。",
	}
	DESCRIBE.POLARICEPACK = "我必須為凡人的食物犧牲空間嗎？"
	DESCRIBE.POLARTRINKET_1 = "裡面沒有靈魂，沒有沒有。"
	DESCRIBE.POLARTRINKET_2 = "裡面沒有靈魂，沒有沒有。"
	DESCRIBE.TRAP_POLARTEETH = "殘酷？也許。好玩？當然！"
	DESCRIBE.TURF_POLAR_CAVES = "地板或天花板，取決於你的視角。"
	DESCRIBE.TURF_POLAR_DRYICE = "地板或天花板，取決於你的視角。"
	DESCRIBE.WALL_POLAR = "它是把冷氣擋在外面，還是擋在裡面？"
	DESCRIBE.WALL_POLAR_ITEM = "把它丟在地上是沒有用的。"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "真是大膽的一天，對吧？"