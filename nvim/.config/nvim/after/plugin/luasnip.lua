local ls = require("luasnip")

-- snippet creator
local s = ls.s

-- fmt("<fmt_string>", {...nodes})
local fmt = require("luasnip.extras.fmt").fmt
-- i(1, [default_text])
local i = ls.insert_node

local rep = require("luasnip.extras").rep

ls.snippets = {
  all = {},
  cs = {
    s("ifn", fmt("if ({} == null) return $0", { i(1) }))
  },
}
