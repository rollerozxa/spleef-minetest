dofile(minetest.get_modpath("spleef") .. "/hand.lua")

minetest.register_node('spleef:soft_block', {
	description = 'Soft Block',
	tiles = { 'spleef_soft_block.png' },
	groups = { oddly_breakable_by_hand = 3 }
})

minetest.register_node('spleef:hard_block', {
	description = 'Hard Block',
	tiles = { 'spleef_hard_block.png' }
})

minetest.register_node('spleef:rollerium_gas', {
	description = 'ROllerium Gas',
	tiles = { 'blank.png' },
	damage_per_second = 20,
	drawtype = 'airlike'
})

local data = {}

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	vm:get_data(data)

	-- Main spleef layer
	if minp.y == 48 then
		for x = 0, 79 do
			for z = 0, 79 do
				x_global = minp.x + x
				z_global = minp.z + z
				pos = area:index(x_global, minp.y, z_global)
				if x_global > -3 and x_global < 3 and z_global > -3 and z_global < 3 then
					data[pos] = minetest.get_content_id("spleef:hard_block")
				else
					data[pos] = minetest.get_content_id("spleef:soft_block")
				end
			end
		end
	end

	-- ROllerium Gas
	if minp.y == -32 then
		for x = 0, 79 do
			for z = 0, 79 do
				x_global = minp.x + x
				z_global = minp.z + z
				pos = area:index(x_global, 0, z_global)
				data[pos] = minetest.get_content_id("spleef:rollerium_gas")
			end
		end
	end

	vm:set_data(data)
	vm:write_to_map()
end)
minetest.register_on_dignode(function(pos, oldnode, digger)
	player_pos = digger:get_pos()

	if player_pos.x > -4 and player_pos.x < 4 and player_pos.z > -4 and player_pos.z < 4 then
		minetest.chat_send_player(digger:get_player_name(), minetest.colorize("#ff0000", "Go out of the safe area first!"))
		minetest.place_node({ x = pos.x, y = pos.y + 1, z = pos.z }, oldnode)
	end
end)

minetest.register_on_joinplayer(function(player)
	player:hud_set_hotbar_itemcount(5)
end)
