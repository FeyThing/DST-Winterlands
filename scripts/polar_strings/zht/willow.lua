local ANNOUNCE = STRINGS.CHARACTERS.WILLOW
local DESCRIBE = STRINGS.CHARACTERS.WILLOW.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "我要用你的毛皮填滿伯尼！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"呃……為什麼非得是……雪。",
		"把我帶出去！",
		"哼……",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "啊！我已經討厭這裡了！"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "這？就偏偏是在這？"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "這可能更糟糕。"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "啊！把雪弄掉！"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "呃，是有好一點，但還不夠。"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "太棒了！燒啊！",
		BURNT = "然後...啊，沒了。",
		CHOPPED = "我們會再見面的，樹。",
		GENERIC = "你最好好燒一點。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "一些種子。"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "嗯？"
	DESCRIBE.POLAR_ICICLE_ROCK = "啊！我差點被刺穿！"
	DESCRIBE.ROCK_POLAR = "我能感覺到它們散發出的寒冷。"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "別逼我進去。"
	DESCRIBE.TUMBLEWEED_POLAR = "我會抓住你。然後我會融化你！"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "噗，看看誰現在特別愚蠢。",
		ANTLER = "哦太好了，又一隻愚蠢的鹿。",
	}
	DESCRIBE.MOOSE_SPECTER = "我需要更多的標槍。"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "是我把你從這個冰凍的地獄裡救出的，謝謝我吧。"
	DESCRIBE.POLARBEAR = {
		DEAD = "哈，這就是你得到的，熊。",
		ENRAGED = "他火氣真大！",
		FOLLOWER = "現在，你要為我而咬！",
		GENERIC = "哦，你看起來非常易燃。",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "糟糕糟糕！",
		HELD = "呃！把它弄掉！",
		HELD_BACKPACK = "嘿，威爾森！來甩甩我的包！",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "跟我來，你會看到……",
		FRIEND = "我以為我失去你了！",
		GENERIC = "嘿，小家伙！",
	}
	DESCRIBE.POLARWARG = "走開!別把你的跳蚤傳給我。"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "白天可移動。晚上可燃燒！",
		ON = "對！燒吧！再次燃燒！",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "好了，這真是純粹的天才之作！"
	DESCRIBE.POLAR_THRONE = "我知道有個人會浪費時間坐在這裡。實際上，是兩個才對。"
	DESCRIBE.POLAR_THRONE_GIFTS = "沒錯，我懷疑這裡會有我的禮物。"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "將這地方燒掉反而是幫了它一個忙。",
		OPEN = "所以這就是牙仙子看起來的樣子……哦，好吧。",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "哈哈！你的魚屋完全沒有勝算！",
		GENERIC = "呃，這裡聞起來都是魚味。",
	}
	DESCRIBE.POLARICE_PLOW = "我會救你們所有魚！"
	DESCRIBE.POLARICE_PLOW_ITEM = "被困在冰下肯定很糟糕。"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "沃利，聽著。"
	DESCRIBE.ICELETTUCE = "這完全不是好東西。"
	DESCRIBE.ICEBURRITO = "我不認為任何辣醬能讓它好吃一點。"
	DESCRIBE.POLARCRABLEGS = "我從來沒吃過這個，我要吃十個。"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "嘶……離我遠點！！"
	DESCRIBE.BLUEGEM_SHARDS = "可怕的小碎片。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "現在該怎麼處理這根棍子……"
	DESCRIBE.POLAR_DRYICE = "如果它連融化都做不到，那有什麼意義？"
	DESCRIBE.POLARBEARFUR = "它保暖效果很好。"
	DESCRIBE.POLARWARGSTOOTH = "它吃完最後一口後就被凍住了。"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "誰會把這麼好的柴火就這樣丟著？"
	DESCRIBE.ARMORPOLAR = "我永遠不會脫下它！除非它開始發臭。"
	DESCRIBE.FROSTWALKERAMULET = "哇，酷！我的意思是……這真糟糕，但有點酷。"
	DESCRIBE.ICICLESTAFF = "我從未想過我會和冰並肩作戰。"
	DESCRIBE.POLAR_SPEAR = "保持冷靜，如果你必須的話。"
	DESCRIBE.POLARAMULET = "這……只是一個階段。"
	DESCRIBE.POLARBEARHAT = "把這當作不要惹我的暗示。"
	DESCRIBE.POLARCROWNHAT = "哎呀！不行。"
	DESCRIBE.POLARFLEA_SACK = "呃...我們為什麼又要這麼做？"
	DESCRIBE.POLARICESTAFF = "下次我們可以要點別的……\n比如弄到一根煉獄法杖之類的！"
	DESCRIBE.POLARMOOSEHAT = "聞起來有魚腥味。"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "多麼愚蠢的玩具。",
		INUSE = "為什麼你非得搖它，為什麼？",
		REFUEL = "別再回來！",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "我剛好知道有什麼東西適合這魚!"
	DESCRIBE.POLARICEPACK = "就讓它在冰箱裡待著吧，隨便。"
	DESCRIBE.POLARTRINKET_1 = "他看起來也不太喜歡寒冷。"
	DESCRIBE.POLARTRINKET_2 = "她看起來也不太喜歡寒冷。"
	DESCRIBE.TRAP_POLARTEETH = "有火的話會更好。"
	DESCRIBE.TURF_POLAR_CAVES = "這地方又冷又無聊。"
	DESCRIBE.TURF_POLAR_DRYICE = "這地方又冷又無聊。"
	DESCRIBE.WALL_POLAR = "我討厭它。"
	DESCRIBE.WALL_POLAR_ITEM = "也許我會給它一個機會。"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "這不是我會喜歡的那種。"
	DESCRIBE.WX78MODULE_NAUGHTY = "嘿WX，你什麼時候安裝噴火器？"