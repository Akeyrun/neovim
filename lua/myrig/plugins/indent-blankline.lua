return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hiphish/rainbow-delimiters.nvim",
    config = function()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require("rainbow-delimiters")

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        highlight = {
          "RainbowRed",
          "RainbowYellow",
          "RainbowBlue",
          "RainbowOrange",
          "RainbowGreen",
          "RainbowViolet",
          "RainbowCyan",
        },
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          commonlisp = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
      }
    end
  },
  main = "ibl",
  config = function()
    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)

    require("ibl").setup({
      indent = {
        char = "▏",
        highlight = vim.g.rainbow_delimiters.highlight,
      },
    })

    hooks.register(
      hooks.type.SCOPE_HIGHLIGHT,
      hooks.builtin.scope_highlight_from_extmark
    )
  end,
}

