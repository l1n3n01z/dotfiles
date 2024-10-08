-- so this is an implementation of copy that seems to work fine
-- there are multiple race conditions but they shouldn't
-- bother us under any normal circumstances
-- and in the worst case we paste some bad text, undo and do it again
--
-- we explicitly set the clipboard to reduce startup time
-- win32yank must be installed and be in our path
-- as win32yank is a bit slow due to being called from windows
-- we have implemented a debounce
-- set the debounce time as fast as possible, but not so fast
-- that win32yank starts stalling
-- 200 ms seems to work fine
-- the debounce paste time can be a bit faster

-- TODO
-- add xclip for wsl to wsl copying since wsl supports that now
-- xclip unfortunately does not work accross wsl to windows
-- also not sure it is worth it, as the cache only kicks in when we are moving super fast
-- but it might help across neovim instances if we are doing some copying programmatically
--
-- we are supposed to use vim.system instead of vm.fn.system, but I didn't get it to work properly
-- I suspect that we could use a single cache, but not sure about the concurrency..
-- do we need bracketed paste?

local uv = vim.version().minor >= 10 and vim.uv or vim.loop

local pastetimer = uv.new_timer()
local copytimer = uv.new_timer()
local copy_cache = nil
local paste_cache = nil
local debounce_time_ms = 200
local debounce_paste_time_ms = 100

-- we keep a cache to be able to copy and paste fast
-- i.e. holding in x or similar
local function debounced_copy(copied)
	copy_cache = copied
	-- simple debounce
	copytimer:stop()
	copytimer:start(debounce_time_ms, 0, function()
		copytimer:stop()
		vim.schedule(function()
			vim.fn.system("win32yank.exe -i", copied)
			copy_cache = nil
			-- need to clear the paste cache so we are not holding on to old data
			paste_cache = nil
		end)
	end)
end

local function paste()
	-- this works fine, it pastes the latest copied thing
	-- and is usually nil because the timer has run and emptied it
	if copy_cache then
		return copy_cache
	end
	-- we use a paste cache, because calling win32yank for pasting is also very slow
	if paste_cache then
		pastetimer:stop()
		-- we reset the paste cache once we have some time to breathe
		-- so that if we are copying from windows we paste that data and not the old paste_cache
		pastetimer:start(debounce_paste_time_ms, 0, function()
			pastetimer:stop()
			paste_cache = nil
		end)
		return paste_cache
	end
	paste_cache = vim.fn.systemlist("win32yank.exe -o --lf", "", 1)
	-- kill this cache shortly after to prevent us having it persisted
	-- and returning the cache instead of a value from windows
	pastetimer:stop()
	pastetimer:start(debounce_paste_time_ms, 0, function()
		pastetimer:stop()
		paste_cache = nil
	end)
	return paste_cache
end

-- testing
-- local function copy_nothing(copied) end

if vim.fn.has("wsl") then
	vim.g.clipboard = {
		name = "clipfunctions",
		copy = {
			-- ["+"] = "win32yank.exe -i",
			-- ["*"] = "win32yank.exe -i",
			-- ["+"] = nothing,
			-- ["*"] = nothing,
			["+"] = debounced_copy,
			["*"] = debounced_copy,
			-- ["*"] = "clip.exe"
			-- ["+"] = "clip.exe",
		},
		paste = {
			-- ["+"] = "win32yank.exe -o --lf",
			-- ["*"] = "win32yank.exe -o --lf",
			["+"] = paste,
			["*"] = paste,
		},
		-- we use our own naive cache, because the nvim cache doesn't function with the debounce currently
		cache_enabled = 0,
	}
	-- let's not swamp the clipboard with single characters
	-- note, maybe create a "user.wsl" thing?
	-- vim.keymap.set("n", "x", "\"0x", { silent = true })
	-- vim.keymap.set("n", "X", "\"0X", { silent = true })
end
