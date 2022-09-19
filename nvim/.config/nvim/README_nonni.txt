https://www.chrisatmachine.com/blog/category/neovim/01-ide-crash-course
https://github.com/LunarVim/nvim-basic-ide


# Important Directories

    nvim: ~/.config/nvim:

This is where your config lives

    share: ~/.local/share

You will find plugins here under: ~/.local/share/nvim/site/pack/packer You will also find other useful plugin data

    cache: ~/.cache

You can find logs here

    state: ~/.local/state

You can find state about Neovim as well as other plugins here

# Config Structure

The config structure is relatively simple

    init.lua: the entry point for your config

    lua/: the directory where all of your lua code and plugin config goes

    lua/user: a namespace to avoid collisions with other plugins and lua modules

    lua/user/lsp: lsp is complicated enough to warrant it's own separate directory

    lua/user/lsp/settings: specific settings for your Language Server, to find more settings for your language server read more here


TREE
.nvim/
├── init.lua
├── lua
│   └── user
│       ├── autocommands.lua
│       ├── someplugin.lua
│       ├── someplugin2.lua
│       ├── cmp.lua
│       ├── colorscheme.lua
│       ├── lsp
│       │   ├── handlers.lua
│       │   ├── init.lua
│       │   ├── lsp-installer.lua
│       │   ├── null-ls.lua
│       │   └── settings
│       │       ├── pyright.lua
│       │       └── sumneko_lua.lua
│       ├── options.lua
│       ├── plugins.lua
│       ├── telescope.lua
│       └── treesitter.lua
└── README.md



Stability

I have noticed many Neovim users complain about the stability of Neovim and it's plugin ecosystem. If you regularly update your plugins and keep up with the latest Neovim version then you have probably deal with breaking changes fairly often.

Instead of updating daily/weekly etc.. I recommend keeping your config stable and updating once every few months, or whenever there is a new feature you'd like to test out. The best way I have found to do this is to:

    pin your commits when your config is working without bugs and
    Install Neovim from source so that it doesn't update when you update packages using your package manager.

