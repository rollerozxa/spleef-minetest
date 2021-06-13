dofile(minetest.get_modpath("spleef") .. "/hand.lua")

minetest.register_node('spleef:soft_block', {
	description = 'Soft Block',
	tiles = { 'spleef_soft_block.png' },
	groups = { oddly_breakable_by_hand = 3 }
})

local data = {}

minetest.register_on_generated(function(minp, maxp, blockseed)
	if minp.y == 48 then
		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
		vm:get_data(data)

		for x = 0, 79 do
			for z = 0, 79 do
				x_global = minp.x + x
				z_global = minp.z + z
				pos = area:index(x_global, minp.y, z_global)
				data[pos] = minetest.get_content_id("spleef:soft_block")
			end
		end

		vm:set_data(data)
		vm:write_to_map()
	end
end)
