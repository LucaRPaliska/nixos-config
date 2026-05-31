return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  opts = {
    delay = 200,
    large_file_cutoff = 2000,
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}
