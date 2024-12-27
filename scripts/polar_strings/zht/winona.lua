local ANNOUNCE = STRINGS.CHARACTERS.WINONA
local DESCRIBE = STRINGS.CHARACTERS.WINONA.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "來吧，揮舞你的爪子！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"停不下來……不會停下來……好吧，停下來了。",
		"我不會放慢速度……我只是在調整步伐……",
		"呼……我需要在外面喘口氣！",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "呼！結束了。而且……在下雪？"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "哎呀！我穿得不夠多！"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "現在要經歷一番折磨了……"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "燒吧，小樹，燒吧！",
		BURNT = "它在雪中撒下了灰燼。",
		CHOPPED = "只是雷聲大雨點小…你懂的。",
		GENERIC = "看起來很尖，但我有更尖的。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "我不知道它會長成什麼。"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "對了。我的安全帽！"
	DESCRIBE.POLAR_ICICLE_ROCK = "希望做這些我能拿到點危險津貼。"
	DESCRIBE.ROCK_POLAR = "那我就不客氣了。"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "裡面有什麼，誰也不知道。"
	DESCRIBE.TUMBLEWEED_POLAR = "他們說每一個都是獨一無二的，裡外皆然。"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "直接撞上麻煩了，嗯？",
		ANTLER = "看起來很強。是時候看看它是否真的如此了。",
	}
	DESCRIBE.MOOSE_SPECTER = "我現在只是想觀察觀察它。"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "有點太浮誇了，不太合我胃口，但還是可以接受。"
	DESCRIBE.POLARBEAR = {
		DEAD = "徹底倒下了！",
		ENRAGED = "哎呀，我們有熊的麻煩了！",
		FOLLOWER = "那麼，你最喜歡的魚是什麼？",
		GENERIC = "別對我那麼冷淡。"
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "我知道我最好離牠們遠點。",
		HELD = "哎呀！走開！",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "你給我兔子，我給你晚餐，很簡單吧。",
		FRIEND = "我是不是忘了我們的小約定？",
		GENERIC = "過來這裡，你這小調皮！",
	}
	DESCRIBE.POLARWARG = "我相信牠嘴裡一定是薄荷味的是不。"
	
--	Buildings
	
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "站外面都待比在這破房子裡面好。",
		OPEN = "夥計，你聽說過適當的照明嗎？這裡太陰森了。",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "嗯。可能又是一場野火。",
		GENERIC = "這地方聞起來有夠可疑。",
		--I know that 'fishy' has a double meaning, referring to both 'suspicious' and 'fish,' 
		--but I couldn't think of a suitable expression in Chinese, 
		--so I only translated the 'suspicious' meaning."
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "這是用薄荷來冷凍？它就像是被冷凍了一樣！"
	DESCRIBE.ICEBURRITO = "這捲正適合用來結束這好捲的一天。"
	--Great, my brain cells are almost filled up with puns.
	--This food is '捲 wrapped' up, and to make it a pun.
	--So I translated it as: 'End this "好捲" of a day with this wrap.'
    --'好捲' in Chinese means that during a competition, both sides become more and more exhausted from each other."
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "我可不敢沒戴手套碰這個。"
	DESCRIBE.BLUEGEM_SHARDS = "我敢說這冷到能直接黏回去。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "你打得不錯，小夥子。"
	DESCRIBE.POLAR_DRYICE = "這能送上流'冰'線。"
	--This can't be translated into Chinese with a homophone pun, 
	--so I chose a similar word pun instead, not a typo.
	--It should originally be 流'水'線(assembly line).
	DESCRIBE.POLARBEARFUR = "它很溫暖，更重要的是，它是我的。"
	DESCRIBE.POLARWARGSTOOTH = "我猜你這不是用來吃植物的對吧。"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "這可能會派上用場。"
	DESCRIBE.FROSTWALKERAMULET = "這樣我就不會在工作時滑倒了，哈！"
	DESCRIBE.ICICLESTAFF = "在用這個時我可不會忽視風往哪吹。"
	DESCRIBE.POLAR_SPEAR = "噗。好吧。假設你住在冷凍庫裡..."
	DESCRIBE.POLARAMULET = "它說這些都是獨一無二什麼的。"
	DESCRIBE.POLARCROWNHAT = "如果不會出汗，就不會被看出我捏了把冷汗。"
	--n order to create a pun with synonyms, I slightly adjusted the meaning here. 
	--In Chinese, "捏了一把冷汗(Break into a cold sweat.)" is used to describe a situation of extreme nervousness.
	DESCRIBE.POLARICESTAFF = "用冰凍來達成你的目的吧。"
	DESCRIBE.POLARMOOSEHAT = "嘿，伍迪。你的尾巴毛還在嗎？"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "哈！查理會喜歡這些小東西。",
		INUSE = "哦，你……",
		REFUEL = "不確定怎麼漏的。不過這樣也好。",
	}
	DESCRIBE.POLARICEPACK = "那一小塊冰的效果可大了。"
	DESCRIBE.POLARTRINKET_1 = "你那條圍巾不錯。真希望我也有一條。"
	DESCRIBE.POLARTRINKET_2 = "呃，看起來他們兩條生產線混亂了。"
	DESCRIBE.TRAP_POLARTEETH = "殘酷但聰明。"
	DESCRIBE.TURF_POLAR_CAVES = "那是一塊地面。"
	DESCRIBE.TURF_POLAR_DRYICE = "那是一塊路面。"
	DESCRIBE.WALL_POLAR = "是的，這真冰。"
	DESCRIBE.WALL_POLAR_ITEM = "組裝時間。"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "沒有什麼比這更能代表冬天了。"