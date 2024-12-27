local ANNOUNCE = STRINGS.CHARACTERS.WANDA
local DESCRIBE = STRINGS.CHARACTERS.WANDA.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "你的時間到了，野獸！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"快點……快點……！",
		"這要……永恆嗎……",
		"嗚嗚……",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "啊！末日來臨了——……是嗎？"
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "哦，真麻煩！我沒有準備好。"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "我們不要再浪費時間在這裡了。"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "我可以停下來暖和一下……",
		BURNT = "我想這是值得的。",
		CHOPPED = "這遲早會發生的。",
		GENERIC = "看起來它凍結在時間裡。",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "我現在就可以吃掉它，為什麼要浪費時間種它？"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "儘量延遲不可避免的事情。"
	DESCRIBE.POLAR_ICICLE_ROCK = "無論如何，我覺得這挺……詩意的。"
	DESCRIBE.ROCK_POLAR = "我懷疑它會不會很快變回水。"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "這是某種東西……"
	DESCRIBE.TUMBLEWEED_POLAR = "我沒有時間去追逐雪花。"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "那麼，這是否意味著你贏了？",
		ANTLER = "牠可能比其他的更堅持立場。",
	}
	DESCRIBE.MOOSE_SPECTER = "你也太晚才出現了！"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "光芒四射，但缺乏隱匿感。"
	DESCRIBE.POLARBEAR = {
		DEAD = "至少他會在這裡被很好地保存。",
		ENRAGED = "你想看看我失去冷靜的樣子嗎？！",
		FOLLOWER = "這顏色是永久的嗎？還是你每天需要花時間去塗？",
		GENERIC = "我只是路過，別介意我。",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "啊！滾開！",
		HELD = "這很痛，但移除它會更痛。",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "現在我抓到你了……嗯。我不知道我到底要做什麼！",
		FRIEND = "我們在這個時間線中見過面，對吧？",
		GENERIC = "哦，是你！這次你逃不掉了！",
	}
	DESCRIBE.POLARWARG = "這隻怪物在這裡徘徊了多久？"
	
--	Buildings
	
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "為什麼會有人想住在這裡呢？",
		OPEN = "隨你所願，但我喜歡我的工作室別這麼……陰暗。",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "燒了卻還是冷的。",
		GENERIC = "非常老套，就像我住在一座鐘樓裡。不，等等……我不吃鐘！",
	}
	
--	Items
	
	--	Food
	DESCRIBE.ICELETTUCE = "我需要等待然後……喝它……?還是？"
	DESCRIBE.ICEBURRITO = "我還在弄清這該怎麼吃。"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "為什麼我覺得它隨時會爆炸？"
	DESCRIBE.BLUEGEM_SHARDS = "我更喜歡用小塊的來工作。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "這最好要值得。"
	DESCRIBE.POLAR_DRYICE = "那我可以用這個做什麼？"
	DESCRIBE.POLARBEARFUR = "這就像抱著溫暖的雪一樣。"
	DESCRIBE.POLARWARGSTOOTH = "即使我試了，也無法讓一塊燧石比這更鋒利！"
	
	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "哦，這正是我需要的！"
	DESCRIBE.FROSTWALKERAMULET = "好！我已經受夠這些該死的河流了。"
	DESCRIBE.ICICLESTAFF = "小心友軍傷害……和那些'親切'的冰。所有元素都想讓我們死！"
	DESCRIBE.POLAR_SPEAR = "趁它還新鮮的時候好好利用。"
	DESCRIBE.POLARAMULET = "我已經經歷過那個階段了。我有吧？"
	DESCRIBE.POLARCROWNHAT = "我開始覺得這是值得的。"
	DESCRIBE.POLARICESTAFF = "所有人，意思是每一個'人'都應該休息一下。"
	DESCRIBE.POLARMOOSEHAT = "我只希望我不會被誤認為是一塊會走路的肉排……"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "我沒有時間一直盯著這個看。",
		INUSE = "其實……我可能有時間來看看這個。",
		REFUEL = "這裡面有漏水嗎？",
	}
	DESCRIBE.POLARICEPACK = "我接下來應該拿一個時光包裹。"
	DESCRIBE.POLARTRINKET_1 = "哦，我真的喜歡這個節日的小玩意。"
	DESCRIBE.POLARTRINKET_2 = "哦，我真的喜歡這個節日的小玩意。"
	DESCRIBE.TRAP_POLARTEETH = "我不知道有什麼比被困在這裡更糟糕的事情。"
	DESCRIBE.TURF_POLAR_CAVES = "我為什麼要浪費時間盯著地面？"
	DESCRIBE.TURF_POLAR_DRYICE = "這到底是通往哪裡的路？"
	DESCRIBE.WALL_POLAR = "我可不想打它。"
	DESCRIBE.WALL_POLAR_ITEM = "這不應該很快融化。"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "看起來如此逼真，我敢打賭它會融化得……非常……快……"