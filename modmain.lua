local require = GLOBAL.require


local inits = {
    "init_prefabs",
    "init_assets",
    "init_recipes",
    "init_tuning",
    "init_strings",
}


for _, v in pairs(inits) do
    modimport("init/"..v)
end


