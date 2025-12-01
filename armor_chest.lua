local time_between_regen = tonumber(core.settings:get("myregenchest.armor_time")) or 300

local items = { --the number is the chance of spawning. 1 means everytime. 3 means 1 in3 chance of spawning
	{5,		"3d_armor:helmet_wood"},
	{5,		"3d_armor:chestplate_wood"},
	{5,		"3d_armor:leggings_wood"},
	{5,		"3d_armor:boots_wood"},
	{500,	"3d_armor:chestplate_diamond"},
	}

local item_spawn = function(pos, node)

	for i in ipairs(items)do
		local r = items[i][1]
		local i = items[i][2]
		local rand = math.random(r)
			if rand == 1 then core.spawn_item({x=pos.x,y=pos.y+0.5,z=pos.z}, i) end
	end

	core.set_node(pos, {name="myregenchest:armor_chest_open", param2=node.param2})

	local timer = core.get_node_timer(pos)
		timer:start(time_between_regen)
		core.swap_node(pos, {name="myregenchest:armor_chest_open", param2=node.param2})
end

local check_air = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing.above
			local nodea = core.get_node({x=pos.x,y=pos.y+1,z=pos.z})
				if nodea.name ~= "air" then
				core.chat_send_player( placer:get_player_name(), "Need room above chest" )
				return
				end
			return core.item_place(itemstack, placer, pointed_thing)
			end

local dig_it = function(pos, node, digger)
		if core.get_player_privs(digger:get_player_name()).myregenchest ~= true then
			core.chat_send_player( digger:get_player_name(), "You do not have the privelege to remove the chest" )
			else core.remove_node(pos,node)
		end
	end



local closed_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3125, 0.5, 0.3125, 0.375},
		}
	}

local open_box = {
		type = "fixed",
		fixed = {
			{-0.5, 		-0.5, 		-0.3125,	 0.5, 	-0.1875,	 0.375},
			{-0.5, 		-0.5, 		 0.3125,	 0.5, 	 0.1875,	 0.375},
			{-0.5, 		-0.5, 		-0.3125,	-0.4375, 0.1875,	 0.375},
			{0.4375, 	-0.5, 		-0.3125,	 0.5,	 0.1875,	 0.375},
			{-0.5, 		-0.5, 		-0.3125,	 0.5,	 0.1875,	-0.25},
			{-0.5, 		 0.1875,	 0.4375,	 0.5,	 0.875,		 0.5},
			{-0.5, 		 0.1875,	 0.375, 	 0.5, 	 0.25,		 0.5},
			{-0.5, 		 0.8125,	 0.375, 	 0.5, 	 0.875,		 0.5},
			{-0.5, 		 0.1875,	 0.375, 	-0.4375, 0.875,		 0.5},
			{0.4375, 	 0.1875,	 0.375, 	 0.5,	 0.875,		 0.5},
		}
	}

core.register_node("myregenchest:armor_chest", {
	description = "Armor Chest",
	tiles = {
		"myitemchest_chest_top.png",
		"myitemchest_chest_top.png",
		"myitemchest_chest_side.png^[transformFX",
		"myitemchest_chest_side.png",
		"myitemchest_chest_back.png",
		"myitemchest_chest_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy = 2},
	sounds = default.node_sound_wood_defaults(),
	node_box = closed_box,
	selection_box = closed_box,
	on_place = check_air,
	on_rightclick = item_spawn,
	on_dig = dig_it,
})



core.register_node("myregenchest:armor_chest_open", {
	description = "Armor Chest Open",
	tiles = {
		"myitemchest_chest_open_top.png",
		"myitemchest_chest_open_top.png",
		"myitemchest_chest_side.png^[transformFx",
		"myitemchest_chest_side.png",
		"myitemchest_chest_back.png",
		"myitemchest_chest_front_open.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "myregenchest:armor_chest",
	groups = {not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	node_box = open_box,
	selection_box = open_box,
	on_timer = function(pos, elapsed)
	local timer = core.get_node_timer(pos)
	local node = core.get_node(pos)
	core.swap_node(pos, {name = "myregenchest:armor_chest", param2=node.param2})
	
	local all_objects = core.get_objects_inside_radius(pos, 0.5)
	local players = {}
	local _,obj
		for _,obj in ipairs(all_objects) do
			if obj:is_player() == false then
				obj:remove() 
			end
		end
	end,
})

