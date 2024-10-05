return {
  "echasnovski/mini.indentscope",
  -- enabled = false,
  opts = function(_)
    return {
      animation_fun = require("mini.indentscope").gen_animation.quartic({ duration = 300, unit = "total" }),
      delay = 30,
      symbol = "│",
      options = { try_as_border = true },
    }
  end,
}
