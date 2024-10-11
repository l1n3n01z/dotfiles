require("lualine").setup({
    extensions = { "neo-tree", "lazy" },
});
require('mini.indentscope').setup(
    {
        -- symbol = "▏",
        symbol = "│",
        options = { try_as_border = true },
        animation_fun = require("mini.indentscope").gen_animation.quartic({ duration = 100, unit = "total" }),
        -- delay = 30,
    }
);
require("ibl").setup({
    indent = {
        char = "│",
        tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
        filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
        },
    },
}
);
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "alpha",
        "dashboard",
        "fzf",
        "help",
        "lazy",
        "lazyterm",
        "mason",
        "neo-tree",
        "notify",
        "toggleterm",
        "Trouble",
        "trouble",
    },
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
})
