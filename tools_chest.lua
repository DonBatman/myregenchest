local time_between_regen = tonumber(core.settings:get("myregenchest.tool_time")) or 120

--local time_between_regen = 120 --time in seconds between the time the chest is opened and when it closes to be used again


local items = { --the number is the chance of spawning. 1 means everytime. 3 means 1 in3 chance of spawning
	{1,		"default:axe_wood"},
	{3,		"default:pick_wood"},
	{1,		"default:sword_wood"},
	{10,	"default:shovel_wood"},
	{100, 	"default:axe_steel"},
	}




local item_spawn = function(pos, node)

	for i in ipairs(items)do
		local r = items[i][1]
		local i = items[i][2]
		local rand = math.random(r)
			if rand == 1 then minetest.spawn_item({x=pos.x,y=pos.y+0.5,z=pos.z}, i) end
	end

	minetest.set_node(pos, {name="myregenchest:tools_chest_open", param2=node.param2})

	local timer = minetest.get_node_timer(pos)
		timer:start(time_between_regen)
		minetest.swap_node(pos, {name="myregenchest:tools_chest_open", param2=node.param2})
end

local check_air = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing.above
			local nodea = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z})
				if nodea.name ~= "air" then
				minetest.chat_send_player( placer:get_player_name(), "Need room above chest" )
				return
				end
			return minetest.item_place(itemstack, placer, pointed_thing)
			end

local dig_it = function(pos, node, digger)
		if minetest.get_player_privs(digger:get_player_name()).myregenchest ~= true then
			minetest.chat_send_player( digger:get_player_name(), "You do not have the privelege to remove the chest" )
			return
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

minetest.register_node("myregenchest:tools_chest", {
	description = "Tools Chest",
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



minetest.register_node("myregenchest:tools_chest_open", {
	description = "Tools Chest Open",
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
	drop = "myregenchest:chest",
	groups = {not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	node_box = open_box,
	selection_box = open_box,
	on_timer = function(pos, elapsed)
	local timer = minetest.get_node_timer(pos)
	local node = minetest.get_node(pos)
	minetest.swap_node(pos, {name = "myregenchest:tools_chest", param2=node.param2})
	
	local all_objects = minetest.get_objects_inside_radius(pos, 0.5)
	local players = {}
	local _,obj
		for _,obj in ipairs(all_objects) do
			if obj:is_player() == false then
				obj:remove() 
			end
		end
	end,
})

