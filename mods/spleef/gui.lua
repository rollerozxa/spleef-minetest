--- GUI stuff (Inventory, hotbar...)

minetest.register_on_joinplayer(function(player)
	player:hud_set_hotbar_itemcount(5)
end)