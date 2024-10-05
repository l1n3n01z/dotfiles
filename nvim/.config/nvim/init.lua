local telescope_only = function ()
  -- basic things
  require "user.impatient"

  vim.opt.cmdheight = 0                           -- more space in the neovim command line for displaying messages
  vim.opt.laststatus = 0                           -- more space in the neovim command line for displaying messages
  require('telescope').setup{
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = {
        height = 0.99999,
        width = 0.9999,
        preview_cutoff = 0,
      },
      -- border = false,
    },
  }
  require "user.colorscheme"
end

local main = function ()
  -- basic things
  require "user.options"
  require "user.keymaps"
  require "user.commands"
  require "user.system"

  -- install plugins 
  require "user.plugins"


  -- basic things that depend on plugins
  require "user.autocommands"
  require "user.colorscheme"

  -- plugin setups
  require "user.cmp"
  require "user.telescope"
  require "user.treesitter"
  require'nvim-web-devicons'.setup {
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    override = {
      svg = {
        icon = "✹",
      }
    };
}
  require "user.nvim-tree"
  require "user.leap"
  require "user.lualine"
  require "user.impatient"
  require "user.lsp"
  require "user.dap"
end

if vim.g.minimal then
  telescope_only()
else
  main()
end

