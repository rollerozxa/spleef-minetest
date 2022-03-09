
function increment_blocksbroken(name)
	storage:set_int(name.."_blocksbroken", storage:get_int(name.."_blocksbroken") + 1)
end

-- pos: position at the death
-- name: name of player that gets killed
function death_stats(pos, name)
	-- Collect some data
	local groundpos = { x = math.floor(pos.x), y = -32, z = math.floor(pos.z) }

	-- Get killer from groundnode's breaker meta
	local meta = minetest.get_meta(groundpos)
	local killer = meta:get_string("breaker")

	if killer == name then -- good god, suicidal fucker
		minetest.chat_send_all(minetest.colorize("#ff8000", name.." killed himself."))
		storage:set_int(name.."_deaths", storage:get_int(name.."_deaths") + 1)
		return
	end

	minetest.chat_send_all(minetest.colorize("#8888ff", killer.." killed "..name.."."))
	storage:set_int(name.."_deaths", storage:get_int(name.."_deaths") + 1)
	storage:set_int(killer.."_kills", storage:get_int(killer.."_kills") + 1)
end
