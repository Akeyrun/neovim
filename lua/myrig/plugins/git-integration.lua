return
{
  {
    -- Plugin for calling lazygit from within vim.
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    -- Super fast git decorations implemented purely in Lua.
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]h", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Next stage-pending hunk" })

          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[h", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Previous stage-pending hunk" })

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git stage hunk" })
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git stage hunk" })
          map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git reset hunk" })
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git reset hunk" })
          map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git stage buffer" })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git unstage downmost hunk" })
          map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git reset buffer" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git preview hunk" })
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Git commmited chunk blame" })
          map("n", "<leader>hl", gitsigns.toggle_current_line_blame, { desc = "Git toggle current line blame" })
          map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git diff working tree" })
          map("n", "<leader>gD", function()
            gitsigns.diffthis("~")
          end, { desc = "Git diff last commit" })
          map("n", "<leader>ht", gitsigns.toggle_deleted, { desc = "Git toggle deleted hunk" })
          map("n", "<leader>hh", gitsigns.toggle_linehl, { desc = "Git toggle line highlight" })
          map("n", "<leader>gb", gitsigns.blame, { desc = "Git signs blame" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", {})
        end,
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gB", function()
        vim.cmd.Git("blame")
      end, { desc = "Git fugitive blame" })

      local augroup = vim.api.nvim_create_augroup("fugitive-specials", { clear = true })

      vim.api.nvim_create_autocmd("BufWinEnter", {
        desc = "Enable to close fugitive blame window with <Leader>c",
        group = augroup,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitiveblame" then
            return false
          end

          vim.keymap.set("n", "<Leader>c", function()
            vim.cmd.wincmd("c")
          end, {
            buffer = vim.api.nvim_get_current_buf(),
            desc = "Close fugitive blame",
          })
        end
      })
    end
  },
}
