local make_list = function(
  get_list, item_comp, left_comp, right_comp, limit
)
  local max = (limit + 1) * 2 + 1
  return {
    init = function(self)
      for i = 1, #self do
        self[i] = nil
      end
      local list, current = get_list()
      if #list == 0 then return end
      local lfdsfdsfeft, right
      if #list <= max then
        left = 1
        right = #list
      else
        left = current - limit - 1
        right = current + limit + 1
        if left < 1 then
          left = 1
          right = left + max - 1
        elseif right > #list then
          right = #list
          left = right - max + 1
        end
      end
      for i = left, right do
        if i ~= left and i ~= right then
          table.insert(self, self:new(item_comp))
          self[#self].item = list[i]
          self[#self].is_active = (current == i)
        elseif i == left then
          if i == 1 then
            table.insert(self, self:new(item_comp))
            self[#self].item = list[i]
            self[#self].is_active = (current == i)
          else
            local items = {}
            for j = 1, left do
              table.insert(items, list[j])
            end
            table.insert(self, self:new(left_comp))
            self[#self].items = items
          end
        elseif i == right then
          if i == #list then
            table.insert(self, self:new(item_comp))
            self[#self].item = list[i]
            self[#self].is_active = (current == i)
          else
            local items = {}
            for j = right, #list do
              table.insert(items, list[j])
            end
            table.insert(self, self:new(right_comp))
            self[#self].items = items
          end
        end
      end
    end,
  }
end

return {
  "rebelot/heirline.nvim",
  opts = {
    empty = { provider = "" },
    cut = { provider = "%<" },
    align = { provider = "%=" },
    filename = {
      init = function(self)
        self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
      end,
      provider = function(self)
        if self.filename == "" then
          return " 󰈔 Unnamed "
        else
          return " 󰈔 " .. self.filename .. " "
        end
      end,
      hl = function(self)
        if self.filename == "" then
          if vim.bo.modified then
            return "LineInfoItalic"
          else
            return "LineNormalItalic"
          end
        elseif not vim.bo.modifiable or vim.bo.readonly then
          return "LineWarn"
        elseif vim.bo.modified then
          return "LineInfo"
        else
          return "LineNormal"
        end
      end,
    },
    position = { provider = " 󰀚 %l/%L:%c " },
    cwd = {
      provider = function()
        return " 󰝰 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~") .. " "
      end,
    },
    git = {
      condition = function()
        vim.fn.system { "git", "rev-parse", "--is-inside-work-tree" }
        return vim.v.shell_error == 0
      end,
      provider = function()
        local branch = vim.fn.system { "git", "branch", "--show-current" }
        if branch == "" then
          branch = vim.fn.system { "git", "rev-parse", "--short", "HEAD" }
        end
        return " 󰘬 " .. branch:sub(1, -2) .. " "
      end,
      hl = function()
        if vim.fn.system { "git", "status", "-s" } == "" then
          return "LineInfo"
        else
          return "LineError"
        end
      end,
    },
    bufferlist = { { provider = " 󰈢" }, make_list(
      function()
        local list = {}
        for _, i in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_option(i, "buflisted") then
            table.insert(list, i)
          end
        end
        local current = nil
        for j, i in ipairs(list) do
          if i == tonumber(vim.g.actual_curbuf) then
            current = j
            break
          end
        end
        return list, current
      end,
      {
        provider = function(self)
          return (" %d"):format(self.item)
        end,
        hl = function(self)
          if self.is_active then
            return "LineNormal"
          elseif vim.bo[self.item].modified then
            return "LineInfo"
          else
            return "LineTrace"
          end
        end,
      },
      {
        provider = " <",
        hl = function(self)
          for _, i in ipairs(self.items) do
            if vim.bo[i].modified then
              return "LineInfo"
            end
          end
          return "LineTrace"
        end,
      },
      {
        provider = " >",
        hl = function(self)
          for _, i in ipairs(self.items) do
            if vim.bo[i].modified then
              return "LineInfo"
            end
          end
          return "LineTrace"
        end,
      },
      3
    ), { provider = " " } },
    tablist = { { provider = " 󰌨 " }, make_list(
      function()
        local list = {}
        local current = nil
        for i, t in ipairs(vim.api.nvim_list_tabpages()) do
          table.insert(list, vim.api.nvim_tabpage_get_number(t))
          if t == vim.api.nvim_get_current_tabpage() then
            current = i
          end
        end
        return list, current
      end,
      {
        provider = function(self)
          return ("%d "):format(self.item)
        end,
        hl = function(self)
          if not self.is_active then
            return "LineTrace"
          else
            return "LineNormal"
          end
        end,
      },
      { provider = "< ", hl = "LineTrace" },
      { provider = "> ", hl = "LineTrace" },
      1
    )},
  },
  config = function(_, opts)
    require("heirline").setup {
      tabline = {
        opts.cut,
        opts.cwd,
        opts.git,
        opts.bufferlist,
        opts.align,
        opts.progress or opts.empty,
        opts.notify or opts.empty,
        opts.tablist,
      },
      statusline = {
        opts.cut,
        opts.filename,
        opts.align,
        opts.diff or opts.empty,
        opts.lsp or opts.empty,
        opts.diagnostic or opts.empty,
        opts.position,
      },
    }
  end,
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        highlights = {
          LineNormal = { fg = 15, bg = 8, bold = true },
          LineSpecial = { fg = 13, bg = 8, bold = true },
          LineTrace = { fg = 12, bg = 8, bold = true },
          LineDebug = { fg = 14, bg = 8, bold = true },
          LineInfo = { fg = 10, bg = 8, bold = true },
          LineWarn = { fg = 11, bg = 8, bold = true },
          LineError = { fg = 9, bg = 8, bold = true },
          LineNormalItalic = { fg = 15, bg = 8, bold = true, italic = true },
          LineSpecialItalic = { fg = 13, bg = 8, bold = true, italic = true },
          LineTraceItalic = { fg = 12, bg = 8, bold = true, italic = true },
          LineDebugItalic = { fg = 14, bg = 8, bold = true, italic = true },
          LineInfoItalic = { fg = 10, bg = 8, bold = true, italic = true },
          LineWarnItalic = { fg = 11, bg = 8, bold = true, italic = true },
          LineErrorItalic = { fg = 9, bg = 8, bold = true, italic = true },
        },
      },
    },
  },
}
