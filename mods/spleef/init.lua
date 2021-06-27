dofile(minetest.get_modpath('spleef') .. "/gui.lua")
dofile(minetest.get_modpath("spleef") .. "/hand.lua")
dofile(minetest.get_modpath('spleef') .. "/mapgen.lua")

minetest.register_node('spleef:soft_block', {
	description = 'Soft Block',
	tiles = { 'spleef_soft_block.png' },
	groups = { oddly_breakable_by_hand = 3 },
	drop = "",
	after_destruct = function(pos, oldnode)
		minetest.place_node({ x = pos.x, y = pos.y + 75, z = pos.z}, {name = "spleef:reset_timer"})
	end
})

minetest.register_node('spleef:hard_block', {
	description = 'Hard Block',
	tiles = { 'spleef_hard_block.png' }
})

minetest.register_node('spleef:reset_timer', {
	description = 'Reset Timer Node (Internal)',
	tiles = { 'blank.png' },
	drawtype = 'airlike',
	on_construct = function(pos)
		timer = minetest.get_node_timer(pos)
		timer:start(5)
	end,
	on_timer = function(pos, elapsed)
		minetest.place_node({ x = pos.x, y = pos.y - 73, z = pos.z}, {name = "spleef:soft_block"})
		minetest.remove_node(pos)
	end
})

minetest.register_on_dignode(function(pos, oldnode, digger)
	player_pos = digger:get_pos()

	if player_pos.x > -4 and player_pos.x < 4 and player_pos.z > -4 and player_pos.z < 4 then
		minetest.chat_send_player(digger:get_player_name(), minetest.colorize("#ff0000", "Go out of the safe area first!"))
		minetest.place_node({ x = pos.x, y = pos.y + 1, z = pos.z }, oldnode)
	end
end)

minetest.register_globalstep(function(dtime)
	for key, player in ipairs(minetest.get_connected_players()) do
		playerpos = player:get_pos()

		if playerpos.y < 16 then
			player:set_hp(0, 'uwu')
		end
	end
end)