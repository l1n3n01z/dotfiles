-- Completion configuration (blink.cmp)
require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },

  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  completion = {
    accept = {
      auto_brackets = { enabled = true },
    },
    menu = {
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "rounded" },
    },
    ghost_text = { enabled = true },
  },

  signature = {
    enabled = true,
    window = { border = "rounded" },
  },
})
