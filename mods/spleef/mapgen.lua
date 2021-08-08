--- Mapgen code.

minetest.register_on_joinplayer(function(player)
	player:set_sky({
		base_color = "#333355",
		type = 'plain',
		clouds = false
	})
end)

local data = {}

local mg = {
	nodes = {
		hard = minetest.get_content_id("spleef:hard_block"),
		soft = minetest.get_content_id("spleef:soft_block"),
		bricks = minetest.get_content_id("spleef:bricks"),
	},
	size = 64,
	plat = 3
}

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	vm:get_data(data)

	for z = 0, 79 do
		for y = 0, 79 do
			for x = 0, 79 do
				pos = {
					x = minp.x + x,
					y = minp.y + y,
					z = minp.z + z
				}

				posi = area:index(pos.x, pos.y, pos.z)

				if pos.y == -32 and (pos.x >= -mg.size and pos.x <= mg.size) and (pos.z >= -mg.size and pos.z <= mg.size) then
					if (pos.x > -mg.plat and pos.x < mg.plat) and (pos.z > -mg.plat and pos.z < mg.plat) then
						data[posi] = mg.nodes.hard
					else
						data[posi] = mg.nodes.soft
					end
				elseif pos.y >= -32 and pos.y <= 12 then
					if	(pos.x == -mg.size -1 and (pos.z >= -mg.size -1 and pos.z <= mg.size +1))
					 or	(pos.x ==  mg.size +1 and (pos.z >= -mg.size -1 and pos.z <= mg.size +1))
					 or	(pos.z == -mg.size -1 and (pos.x >= -mg.size -1 and pos.x <= mg.size +1))
					 or	(pos.z ==  mg.size +1 and (pos.x >= -mg.size -1 and pos.x <= mg.size +1)) then
						data[posi] = mg.nodes.bricks
					end
				end
			end
		end
	end

	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
end)
