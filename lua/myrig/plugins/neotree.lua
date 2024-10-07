return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  keys = {
    { "<Leader>ee", "<Cmd>Neotree reveal filesystem right<CR>",  desc = "Open Neotree" },
    { "<Leader>e",  "<Cmd>Neotree reveal filesystem show<CR>",   desc = "Show Neotree" },
    { "<Leader>eb", "<Cmd>Neotree reveal filesystem bottom<CR>", desc = "Open Neotree Bottom" },
    { "<Leader>eg", "<Cmd>Neotree float git_status<CR>",         desc = "Show git-tracked files" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },

  config = function()
    local neotree = require("neo-tree")
    neotree.setup({
      window = {
        position = "right",
      }
    })

    vim.keymap.set("n", "<leader>ec", ":Neotree  close<CR>", { desc = "Close Neotree" })
  end,
}
