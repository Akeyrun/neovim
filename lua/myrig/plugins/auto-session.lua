return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "info",
      auto_session_suppress_dirs = { "~/", "~/coding", "/" },
      -- auto_session_enable_last_session = false,
      -- auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
      -- auto_session_enabled = true,
      -- auto_save_enabled = nil,
      auto_restore_enabled = false,
      -- auto_session_use_git_branch = nil,
      -- the configs below are lua only
      -- bypass_session_save_file_types = nil,
      pre_save_cmds = { "tabdo Neotree close" },
      post_restore_cmds = { "1tabnext" },

      session_lens = {
        -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
        buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    })
    -- :SessionSave " saves or creates a session in the currently set `auto_session_root_dir`.
    -- :SessionSave ~/my/custom/path " saves or creates a session in the specified directory path.
    -- :SessionRestore " restores a previously saved session based on the `cwd`.
    -- :SessionRestore ~/my/custom/path " restores a previously saved session based on the provided path.
    -- :SessionRestoreFromFile ~/session/path " restores any currently saved session
    -- :SessionDelete " deletes a session in the currently set `auto_session_root_dir`.
    -- :SessionDelete ~/my/custom/path " deleetes a session based on the provided path.
    -- :SessionPurgeOrphaned " removes all orphaned sessions with no working directory left.
    -- :Autosession search
    -- :Autosession delete
    vim.keymap.set("n", "<leader>sr", "<Cmd>SessionRestore<CR>", { desc = "Restore session" })
    vim.keymap.set(
      "n",
      "<leader>sl",
      require("auto-session.session-lens").search_session,
      { noremap = true, desc = "Display session list" }
    )
    -- vim.keymap.set("n", "<leader>ss", ":SessionSave<CR>", { desc = "Save session." })
    -- vim.keymap.set("n", "<leader>sd", ":SessionDelete<CR>", { desc = "Delete session." })
  end,
}
