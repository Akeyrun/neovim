return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
    },
    config = function()
      pcall(require('telescope').load_extension, "fzf")
      pcall(require('telescope').load_extension, "ui-select")

      ---@param preview_width number
      ---@param layout_strategy "horizontal" | "vertical"
      local extra_layout = function(layout_strategy, preview_width)
        return {
          layout_strategy = layout_strategy,
          layout_config = {
            horizontal = {
              preview_width = preview_width,
            },
          },
        }
      end

      require("telescope").setup({
        defaults = {
          selection_caret = "▶ ",
          sorting_strategy = "descending", -- sorting start line of the results: "ascending" | "descrnding"
          -- path_display = { "tail", "smart" },
          path_display = { truncate = 4, },
          dynamic_preview_title = true,
          layout_strategy = "vertical",
          layout_config = {
            horizontal = {
              width = 0.90,
              height = 0.80,
              preview_width = 0.65, -- Adjust this value as needed
              -- prompt_position = "top",
            },
            vertical = {
              width = 0.85,        -- Adjust this value as needed for the width
              height = 0.85,
              preview_cutoff = 20, -- Telescope window width below which preview is off
              -- preview_width = 0.6, -- Adjust this value as needed for the preview width
              -- preview_height = 0.60, -- Adjust this value as needed
              mirror = true, -- Swap previews display
              -- prompt_position = "top",
            },
            bottom_pane = {
              height = 25,
              preview_cutoff = 120,
              prompt_position = "top"
              -- prompt_position = "bottom"
            },
            center = {
              height = 0.4,
              preview_cutoff = 40,
              prompt_position = "top",
              width = 0.5
            },
            cursor = {
              height = 0.9,
              preview_cutoff = 40,
              width = 0.8
            },
          },
        },

        pickers = (function()
          local pickers = {}
          local builtins_hori_lg_preview = {
            "lsp_outgoing_calls",
            "lsp_incoming_calls",
            "buffers",
            "treesitter",
            "lsp_dynamic_workspace_symbols",
            -- "builtin",
            "planets",
            "help_tags",
          }
          local builtins_hori_md_preview = {
            "git_bcommits",
            "git_commits",
            "git_status",
            "lsp_document_symbols",
            "lsp_references",
            "find_files",
            "oldfiles",
          }
          for i = 1, #builtins_hori_lg_preview do
            pickers[builtins_hori_lg_preview[i]] = extra_layout("horizontal", 0.55)
          end
          for i = 1, #builtins_hori_md_preview do
            pickers[builtins_hori_md_preview[i]] = extra_layout("horizontal", 0.65)
          end
          return pickers
        end)(),
      })

      local function map(lhs, rhs, opts)
        vim.keymap.set("n", lhs, rhs, opts)
      end
      local builtin = require("telescope.builtin")

      -- HACK: To the contextual mappings menu specific to each picker:
      -- Insert mode: Ctrl Shift /
      -- Normal mode: Shift ?

      map("<Leader>fh", function()
        builtin.help_tags()
        -- builtin.help_tags(require("telescope.themes").get_ivy({ width = 0.50, layout_strategy = "bottom_pane", sorting_strategy = "descending", winblend = 10, previewer = false, layout_config = { prompt_position = "bottom", }, }))
      end, { desc = "Neovim Help tags" })
      map("<Leader>fm", builtin.man_pages, { desc = "Man Pages" })
      map("<Leader>gl", builtin.git_commits, { desc = "Git Commits" })
      map("<Leader>gc", builtin.git_bcommits, { desc = "Git Buffer Commits" })
      map("<Leader>gs", builtin.git_status, { desc = "Git Status" })
      map("<Leader>tt", builtin.builtin, { desc = "Builtin" })
      map("<Leader>fk", builtin.keymaps, { desc = "Keymaps (:no)" })
      map("<Leader>fd", builtin.diagnostics, { desc = "Cwd Diagnostics" })
      map("<Leader>fb", builtin.buffers, { desc = "Buffers" })
      map("<Leader>ff", builtin.find_files, { desc = "Find Files" })
      map("<Leader>rf", builtin.resume, { desc = "Resume" })
      map("<Leader>of", builtin.oldfiles, { desc = "Old Files" })
      map("<Leader>fg", builtin.live_grep, { desc = "Live Grep cwd" })
      map("<Leader>fn", function()
        builtin.find_files({
          cwd = vim.fn.stdpath("config"),
          prompt_title = "Find Neovim Config Files",
        })
      end, { desc = "Find nvim config files" })
      map("<Leader>cc", function()
        builtin.commands(require("telescope.themes").get_ivy({
          layout_strategy = "bottom_pane",
        }))
      end, { desc = "Commands" })
      map("<Leader>ch", function()
        builtin.command_history(require("telescope.themes").get_dropdown({
          sorting_strategy = "descending",
          layout_strategy = "center",
          layout_config = {
            center = {
              height = 0.3,
              width = 0.3,
            },
          },
        }))
      end, { desc = "Commands History" })
      -- NOTE: grep_string is particularly useful to instantaniously
      -- find the associated line string with the one the cursor is on
      map("<Leader>*", function()
        builtin.grep_string({
          -- search = "", -- the query
          -- prompt_title = "Second To Instant Cursor Grep",
        })
      end, { desc = "Find cursor string on cwd" })

      map("<Leader>/", function()
        builtin.current_buffer_fuzzy_find({
          skip_empty_lines = true,
        })
      end, { desc = "Fuzzy Search Current Buffer" })

      map("<Leader>th", function()
        builtin.colorscheme(require("telescope.themes").get_cursor({
          enable_preview = true,
          sorting_strategy = "descending",
          layout_strategy = "cursor",
        }))
      end, { desc = "Color Themes" })

      map("<Leader>q", function()
        builtin.diagnostics({
          bufnr = 0,
        })
      end, { desc = "Buffer Diagnostics" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      telescope.load_extension("ui-select")
    end,
  },
}

-- return {
--   {
--     "nvim-telescope/telescope.nvim",
--     dependencies = {
--       "nvim-lua/plenary.nvim",
--       "nvim-telescope/telescope-ui-select.nvim",
--       { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
--
--     },
--     config = function()
--       local actions = require('telescope.actions')
--       local themes = require('telescope.themes')
--
--       require('telescope').setup {
--         defaults = themes.get_dropdown {
--           winbled           = 10,
--           file_sorter       = require('telescope.sorters').get_fzy_sorter,
--           prompt_prefix     = "> ",
--           color_devicons    = true,
--           respect_gitignore = true,
--           sorting_strategy  = "descending",
--           prompt_position   = "top",
--           scroll_strategy   = "cycle",
--           file_previewer    = require('telescope.previewers').vim_buffer_cat.new,
--           grep_previewer    = require('telescope.previewers').vim_buffer_vimgrep.new,
--           qflist_previewer  = require('telescope.previewers').vim_buffer_qflist.new,
--           mappings          = {
--             i = {
--               ["<C-x>"] = false,
--               ["<C-q>"] = actions.send_to_qflist,
--               ["<C-s>"] = actions.select_horizontal,
--             },
--           }
--         },
--         extensions = {
--           fzf = {},
--         },
--
--         pickers = {
--           git_branches = {
--             mappings = {
--               i = {
--                 ["<C-a>"] = false
--               }
--             }
--           },
--           buffers = {
--             sort_mru = true,
--             mappings = {
--               i = { ["<c-d>"] = actions.delete_buffer },
--             },
--           },
--         },
--       }
--
--       require("telescope").load_extension("git_worktree")
--       require("telescope").load_extension("fzf")
--       require("telescope").load_extension("ui-select")
--       require("telescope").load_extension("harpoon")
--
--       local builtin = require "telescope.builtin"
--
--       map("<leader>pf", function() builtin.find_files({ hidden = true }) end)
--       map("<C-p>", builtin.git_files)
--       map("<leader>ps",
--         function() builtin.grep_string({ search = vim.fn.input('Grep For > ') }) end)
--       map("<leader>pp", builtin.live_grep)
--       map("<leader>vih", builtin.help_tags)
--       map("<leader>/", builtin.current_buffer_fuzzy_find)
--
--       -- Grep the current highlighted selction
--       map("v", "<leader>ps",
--         "\"gy<cmd>lua require(\"telescope.builtin\").grep_string({ search = vim.fn.getreg(\"g\") })<cr>")
--
--       map("<leader>vrc", function()
--         require("telescope.builtin").find_files({
--           prompt_title = ".dotfiles",
--           cwd = os.getenv("HOME") .. "/.dotfiles",
--           hidden = true,
--         })
--       end)
--     end,
--   },
--   {
--     "ThePrimeagen/git-worktree.nvim",
--     config = function()
--       require("git-worktree").setup {}
--       map("<leader>gw",
--         ":lua require('telescope').extensions.git_worktree.git_worktrees({ layout_config = { width = 0.5, height = 0.5 }})<CR>")
--       map("<leader>gm",
--         ":lua require('telescope').extensions.git_worktree.create_git_worktree({ layout_config = { width = 0.5, height = 0.5, preview_height = 0.6, }})<CR>")
--     end,
--   },
-- }
