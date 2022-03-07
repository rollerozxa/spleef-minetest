
function increment_blocksbroken(name)
	storage:set_int(name.."_blocksbroken", storage:get_int(name.."_blocksbroken") + 1)
end
