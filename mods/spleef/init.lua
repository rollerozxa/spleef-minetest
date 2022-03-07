
storage = minetest.get_mod_storage()

minetest.register_node('spleef:soft_block', {
	description = 'Soft Block',
	tiles = { 'spleef_soft_block.png' },
	groups = { oddly_breakable_by_hand = 3 },
	drop = "",
})

minetest.register_node('spleef:hard_block', {
	description = 'Hard Block',
	tiles = { 'spleef_hard_block.png' }
})

minetest.register_node('spleef:bricks', {
	description = 'Bricks',
	tiles = { 'spleef_brick.png' }
})

minetest.register_node('spleef:reset_timer', {
	description = 'Reset Timer Node (Internal)',
	tiles = { 'blank.png' },
	drawtype = 'airlike',
	on_construct = function(pos)
		local timer = minetest.get_node_timer(pos)
		timer:start(120)
	end,
	on_timer = function(pos, elapsed)
		minetest.place_node({ x = pos.x, y = pos.y - 73, z = pos.z}, {name = "spleef:soft_block"})
		minetest.remove_node(pos)
	end
})

minetest.register_on_player_hpchange(function(player, hp_change, reason)
	if reason.type == 'fall' then
		return 0
	end
	return hp_change
end, true)

minetest.register_on_dignode(function(pos, oldnode, digger)
	local player_pos = digger:get_pos()

	if player_pos.x > -3 and player_pos.x < 3 and player_pos.z > -3 and player_pos.z < 3 then
		-- Prevent people from breaking nodes if they're still in the safe area.
		minetest.chat_send_player(digger:get_player_name(), minetest.colorize("#ff0000", "Go out of the safe area first!"))
		minetest.place_node({ x = pos.x, y = pos.y + 1, z = pos.z }, oldnode)
	elseif oldnode.name == 'spleef:soft_block' then
		local name = digger:get_player_name()

		increment_blocksbroken(name)

		-- Timer node to regenerate the world.
		local tempos = { x = pos.x, y = pos.y + 76, z = pos.z }
		minetest.place_node(tempos, {name = "spleef:reset_timer"})
		tempos.y = tempos.y - 1
		-- Set breaker meta so kills can be counted.
		local meta = minetest.get_meta(tempos)
		meta:set_string("breaker", name)
	end
end)

minetest.register_globalstep(function(dtime)
	for key, player in ipairs(minetest.get_connected_players()) do
		local playerpos = player:get_pos()

		if playerpos.y < -35 and player:get_hp() > 0 then
			player:set_hp(0, 'void')
			death_stats(playerpos, player:get_player_name())
		end
	end
end)

dofile(minetest.get_modpath('spleef') .. "/gui.lua")
dofile(minetest.get_modpath("spleef") .. "/hand.lua")
dofile(minetest.get_modpath('spleef') .. "/mapgen.lua")
dofile(minetest.get_modpath('spleef') .. "/player_model.lua")
dofile(minetest.get_modpath('spleef') .. "/stats.lua")
