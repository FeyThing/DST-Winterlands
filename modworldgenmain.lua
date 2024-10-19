local ENV = env
GLOBAL.setfenv(1, GLOBAL)


local modimport = ENV.modimport
--local GetModConfigData = ENV.GetModConfigData

modimport("init/init_tiles")

modimport("init/init_worldgen")