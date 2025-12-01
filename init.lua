
dofile(core.get_modpath("myregenchest").."/food_chest.lua")
dofile(core.get_modpath("myregenchest").."/tools_chest.lua")
dofile(core.get_modpath("myregenchest").."/weapons_chest.lua")

if core.get_modpath("3d_armor") then
	dofile(core.get_modpath("myregenchest").."/armor_chest.lua")
end

--priv to destroy chest
core.register_privilege("myregenchest", {
	description = "Only people with priv can destroy chest",
	give_to_singleplayer = true
})
