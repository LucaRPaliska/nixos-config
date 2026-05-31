local builtin = require('telescope.builtin')

-- LP - Other Keymappings not listed:
-- Flash S

vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Explorer" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set({'n', 'v'}, 'y', '"+y') -- yank motion
vim.keymap.set({'n', 'v'}, 'Y', '"+Y') -- yank line

vim.keymap.set({'n', 'v'}, 'd', '"+d') -- delete motion
vim.keymap.set({'n', 'v'}, 'D', '"+D') -- delete line

vim.keymap.set('n', 'p', '"+p')  -- paste after cursor
vim.keymap.set('n', 'P', '"+P')  -- paste before cursor
