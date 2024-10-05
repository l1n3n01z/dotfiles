local profileType = os.getenv("NVIM_PROFILE")

-- this is a bit hardcoded
local function profileAvailable()
  local profileLazyPath = vim.fn.stdpath("data") .. "/lazy/profile.nvim/"
  vim.opt.rtp:prepend(profileLazyPath)
  local ret, _ = pcall(require, "profile")
  return ret
end

local should_profile = profileType and profileAvailable()

if not profileType then
  profileType = ""
end

if should_profile then
  require("profile").instrument_autocmds()
  local function toggle_profile()
    local prof = require("profile")
    if prof.is_recording() then
      prof.stop()
      vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
        if filename then
          prof.export(filename)
          vim.notify(string.format("Wrote %s", filename))
        end
      end)
    else
      prof.start("*")
    end
  end
  vim.keymap.set("", "<f1>", toggle_profile)
  if profileType:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
