local fn = vim.fn
local snapshot_name = "b4cmp"

-- Automatically install packer
-- Consider not doing this on remote systems?
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("Packer not available")
  return
end
local status_ok, putil = pcall(require, "packer.util")
if not status_ok then
  vim.notify("Packer util not available")
  return
end
local join_paths = putil.join_paths

-- Have packer use a popup window
-- Use snapshots
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  snapshot_path = join_paths(fn.stdpath("config"), 'packer.nvim'),
  snapshot = snapshot_name,
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use { "wbthomason/packer.nvim", commit = "" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim", commit = "" } -- Useful lua functions used by lots of plugins
  use { 
    "numToStr/Comment.nvim", 
    commit = "", 
    -- if we set up new keymaps, use a file to config
    config = function() 
      require('Comment').setup()
    end 
  }
--  use { "kyazdani42/nvim-web-devicons", commit = "" }
--  use { "kyazdani42/nvim-tree.lua", commit = "" }
--  use { "akinsho/bufferline.nvim", commit = "" }
--  use { "nvim-lualine/lualine.nvim", commit = "" }
--  use { "lewis6991/impatient.nvim", commit = "" }

  -- Colorschemes
--  use { "folke/tokyonight.nvim", commit = "" }
--  use { "lunarvim/darkplus.nvim", commit = "" }

  -- cmp plugins
--  use { "hrsh7th/nvim-cmp", commit = "" } -- The completion plugin
--  use { "hrsh7th/cmp-buffer", commit = "" } -- buffer completions
--  use { "hrsh7th/cmp-path", commit = "" } -- path completions
--  use { "saadparwaiz1/cmp_luasnip", commit = "" } -- snippet completions
--  use { "hrsh7th/cmp-nvim-lsp", commit = "" }
--  use { "hrsh7th/cmp-nvim-lua", commit = "" }

  -- snippets
--  use { "L3MON4D3/LuaSnip", commit = "" } --snippet engine
--  use { "rafamadriz/friendly-snippets", commit = "" } -- a bunch of snippets to use

  -- LSP
--  use { "neovim/nvim-lspconfig", commit = "" } -- enable LSP
--  use { "williamboman/nvim-lsp-installer", commit = "" } -- simple to use language server installer
--  use { "jose-elias-alvarez/null-ls.nvim", commit = "" } -- for formatters and linters

  -- Telescope
--  use { "nvim-telescope/telescope.nvim", commit = "" }

  -- Treesitter
--  use {
--    "nvim-treesitter/nvim-treesitter"
--  }

  -- DAP
--  use { "mfussenegger/nvim-dap", commit = "" }
--  use { "rcarriga/nvim-dap-ui", commit = "" }
--  use { "ravenxrz/DAPInstall.nvim", commit = "" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
