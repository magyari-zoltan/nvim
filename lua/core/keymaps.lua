--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------

vim.api.nvim_set_keymap('i', 'jj', '<ESC>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>h', ':nohlsearch<Enter>', {noremap = true, silent = true})
