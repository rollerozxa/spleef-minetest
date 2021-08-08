--- Mapgen code.

minetest.register_on_joinplayer(function(player)
	player:set_sky({
		base_color = "#333355",
		type = 'plain',
		clouds = false
	})
end)

local data = {}

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	vm:get_data(data)

	-- Main spleef layer
	if minp.y == -32 then
		for x = 0, 79 do
			for z = 0, 79 do
				x_global = minp.x + x
				z_global = minp.z + z
				pos = area:index(x_global, minp.y, z_global)
				if x_global > -96 and x_global < 96 and z_global > -96 and z_global < 96 then
					if x_global > -3 and x_global < 3 and z_global > -3 and z_global < 3 then
						data[pos] = minetest.get_content_id("spleef:hard_block")
					else
						data[pos] = minetest.get_content_id("spleef:soft_block")
					end
				end
			end
		end
	end

	-- Walls
	if minp.z == -112 and minp.y == -32 and (minp.x >= -112 or minp.x <= 48) then
		for x = 0, 79 do
			x_global = minp.x + x
			if x_global >= -96 and x_global <= 96 then
				for y = 0, 40 do
					y_global = minp.y + y
					pos = area:index(x_global, y_global, -96)
					data[pos] = minetest.get_content_id("spleef:bricks")
				end
			end
		end
	end

	if minp.z == 48 and minp.y == -32 and (minp.x >= -112 or minp.x <= 48) then
		for x = 0, 79 do
			x_global = minp.x + x
			if x_global >= -96 and x_global <= 96 then
				for y = 0, 40 do
					y_global = minp.y + y
					pos = area:index(x_global, y_global, 96)
					data[pos] = minetest.get_content_id("spleef:bricks")
				end
			end
		end
	end

	if minp.x == -112 and minp.y == -32 and (minp.z >= -112 or minp.z <= 48) then
		for z = 0, 79 do
			z_global = minp.z + z
			if z_global >= -96 and z_global <= 96 then
				for y = 0, 40 do
					y_global = minp.y + y
					pos = area:index(-96, y_global, z_global)
					data[pos] = minetest.get_content_id("spleef:bricks")
				end
			end
		end
	end

	if minp.x == 48 and minp.y == -32 and (minp.z >= -112 or minp.z <= 48) then
		for z = 0, 79 do
			z_global = minp.z + z
			if z_global >= -96 and z_global <= 96 then
				for y = 0, 40 do
					y_global = minp.y + y
					pos = area:index(96, y_global, z_global)
					data[pos] = minetest.get_content_id("spleef:bricks")
				end
			end
		end
	end

	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
end)
