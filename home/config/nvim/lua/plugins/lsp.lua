return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      end,
    })

    -- LP - change so this is dynamic with the system language servers
    local servers = {
      "lua_ls",
      "html",
      "cssls",
      "basedpyright",
      "ts_ls",
      "clangd"
    }

    vim.diagnostic.config({ virtual_text = true })
    vim.lsp.config('basedpyright', {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "basic",
          },
        },
      },
    })
    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end

  end,
}
