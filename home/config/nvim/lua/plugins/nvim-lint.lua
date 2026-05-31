-- NOTE (NixOS): Linters must be installed via home-manager, not mason.
-- eslint_d (js/ts), pylint or ruff (python), luacheck (lua)
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "pylint" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      lua = { "luacheck" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if not linters then return end
        local available = vim.tbl_filter(function(name)
          return vim.fn.executable(lint.linters[name] and lint.linters[name].cmd or name) == 1
        end, linters)
        if #available > 0 then
          lint.try_lint(available)
        end
      end,
    })
  end,
}
