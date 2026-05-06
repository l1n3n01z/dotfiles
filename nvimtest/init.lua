-- nvimtest: A LazyVim-inspired config without lazy.nvim
-- Plugins are installed via Nix (home-manager) and loaded with packadd

-- Load options first (before plugins)
require("config.options")

-- Load all plugins via packadd
-- These are installed by Nix to pack/home-manager/opt/
local plugins = {
  -- Treesitter (startup plugin, auto-loaded)
  -- "nvim-treesitter",

  -- Colorscheme
  "tokyonight-nvim",

  -- Dependencies
  "plenary-nvim",
  "nvim-web-devicons",
  "nui-nvim",

  -- Completion
  "friendly-snippets",
  "blink-cmp",

  -- LSP
  "nvim-lspconfig",
  "lazydev-nvim",
  "conform-nvim",
  "nvim-lint",

  -- Treesitter extras
  "nvim-treesitter-textobjects",
  "nvim-ts-autotag",

  -- Editor
  "flash-nvim",
  "grug-far-nvim",
  "which-key-nvim",
  "gitsigns-nvim",
  "trouble-nvim",
  "todo-comments-nvim",
  "persistence-nvim",
  "ts-comments-nvim",

  -- UI
  "snacks-nvim",
  "bufferline-nvim",
  "lualine-nvim",
  "noice-nvim",
  "indent-blankline-nvim",

  -- File explorer
  "neo-tree-nvim",

  -- Picker
  "telescope-nvim",
  "telescope-fzf-native-nvim",

  -- DAP
  "nvim-nio",
  "nvim-dap",
  "nvim-dap-ui",
  "nvim-dap-virtual-text",

  -- Git
  "vim-fugitive",

  -- Mini (provides many modules)
  "mini-nvim",
}

for _, plugin in ipairs(plugins) do
  local ok, err = pcall(vim.cmd.packadd, plugin)
  if not ok then
    vim.notify("Failed to load " .. plugin .. ": " .. err, vim.log.levels.WARN)
  end
end

-- Configure plugins
require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.completion")
require("plugins.editor")
require("plugins.ui")
require("plugins.mini")

-- Load keymaps last (after plugins are configured)
require("config.keymaps")
