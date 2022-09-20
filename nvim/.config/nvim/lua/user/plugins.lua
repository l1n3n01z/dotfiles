local fn = vim.fn
local snapshot_name = "cmp_nv08_g907fc8ac3"

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
      return putil.float { border = "rounded" }
    end,
  },
  snapshot_path = join_paths(fn.stdpath("config"), 'packer.nvim'),
  snapshot = snapshot_name,
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use { "wbthomason/packer.nvim" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins
  use { 
    "numToStr/Comment.nvim", 
    commit = "", 
    -- if we set up new keymaps, use a file to config
    config = function() 
      require('Comment').setup()
    end 
  }
--  use { "kyazdani42/nvim-web-devicons" }
--  use { "kyazdani42/nvim-tree.lua" }
--  use { "akinsho/bufferline.nvim" }
--  use { "nvim-lualine/lualine.nvim" }
--  use { "lewis6991/impatient.nvim" }

  -- Colorschemes
 use { "folke/tokyonight.nvim" }
 use { "lunarvim/darkplus.nvim" }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp" } -- The completion plugin
  use { "hrsh7th/cmp-buffer" } -- buffer completions
  use { "hrsh7th/cmp-path" } -- path completions
  use { "saadparwaiz1/cmp_luasnip" } -- snippet completions
--  use { "hrsh7th/cmp-nvim-lsp" }
--  use { "hrsh7th/cmp-nvim-lua" }

  -- snippets
  use { "L3MON4D3/LuaSnip" } --snippet engine
  use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use

  -- LSP
--  use { "neovim/nvim-lspconfig" } -- enable LSP
--  use { "williamboman/nvim-lsp-installer" } -- simple to use language server installer
--  use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters

  -- Telescope
--  use { "nvim-telescope/telescope.nvim" }

  -- Treesitter
--  use { "nvim-treesitter/nvim-treesitter" }

  -- DAP
--  use { "mfussenegger/nvim-dap" }
--  use { "rcarriga/nvim-dap-ui" }
--  use { "ravenxrz/DAPInstall.nvim" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
