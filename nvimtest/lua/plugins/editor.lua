-- Editor plugins configuration

-- Flash (navigation)
require("flash").setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    multi_window = true,
    forward = true,
    wrap = true,
  },
  jump = {
    jumplist = true,
    pos = "start",
    autojump = false,
  },
  label = {
    uppercase = false,
    rainbow = { enabled = false },
  },
  modes = {
    search = { enabled = false }, -- don't use with /
    char = { enabled = true },
    treesitter = { labels = "asdfghjklqwertyuiopzxcvbnm" },
  },
})

-- Which-key
require("which-key").setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = true, suggestions = 20 },
  },
  spec = {
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>d", group = "debug" },
    { "<leader>f", group = "file/find" },
    { "<leader>g", group = "git" },
    { "<leader>gh", group = "hunks" },
    { "<leader>q", group = "quit/session" },
    { "<leader>s", group = "search" },
    { "<leader>u", group = "ui/toggle" },
    { "<leader>x", group = "diagnostics/quickfix" },
    { "<leader><tab>", group = "tabs" },
    { "[", group = "prev" },
    { "]", group = "next" },
    { "g", group = "goto" },
    { "gs", group = "surround" },
    { "z", group = "fold" },
  },
})

-- Gitsigns
require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  signs_staged = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
  },
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
    map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")
    map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
    map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")

    -- Actions
    map({ "n", "v" }, "<leader>ghs", gs.stage_hunk, "Stage Hunk")
    map({ "n", "v" }, "<leader>ghr", gs.reset_hunk, "Reset Hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
    map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
    map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
    map("n", "<leader>ghd", gs.diffthis, "Diff This")
    map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
  end,
})

-- Trouble
require("trouble").setup({
  modes = {
    symbols = {
      focus = false,
      win = { position = "right" },
    },
  },
})

-- Todo-comments
require("todo-comments").setup({
  signs = true,
  keywords = {
    FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
})

-- Grug-far (search and replace)
require("grug-far").setup({
  windowCreationCommand = "split",
})

-- Persistence (sessions)
require("persistence").setup({
  dir = vim.fn.stdpath("state") .. "/sessions/",
  need = 1,
})

-- Telescope
require("telescope").setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-n>"] = "move_selection_next",
        ["<C-p>"] = "move_selection_previous",
      },
    },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = { preview_width = 0.5 },
    },
  },
  pickers = {
    find_files = { hidden = true },
  },
})

-- Load telescope-fzf-native for better sorting
pcall(require("telescope").load_extension, "fzf")

-- Neo-tree
require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  window = {
    mappings = {
      ["l"] = "open",
      ["h"] = "close_node",
      ["<space>"] = "none",
      ["Y"] = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        vim.fn.setreg("+", path, "c")
        vim.notify("Copied: " .. path)
      end,
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = "",
      expander_expanded = "",
    },
    git_status = {
      symbols = {
        unstaged = "󰄱",
        staged = "󰱒",
      },
    },
  },
})

-- Indent-blankline
require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
  },
  scope = { show_start = false, show_end = false },
  exclude = {
    filetypes = {
      "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
      "lazy", "mason", "notify", "toggleterm", "lazyterm",
    },
  },
})

-- DAP
local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
  controls = {
    icons = {
      pause = "⏸",
      play = "▶",
      step_into = "⏎",
      step_over = "⏭",
      step_out = "⏮",
      step_back = "b",
      run_last = "▶▶",
      terminate = "⏹",
      disconnect = "⏏",
    },
  },
})

require("nvim-dap-virtual-text").setup({})

-- Auto open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- .NET/C# debugging
dap.adapters.coreclr = {
  type = "executable",
  command = "netcoredbg",
  args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end,
  },
}
