return {
  {
    "nvim-lualine/lualine.nvim",

    opts = function(_, opts)
      ------------------------------------------------------------------
      -- Colors
      ------------------------------------------------------------------
      local colors = {
        red = "#ca1243",
        grey = "#a0a1a7",
        black = "#383a42",
        white = "#f3f3f3",
        light_green = "#83a598",
        orange = "#fe8019",
        green = "#8ec07c",
      }

      ------------------------------------------------------------------
      -- Theme (still supported)
      ------------------------------------------------------------------
      local theme = {
        normal = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.black, bg = colors.white },
          z = { fg = colors.white, bg = colors.black },
        },
        insert = { a = { fg = colors.black, bg = colors.light_green } },
        visual = { a = { fg = colors.black, bg = colors.orange } },
        replace = { a = { fg = colors.black, bg = colors.green } },
      }

      ------------------------------------------------------------------
      -- Empty spacer (modern replacement for lualine.component:extend)
      ------------------------------------------------------------------
      local empty = function()
        return ""
      end

      ------------------------------------------------------------------
      -- Section processor (unchanged logic, modern components)
      ------------------------------------------------------------------
      local function process_sections(sections)
        for name, section in pairs(sections) do
          local left = name:sub(9, 10) < "x"

          for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
            table.insert(section, pos * 2, {
              empty,
              color = { fg = colors.white, bg = colors.white },
            })
          end

          for id, comp in ipairs(section) do
            if type(comp) ~= "table" then
              section[id] = { comp }
              comp = section[id]
            end
            comp.separator = left and { right = "" } or { left = "" }
          end
        end
        return sections
      end

      ------------------------------------------------------------------
      -- Components
      ------------------------------------------------------------------
      local function search_result()
        if vim.v.hlsearch == 0 then
          return ""
        end
        local last = vim.fn.getreg("/")
        if last == "" then
          return ""
        end
        local sc = vim.fn.searchcount({ maxcount = 9999 })
        return string.format("%s(%d/%d)", last, sc.current, sc.total)
      end

      local function modified()
        if vim.bo.modified then
          return "+"
        elseif not vim.bo.modifiable or vim.bo.readonly then
          return "-"
        end
        return ""
      end

      ------------------------------------------------------------------
      -- Apply to LazyVim opts
      ------------------------------------------------------------------
      opts.options = {
        theme = theme,
        component_separators = "",
        section_separators = { left = "", right = "" },
      }

      opts.sections = process_sections({
        lualine_a = { "mode" },

        lualine_b = {
          "branch",
          "diff",

          {
            "diagnostics",
            sections = { "error" },
            diagnostics_color = {
              error = { bg = colors.red, fg = colors.white },
            },
          },
          {
            "diagnostics",
            sections = { "warn" },
            diagnostics_color = {
              warn = { bg = colors.orange, fg = colors.white },
            },
          },

          { "filename", file_status = false, path = 1 },
          { modified, color = { bg = colors.red } },

          { "%w", cond = function() return vim.wo.previewwindow end },
          { "%r", cond = function() return vim.bo.readonly end },
          { "%q", cond = function() return vim.bo.buftype == "quickfix" end },
        },

        lualine_c = {},
        lualine_x = {},
        lualine_y = { search_result, "filetype" },
        lualine_z = { "%l:%c", "%p%%/%L" },
      })

      opts.inactive_sections = {
        lualine_c = { "%f %y %m" },
        lualine_x = {},
      }
    end,
  },
}
