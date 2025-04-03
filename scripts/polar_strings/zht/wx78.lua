local ANNOUNCE = STRINGS.CHARACTERS.WX78
local DESCRIBE = STRINGS.CHARACTERS.WX78.DESCRIBE

--	Announcements
	
	--	Actions
	ANNOUNCE.BATTLECRY.POLARBEAR = "去死吧，油膩的肉袋！"
	
	--	World, Events
	ANNOUNCE.ANNOUNCE_POLAR_SLOW = {
		"正在行進中……低效的路徑",
		"我的底盤……不應該……在雪中",
		"為什麼……會有人在……這種爛泥中玩？",
	}
	ANNOUNCE.ANNOUNCE_POLARGLOBE = "錯誤。重啟天氣預報"
	ANNOUNCE.ANNOUNCE_POLARICE_PLOW_BAD = "建議做出更好的決策。"
	ANNOUNCE.ANNOUNCE_THRONE_GIFT_TAKEN = "這些禮物全是我的。哈哈-"
	
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_KRAMPUS = {"一聲嗶聲，一陣嗡鳴，一聲濺落，就足以刪除你", "殲滅完成", "又一個低等生命形式被刪除", "備份這個，肉袋", "你以為你有機會？錯誤數據", "致命錯誤：你存在", "哈哈哈", "哈哈哈哈哈哈哈哈哈-", "我，仁慈的WX-78，已經結束了你可憐的生命", "我只是在預熱我的處理器", "它的系統崩潰了。永久地", "已達到最大靜止狀態", "說「再見，世界」", "弱點無法修補", "威脅等級：零。生存機會：同樣為零", "來試試看，肉類", "升級本地環境。通過移除你", "運行時間已超限。關閉有機單元", "你已被卸載", "你的功能無關緊要", "你的硬件太軟弱", "什麼自然選擇？這是機械選擇"}
	ANNOUNCE.ANNOUNCE_WX_NAUGHTYCHIP_RABBIT = {"洞穴逃生路線未找到", "怯懦的生物不配獲得憐憫", "有機跳躍者已經跳躍到最後", "它們繁殖得很快。我的殺戮也是", "你現在已進入死亡狀態，兔子", "你在食物鏈中的位置是個失敗"}
	
	--	Buffs
	ANNOUNCE.ANNOUNCE_ATTACH_BUFF_POLARWETNESS = "警報：雪中濕度過高"
	ANNOUNCE.ANNOUNCE_DETACH_BUFF_POLARWETNESS = "今天我不會讓你進入我的齒輪！"
	
--	Worldgen
	
	--	Plants
	DESCRIBE.ANTLER_TREE = {
		BURNING = "它燃燒得和其他樹一樣多",
		BURNT = "它燒掉了",
		CHOPPED = "材料已提取",
		GENERIC = "你的角無法拯救你免受我的斧頭",
	}
	DESCRIBE.ICELETTUCE_SEEDS = "這是來自泥土的食物的源代碼"
	
	--	Rocks and stones
	DESCRIBE.POLAR_ICICLE = "檢測到運動"
	DESCRIBE.POLAR_ICICLE_ROCK = "頭部模組的威脅等級 - 高。"
	DESCRIBE.ROCK_POLAR = "掙扎是徒然的，無用物體！"
	
	--	Misc
	ANNOUNCE.DESCRIBE_IN_POLARSNOW = "檢測到物體淹沒"
	DESCRIBE.TUMBLEWEED_POLAR = "掙扎是徒然的，無用物體！"
	
--	Mobs
	
	DESCRIBE.MOOSE_POLAR = {
		GENERIC = "哈哈。白癡。哈哈",
		ANTLER = "令人印象深刻的防禦。真可惜浪費在愚蠢的有機體上",
	}
	DESCRIBE.MOOSE_SPECTER = "你一定會很有價值的，死的時候"
	DESCRIBE.OCEANFISH_MEDIUM_POLAR1 = "比金魚更有價值點"
	DESCRIBE.POLARBEAR = {
		DEAD = "你的滅亡是預期的，肉體",
		ENRAGED = "肉體正在超頻！",
		FOLLOWER = "向我低頭",
		GENERIC = "顯示出中等的智力跡象",
	}
	DESCRIBE.POLARFLEA = {
		GENERIC = "我沒有皮膚給你們吸",
		HELD = "我為什麼要撿起它？",
		HELD_BACKPACK = "恭喜。你現在成為了消耗型盟友。",
	}
	DESCRIBE.POLARFOX = {
		FOLLOWER = "別再跟著我了",
		FRIEND = "又是你",
		GENERIC = "你的可愛無法拯救你",
	}
	DESCRIBE.POLARWARG = "對周圍環境顯示出高度適應性"
	
--	Buildings
	
	DESCRIBE.POLAR_BRAZIER = {
		GENERIC = "長腿是遠離雪地的一種方式",
		ON = "火焰已啟動",
	}
	DESCRIBE.POLAR_BRAZIER_ITEM = "火坑，便攜版"
	DESCRIBE.POLAR_THRONE = "這裡有人覺得自己因為它而高人一等"
	DESCRIBE.POLAR_THRONE_GIFTS = "分析顯示：這是我的"
	DESCRIBE.POLARAMULET_STATION = {
		GENERIC = "崩潰倒數……3……",
		OPEN = "你可以先用你的牙齒開始",
	}
	DESCRIBE.POLARBEARHOUSE = {
		BURNT = "這樣看起來更好",
		GENERIC = "它的大小與其居民不符，違反邏輯",
	}
	DESCRIBE.POLARICE_PLOW = "危險！水即將到來"
	DESCRIBE.POLARICE_PLOW_ITEM = "為魚解凍就是幫它們一個忙"
	
--	Items
	
	--	Food
	DESCRIBE.DRYICECREAM = "無水冰淇淋？小兵，我可能會饒你一命"
	DESCRIBE.ICELETTUCE = "我會踩扁你"
	DESCRIBE.ICEBURRITO = "缺少最重要的成分：豆子。"
	DESCRIBE.POLARCRABLEGS = "已拆解並準備食用"
	
	--	Crafting
	DESCRIBE.BLUEGEM_OVERCHARGED = "這麼……多……01010000 01001111 01010111 01000101 01010010"
	DESCRIBE.BLUEGEM_SHARDS = "微弱的能量訊號。需要組合。"
	DESCRIBE.MOOSE_POLAR_ANTLER = "我要更多"
	DESCRIBE.POLAR_DRYICE = "冰，耗盡所有令人厭惡的水"
	DESCRIBE.POLARBEARFUR = "愚蠢的肉體失去了絕緣"
	DESCRIBE.POLARWARGSTOOTH = "冰冷而致命，像我一樣"

	--	Equipments
	DESCRIBE.ANTLER_TREE_STICK = "你的四肢將為我服務，樹"
	DESCRIBE.ARMORPOLAR = "無法穿透的絨毛"
	DESCRIBE.FROSTWALKERAMULET = "哈哈。讓那愚蠢的水去吧"
	DESCRIBE.ICICLESTAFF = "從上方死亡"
	DESCRIBE.POLAR_SPEAR = "冰冷而致命。完美"
	DESCRIBE.POLARAMULET = "我會製造數百個——不，數千個這樣的東西"
	DESCRIBE.POLARBEARHAT = "提供足夠的眼部保護"
	DESCRIBE.POLARCROWNHAT = "它很好，直到它開始滴水"
	DESCRIBE.POLARFLEA_SACK = "緊急小兵部署器。"
	DESCRIBE.POLARICESTAFF = "讓開，肉袋"
	DESCRIBE.POLARMOOSEHAT = "令人厭惡的頭部絕緣模組"
	
	--	Others
	DESCRIBE.POLARGLOBE = {
		GENERIC = "肉袋如此簡單就能被取悅",
		INUSE = "...為什麼？",
		REFUEL = "需要充電",
	}
	DESCRIBE.OCEANFISH_IN_ICE = "一條特別愚蠢的魚"
	DESCRIBE.POLARICEPACK = "冷卻升級，用於儲存單元"
	DESCRIBE.POLARTRINKET_1 = "可憐的小矮人試圖用石頭來絕緣"
	DESCRIBE.POLARTRINKET_2 = "我反感與它的某種相似之處。"
	DESCRIBE.TRAP_POLARTEETH = "腳部穿刺器 V2.0"
	DESCRIBE.TURF_POLAR_CAVES = "寒冷的地面"
	DESCRIBE.TURF_POLAR_DRYICE = "寒冷的地面"
	DESCRIBE.WALL_POLAR = "足夠的保護"
	DESCRIBE.WALL_POLAR_ITEM = "寒冷的防禦"
	DESCRIBE.WINTER_ORNAMENTPOLAR = "這個特別讓我感到厭惡"
	DESCRIBE.WX78MODULE_NAUGHTY = "為何僅僅刪除肉袋，我還能羞辱它們啊"