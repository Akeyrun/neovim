-- C and C++

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("CSourceCode", { clear = true }),
  pattern = { "*.c", "*.cpp" },
  callback = function()
    -- print("What the hell is going on!!!")
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.colorcolumn = "80"
    -- vim.notify("C/C++ filetype detected")
    -- BUG:01 Intent to fix broken linewise comments in C
    -- vim.bo.commentstring = "//%s"
  end
})

-- PYTHON

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("python-type-file", { clear = true }),
  pattern = "*.py",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end
})

-- SHELLSCRIPT

vim.api.nvim_create_augroup("shellscripts-type", { clear = true })

local is_shell_script = function(filepath)
  local handle = io.popen("file --mime-type --brief " .. filepath, nil)
  local result = handle:read("*a")
  handle:close()
  return result:match("text/x%-shellscript")
end

local set_shellscript_opt = function()
  -- vim.cmd.colorscheme("catppuccin-mocha")
  vim.bo.filetype = "sh"
  vim.opt_local.tabstop = 4
  vim.opt_local.shiftwidth = 4
  vim.opt_local.expandtab = false
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "shellscripts-type",
  pattern = "*.sh",
  callback = function()
    set_shellscript_opt()
  end
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "shellscripts-type",
  pattern = "*",
  callback = function()
    local filepath = vim.fn.expand("<afile>", nil, nil)
    if filepath:match("%.") == nil and is_shell_script(filepath) then
      set_shellscript_opt()
    end
    -- vim.notify("Shellscript filetype detected")
  end
})
