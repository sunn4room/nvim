return {
  "hadronized/hop.nvim",
  cmd = "HopChar1",
  opts = {},
  specs = {
    {
      "common.nvim",
      opts = {
        mappings = {
          nxo = {
            s = { command = "<cmd>HopChar1<cr>", desc = "motion" },
          },
        },
        highlights = {
          HopNextKey = { fg = 6, bold = true },
          HopNextKey1 = { fg = 5, bold = true },
          HopNextKey2 = { fg = 4, bold = true },
          HopUnmatched = { fg = 8 },
        },
      },
    },
  },
}

