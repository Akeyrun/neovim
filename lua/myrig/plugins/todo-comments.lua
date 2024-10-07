return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
  },
  config = function()
    local todo_comments = require("todo-comments")
    todo_comments.setup({
      keywords = {
        TEST = {
          icon = "∑",
        }
      }
    })

    vim.keymap.set("n", "]t", function()
      todo_comments.jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
      todo_comments.jump_prev()
    end, { desc = "Previous todo comment" })

    vim.keymap.set("n", "<Leader>ft", "<Cmd>TodoTelescope<CR>", { desc = "TODO list in telescope" })
  end,
}
