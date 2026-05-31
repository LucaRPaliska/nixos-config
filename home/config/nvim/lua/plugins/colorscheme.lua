return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,      -- load immediately
    priority = 1000,   -- load before other UI plugins
    config = function()
      vim.opt.background = "dark"
      vim.cmd("colorscheme oxocarbon")

      -- optional: transparent background
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

      local palette = require("oxocarbon").oxocarbon

      vim.api.nvim_set_hl(0, "LineNr", {
        fg = palette.base03,
        bg = "#000000"
      })

      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ee5296", bold = true })
      vim.api.nvim_set_hl(0, "LineNr", { fg = palette.base03, bg = "#000000" })
    end,
  },
}
