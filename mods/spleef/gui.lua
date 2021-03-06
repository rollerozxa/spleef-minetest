--- GUI stuff (Inventory, hotbar...)

-- Simple formspec wrapper that does variable substitution.
local function formspec_wrapper(formspec, variables)
	local retval = formspec

	for k,v in pairs(variables) do
		retval = retval:gsub("${"..k.."}", v)
	end

	return retval
end

function get_inventory_formspec(name)
	return formspec_wrapper([[
		formspec_version[4]
		size[14,11]
		image[2.5,0;9.1,2;logo.png]

		style[text_undertitel;border=false]
		button[0,2.5;14,0.8;text_undertitel;Welcome to Spleef! Break blocks to make your opponents fall to their doom.]

		box[1,4;5,6;#1E1E1E]
		label[2.4,4.5;Your Statistics:]

		label[1.3,5.5;Kills:]
		label[4.2,5.5;${player_kills}]

		label[1.3,6.5;Deaths:]
		label[4.2,6.5;${player_deaths}]

		label[1.3,7.5;Ratio:]
		label[4.2,7.5;N/A]

		label[1.3,8.5;Blocks Broken:]
		label[4.2,8.5;${player_blocksbroken}]

		label[2.2,9.5;Your Rank:]
		label[4.2,9.5;137th]

		label[7.2,4.5;Leaderboard:]
		textlist[7,4.9;5.9,5.1;;1st - Player (0/0),2nd - Player (0/0),3rd - Player (0/0),4th - Player (0/0),5th - Player (0/0),6th - Player (0/0),7th - Player (0/0),8th - Player (0/0),9th - Player (0/0),10th - Player (0/0);1;false]
	]], {
		player_kills = storage:get_int(name.."_kills"),
		player_deaths = storage:get_int(name.."_deaths"),
		player_blocksbroken = storage:get_int(name.."_blocksbroken")
	})
end

minetest.register_on_joinplayer(function(player)
	player:hud_set_hotbar_itemcount(5)

	player:hud_set_hotbar_image("blank.png")
	player:hud_set_hotbar_selected_image("blank.png")

	local name = player:get_player_name()

	player:set_inventory_formspec(get_inventory_formspec(name))
end)

minetest.register_globalstep(function(dtime)
	for key, player in ipairs(minetest.get_connected_players()) do
		player:set_inventory_formspec(get_inventory_formspec(player:get_player_name()))
	end
end)
