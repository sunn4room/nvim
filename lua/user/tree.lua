return {
  "nvim-tree/nvim-tree.lua",
  cmd = "NvimTreeFindFile",
  opts = {
    on_attach = function(bn)
      local api = require("nvim-tree.api")
      local set = function(k, a, d)
        vim.keymap.set("n", k, a, {
          desc = "nvim-tree: " .. d,
          buffer = bn,
          noremap = true,
          silent = true,
          nowait = true,
        })
      end
      set("?", api.tree.toggle_help, "help")
      set("q", api.tree.close, "quit")
      set("s", api.node.show_info_popup, "stat")
      set("h", api.node.navigate.parent_close, "close")
      set("l", api.node.open.edit, "open")
      set("a", api.fs.create, "new")
      set("r", api.fs.rename, "rename")
      set("d", api.fs.remove, "delete")
    end,
    sync_root_with_cwd = true,
    view = {
      side = "right",
      signcolumn = "no",
    },
    renderer = {
      root_folder_label = false,
      icons = {
        show = {
          git = false,
          modified = false,
          diagnostics = false,
        },
        glyphs = {
          folder = {
            arrow_closed = " ",
            arrow_open = " ",
          },
        },
      },
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
  },
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<cr>f"] = { command = "<cmd>NvimTreeFindFile<cr>", desc = "explore" },
          },
        },
        highlights = {
          Directory = { fg = 4 },
        },
      },
    },
  },
}
