--- Mapgen code.

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
				if x_global > -3 and x_global < 3 and z_global > -3 and z_global < 3 then
					data[pos] = minetest.get_content_id("spleef:hard_block")
				else
					data[pos] = minetest.get_content_id("spleef:soft_block")
				end
			end
		end
	end

	vm:set_data(data)
	vm:write_to_map()
end)
