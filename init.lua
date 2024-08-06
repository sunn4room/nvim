GHPROXY = "https://mirror.ghproxy.com/"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local quit_on_error = function(error)
    vim.fn.system { "rm", "-rf", lazypath }
    vim.api.nvim_echo({
      { error .. "\n", "ErrorMsg" },
      { "Press any key to exit...", "MoreMsg" }
    }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
  local lazylock = nil
  local lazylockfile = io.open(vim.fn.stdpath "config" .. "/lazy-lock.json", "r")
  if lazylockfile then
    lazylock = vim.json.decode(lazylockfile:read("*all"))
    lazylockfile:close()
  end
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=main",
    GHPROXY .. "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
  if vim.v.shell_error == 0 then
    if lazylock then
      vim.fn.system { "git", "-C", lazypath, "checkout", lazylock["lazy.nvim"]["commit"] }
      if vim.v.shell_error ~= 0 then
        quit_on_error("Failed to checkout lazy.nvim")
      end
    end
  else
    quit_on_error("Failed to clone lazy.nvim")
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = { import = "user" },
  git = {
    url_format = GHPROXY .. "https://github.com/%s.git",
  },
  install = {
    colorscheme = { "default" },
  },
  ui = {
    border = "rounded",
  },
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
