return {
  -- tailwind-tools.lua
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {}, -- your configuration
    config = function()
      require("tailwind-tools").setup({})
    end
  },
}
