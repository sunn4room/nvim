return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      vim = true,
      vimdoc = true,
      lua = true,
      bash = true,
      markdown = true,
      markdown_inline = true,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.install").prefer_git = true
    local configs = require("nvim-treesitter.parsers").get_parser_configs()
    local ensure_installed = {}
    for k, v in pairs(opts.ensure_installed) do
      if type(v) == "string" then
        table.insert(ensure_installed, k)
        configs[k].install_info.url = v
      elseif v then
        table.insert(ensure_installed, k)
        configs[k].install_info.url = configs[k].install_info.url:gsub("https://github.com/", GHPROXY .. "https://github.com/")
      end
    end
    opts.ensure_installed = ensure_installed
    require("nvim-treesitter.configs").setup(opts)
  end,
}

