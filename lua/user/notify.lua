local min_level = 2
local nlevel = -1
local ntime = 0
local s2n = {
  [0] = 0,
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 4,
  TRACE = 0,
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4,
}
local n2s = {
  [0] = "TRACE",
  [1] = "DEBUG",
  [2] = "INFO",
  [3] = "WARN",
  [4] = "ERROR",
}
local s2h = {
  TRACE = "TraceMsg",
  DEBUG = "DebugMsg",
  INFO = "InfoMsg",
  WARN = "WarnMsg",
  ERROR = "ErrorMsg",
}

return {
  "rcarriga/nvim-notify",
  init = function()
    vim.notify_origin = vim.notify
    vim.notify = function(m, l, o)
      local ok, notify = pcall(require, "notify")
      if ok then
        vim.notify = function(m, l, o)
          local level = s2n[l or 2]
          if level > nlevel then
            nlevel = level
            vim.cmd [[doautocmd User NotificationsLevel]]
          end
          return notify(m, l, o)
        end
      else
        vim.notify = vim.notify_origin
      end
      return vim.notify(m, l, o)
    end
  end,
  lazy = true,
  opts = {
    level = min_level,
    max_width = function()
      return math.floor(vim.o.columns * 0.5)
    end,
    max_height = function()
      return math.floor(vim.o.lines * 0.25)
    end,
    minimum_width = 40,
    stages = "static",
    render = "default",
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "",
    },
  },
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<cr>n"] = { desc = "show notifications", callback = function()
              local output = {}
              for _, r in ipairs(require("notify").history()) do
                if r.time > ntime then
                  table.insert(output, { r.title[2], "MoreMsg" })
                  table.insert(output, { " ", "MsgArea" })
                  table.insert(output, { r.level, s2h[r.level] })
                  table.insert(output, { " ", "MsgArea" })
                  table.insert(output, { r.title[1] .. "\n", "TitleMsg" })
                  for _, line in ipairs(r.message) do
                    table.insert(output, { line .. "\n", "MsgArea" })
                  end
                  ntime = r.time
                end
              end
              nlevel = -1
              vim.cmd [[doautocmd User NotificationsLevel]]
              vim.api.nvim_echo(output, true, {})
            end },
            ["<cr>N"] = { desc = "show all notifications", callback = function()
              local output = {}
              for _, r in ipairs(require("notify").history()) do
                table.insert(output, { r.title[2], "MoreMsg" })
                table.insert(output, { " ", "MsgArea" })
                table.insert(output, { r.level, s2h[r.level] })
                table.insert(output, { " ", "MsgArea" })
                table.insert(output, { r.title[1] .. "\n", "TitleMsg" })
                for _, line in ipairs(r.message) do
                  table.insert(output, { line .. "\n", "MsgArea" })
                end
              end
              vim.api.nvim_echo(output, true, {})
            end },
          },
        },
        highlights = {
          NotifyERRORBorder = { fg = 1, bold = true },
          NotifyWARNBorder = { fg = 3, bold = true },
          NotifyINFOBorder = { fg = 2, bold = true },
          NotifyERRORIcon = { fg = 1, bold = true },
          NotifyWARNIcon = { fg = 3, bold = true },
          NotifyINFOIcon = { fg = 2, bold = true },
          NotifyERRORTitle = { fg = 1, bold = true },
          NotifyWARNTitle = { fg = 3, bold = true },
          NotifyINFOTitle = { fg = 2, bold = true },
        },
      },
    },
    {
      "rebelot/heirline.nvim",
      opts = {
        notify = {
          update = {
            "User",
            pattern = "NotificationsLevel",
            callback = function()
              vim.schedule(vim.cmd.redrawtabline)
            end,
          },
          condition = function()
            return nlevel >= min_level
          end,
          provider = function()
            return " 󰌵 "
          end,
          hl = function()
            if nlevel == 0 then
              return "LineTrace"
            elseif nlevel == 1 then
              return "LineDebug"
            elseif nlevel == 2 then
              return "LineInfo"
            elseif nlevel == 3 then
              return "LineWarn"
            elseif nlevel == 4 then
              return "LineError"
            end
          end,
        },
      },
    },
  },
}
