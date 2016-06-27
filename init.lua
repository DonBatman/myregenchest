
dofile(minetest.get_modpath("myregenchest").."/food_chest.lua")
dofile(minetest.get_modpath("myregenchest").."/tools_chest.lua")
dofile(minetest.get_modpath("myregenchest").."/weapons_chest.lua")

if minetest.get_modpath("3d_armor") then
	dofile(minetest.get_modpath("myregenchest").."/armor_chest.lua")
end

--priv to destroy chest
minetest.register_privilege("myregenchest", {
	description = "Only people with priv can destroy chest",
	give_to_singleplayer = false
})
