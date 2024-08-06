return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "onsails/lspkind.nvim" },
  },
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    local cmp = require("cmp")
    cmp.setup {
      mapping = {
        ["<tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<s-tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end, { "i", "c" }),
        ["<cr>"] = cmp.mapping(function(fallback)
          if not (cmp.visible() and cmp.confirm { select = false }) then
            fallback()
          end
        end, { "i", "c" }),
        ["<esc>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.abort()
          else
            if vim.api.nvim_get_mode().mode == "i" then
              fallback()
            else
              vim.api.nvim_input("<c-\\><c-n>")
            end
          end
        end, { "i", "c" }),
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      },
      formatting = {
        format = require("lspkind").cmp_format {
          mode = "symbol",
          maxwidth = 50,
          ellipsis_char = "...",
        },
      },
      window = {
        completion = {
          border = "rounded",
        },
        documentation = {
          border = "rounded",
        },
      },
      performance = {
        debounce = 500,
      },
    }
    cmp.setup.cmdline({ "/", "?" }, {
      sources = {
        { name = "buffer" },
      },
    })
    cmp.setup.cmdline(":", {
      sources = {
        { name = "cmdline" },
        { name = "path" },
      },
    })
  end,
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        highlights = {
          CmpItemAbbr = { fg = 7 },
          CmpItemAbbrMatch = { fg = 5 },
          CmpItemAbbrMatchFuzzy = "CmpItemAbbrMatch",
          CmpItemKind = { fg = 4 },
        },
      },
    },
  },
}
