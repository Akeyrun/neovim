return {
  "windwp/nvim-autopairs",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  event = "InsertEnter",
  -- use opts = {} for passing setup options
  -- this is equalent to setup({}) function
  -- opts = {},
  config = function()
    require("nvim-autopairs").setup({
      -- put this to setup function and press <a-e> to use fast_wrap
      fast_wrap = {},
      check_ts = true,
      ts_config = {
        lua = { "string" }, -- it will not add a pair on that treesitter node
        javascript = { "template_string" },
        java = false,       -- don't check treesitter on java
      },
    })

    -- import nvim-autopairs completion funcitonality
    local autopairs_cmp = require("nvim-autopairs.completion.cmp")
    -- make autopairs and completion plugin work together
    require("cmp").event:on("confirm_done", autopairs_cmp.on_confirm_done())
  end,
}
