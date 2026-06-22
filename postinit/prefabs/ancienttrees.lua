local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local TREE_DEFS = require("prefabs/ancienttree_defs").TREE_DEFS
--local PLANT_DATA = require("prefabs/ancienttree_defs").PLANT_DATA

if TREE_DEFS.nightvision and TREE_DEFS.nightvision.GROW_CONSTRAINT and TREE_DEFS.nightvision.GROW_CONSTRAINT.TILE then
	TREE_DEFS.nightvision.GROW_CONSTRAINT.TILE[WORLD_TILES.POLAR_SNOW] = true -- They like winter, don't they ?
end