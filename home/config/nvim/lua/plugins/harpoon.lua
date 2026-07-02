return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },

    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      -- telescope integration
      local conf = require("telescope.config").values

      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      vim.keymap.set("n", "<C-e>", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open Harpoon window" })

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-y>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-u>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)

      vim.keymap.set("n", "<leader>r", function() harpoon:list():remove() end, { desc = "Remove file from Harpoon" })
      vim.keymap.set("n", "<leader>1", function() harpoon:list():replace_at(1) end, { desc = "Set file to Harpoon slot 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():replace_at(2) end, { desc = "Set file to Harpoon slot 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():replace_at(3) end, { desc = "Set file to Harpoon slot 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():replace_at(4) end, { desc = "Set file to Harpoon slot 4" })

    end,
  },
}
