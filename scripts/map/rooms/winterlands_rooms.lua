	AddRoom("BG Icy Fields",  {
		colour={r=0.3,g=0.2,b=0.1,a=0.3},
		value = WORLD_TILES.ICEFIELD_NOISE,
		contents = {
			{
			},
			distributepercent = 0.12,
			distributeprefabs =
			{
				marsh_tree = 1,
				marsh_bush = 0.66,	
			},
		}
	})
	
	AddRoom("BG Tundra",  {
		colour={r=0.3,g=0.2,b=0.1,a=0.3},
		value = WORLD_TILES.ICETUNDRA_NOISE,
		contents = {
			{
			},
			distributepercent = 0.1,
			distributeprefabs =
			{
				marsh_tree = 1,
				marsh_bush = 0.66,	
			},
		}
	})

	AddRoom("Icy Fields",  {
		colour={r=0.3,g=0.2,b=0.1,a=0.3},
		value = WORLD_TILES.ICEFIELD_NOISE,
		contents = {
			{
			},
			countprefabs= {
			},
			distributepercent = 0.25,
			distributeprefabs =
			{
				marsh_tree = 1,
				marsh_bush = 0.66,	
			},
		},
		
	})
	
AddRoom("Tundra",  {
		colour={r=0.3,g=0.2,b=0.1,a=0.3},
		value = WORLD_TILES.ICETUNDRA_NOISE,
		contents = {
			countstaticlayouts =
			{
			},
			distributepercent = 0.07,
			distributeprefabs =
			{								
				marsh_tree = 0.1,
				marsh_bush = 0.66,
				rock1 = 1,
			},
		},
		
	})
	
	AddRoom("Icy Pillars",  {
		colour={r=0.3,g=0.2,b=0.1,a=0.3},
		value = WORLD_TILES.ICECAVE_NOISE,
		contents = {
			countstaticlayouts =
			{
			},
			countprefabs= {
			},
			distributepercent = 0.15,
			distributeprefabs =
			{
				rock1 = 0.66,	
				ice_cavepillar = 1,
				
			},
		},
		
	})
	
	AddRoom("Cold Wastes",  {
		colour={r=0.3,g=0.2,b=0.1,a=0.3},
		value = WORLD_TILES.ICEWASTE,
		contents = {			
			countstaticlayouts =
			{
			},
			distributepercent = 0.15,
			distributeprefabs =
			{
				marsh_tree = .1,
				marsh_bush = 0.66,
				rock_ice = .3,
	
			},
		},
		
	})	