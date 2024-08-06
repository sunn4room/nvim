return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  init = function()
    vim.ui.select_origin = vim.ui.select
    vim.ui.select = function(items, opts, on_choice)
      local ok, fzf_lua = pcall(require, "fzf-lua")
      if ok then
        fzf_lua.register_ui_select()
      else
        vim.ui.select = vim.ui.select_origin
      end
      return vim.ui.select(items, opts, on_choice)
    end
  end,
  opts = {
    winopts = {
      split = "tabnew",
      preview = {
        layout = "vertical",
      },
    },
  },
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<space><space>"] = { command = ":FzfLua ", desc = "find ..." },
            ["<space>b"] = { command = "<cmd>FzfLua buffers<cr>", desc = "find buffer" },
            ["<space>f"] = { command = "<cmd>FzfLua files<cr>", desc = "find file" },
            ["<space>w"] = { command = "<cmd>FzfLua live_grep<cr>", desc = "find word" },
            ["<space>h"] = { command = "<cmd>FzfLua helptags<cr>", desc = "find help" },
          },
        },
      },
    },
  },
}
