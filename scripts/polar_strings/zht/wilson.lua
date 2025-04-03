local ANNOUNCE = STRINGS.CHARACTERS.GENERIC
local DESCRIBE = STRINGS.CHARACTERS.GENERIC.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "這可能熊熊有問題。"
	--This was originally a pun where "bear" simultaneously referred to "bear" (noun, the animal) and "bear" (verb, meaning to produce or endure). 
	--To preserve the pun in Chinese, I adapted it to "熊熊" (an adjective meaning "very sudden"). 
	--The phrase "熊熊有" can imply a very sudden appearance while also referencing the presence of a bear (noun, the animal).
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"相信我……這是一條……捷徑。",
		"嗯……",
		"哈……",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "震動和顫抖——剛剛發生了什麼？！"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "在這冰行不通，換個地方吧。"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "嗯。沒有那麼糟糕嘛。"
	
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {"only_used_by_wx78"}
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {"only_used_by_wx78"}
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "哇！這可不是開玩笑！"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "我乾了，但只是雪的問題。"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "誰會拒絕火呢。",
		BURNT = "這與周圍的環境形成了強烈對比。",
		CHOPPED = "最好在其他樹木注意到之前快點溜走。",
		GENERIC = "這棵樹在挑釁我。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "這是一顆什麼東西的種子。"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "剛才它動了嗎？"
	DESCRIBE.POLAR_ICICLE_ROCK = "是的，它肯定動了。"
	DESCRIBE.ROCK_POLAR = "新鮮的寶石等待收穫。"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "我想我在這裡看到了什麼。"
	DESCRIBE.TUMBLEWEED_POLAR = "這不科學。"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "失去了角，牠一定很難受。",
		ANTLER = "我最好遠離牠的路徑。",
	}
	DESCRIBE.MOOSE_SPECTER = "看來當地的傳說是真的。"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "那些眼睛值一大筆錢！"
	DESCRIBE.POLARBEAR = {
		DEAD = "一堆雪……不，等等。",
		ENRAGED = "他叫得多大聲咬合力就有多強！",
		FOLLOWER = "這是我的熊麻吉。",
		GENERIC = "一個可怕又可愛的家伙。",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "該逃囉！",
		HELD = "它的下顎已經深入我的皮膚了。",
		HELD_BACKPACK = "我對這個想法充滿信心，它一定會成功。",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "來玩個小遊戲吧。",
		FRIEND = "他有一張熟悉的面孔。看起來我也是。",
		GENERIC = "啊哈！過來！",
	}
	DESCRIBE.POLARWARG = "有了這樣的毛皮，寒冷一定不算什麼。"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "一個口袋大小的火坑。",
		ON = "現在太熱了不能放進口袋裡。除非我熄滅火焰。",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "科學表明，便攜式的東西總是更好的。"
	DESCRIBE.POLAR_THRONE = "看起來很舒適。"
	DESCRIBE.POLAR_THRONE_GIFTS = "那是我的名字嗎？我看不清那爪子寫的字。"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "這個小屋怎麼還不倒真是個謎。",
		OPEN = "呃，我的錯。錯誤的地址。",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "我的魚啊！",
		GENERIC = "我懷疑在裡面也不會比較暖和。",
	}
	DESCRIBE.POLARICE_PLOW = "我對下面有什麼東西非常好奇。"
	DESCRIBE.POLARICE_PLOW_ITEM = "最好的魚總是藏起來的那條。"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "二氧化碳的風味，難以超越。"
	DESCRIBE.ICELETTUCE = "這調味有點太過頭了。"
	DESCRIBE.ICEBURRITO = "我真喜歡這個名字。"
	DESCRIBE.POLARCRABLEGS = "有十條腿的好處是，每個人都有份。"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "我收回之前的話。這個閃耀著寒冷的能量！"
	DESCRIBE.BLUEGEM_SHARDS = "一個礦物學的謎題。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "這東西真重！"
	DESCRIBE.POLAR_DRYICE = "我可以用這個建造一些非~常酷的東西。"
	DESCRIBE.POLARBEARFUR = "真舒適，它很毛暖。"
	DESCRIBE.POLARWARGSTOOTH = "它更鋒利了！"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "科學能夠解釋為什麼這根棍子是完美的。"
	DESCRIBE.ARMORPOLAR = "就是這個東西！"
	DESCRIBE.FROSTWALKERAMULET = "科學知道該如何解釋這個現象……但我不知道。"
	DESCRIBE.ICICLESTAFF = "非常有用，前提是別提那次「事故」。"
	DESCRIBE.POLAR_SPEAR = "那是一根大冰棒！"
	DESCRIBE.POLARAMULET = "它在做……某件事情，肯定的。"
	DESCRIBE.POLARBEARHAT = "被吃掉也有意想不到的優點呢。"
	DESCRIBE.POLARCROWNHAT = "那麼，什麼能保護我不腦凍呢？"
	DESCRIBE.POLARFLEA_SACK = "用來裝那些咬人的小盟友。"
	DESCRIBE.POLARICESTAFF = "我喜歡我所有的法杖，但這根是最冷的。"
	DESCRIBE.POLARMOOSEHAT = "相當有藝術感的頭飾。"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "它還在動。",
		INUSE = "我們不要再這樣了！",
		REFUEL = "雪去哪裡了？",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "那是一個魚冰塊。"
	DESCRIBE.POLARICEPACK = "遺憾的是，這對保存我的狀態沒什麼幫助。"
	DESCRIBE.POLARTRINKET_1 = "一個浸透了冬季傳說的文物，肯定的。"
	DESCRIBE.POLARTRINKET_2 = "一個浸透了冬季傳說的文物，肯定的。"
	DESCRIBE.TRAP_POLARTEETH = "這可真是'冷'淡的接待……"
	DESCRIBE.TURF_POLAR_CAVES = "又一種洞穴類型。"
	DESCRIBE.TURF_POLAR_DRYICE = "比這裡大多數冰都要堅硬。"
	DESCRIBE.WALL_POLAR = "我在這裡感到安全又寒冷。"
	DESCRIBE.WALL_POLAR_ITEM = "它能讓我保持'冷'靜。"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "這個應該正好能讓樹更有氣氛。"
	DESCRIBE.WX78MODULE_NAUGHTY = "這麼多科學知識塞進了一個小玩意兒。"