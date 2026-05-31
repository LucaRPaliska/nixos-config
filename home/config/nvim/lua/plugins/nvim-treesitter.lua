return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      "bash",
      "json",
      "regex",
      "make",
      "sql",
      "python",
      "javascript",
      "java",
      "c",
      "c++",
      "rust",
      "html",
      "css",
      "lua"
    },
    highlight = {
      enable = true,
    },
  },
}
