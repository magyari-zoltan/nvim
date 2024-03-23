--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Alternative to escape char
vim.keymap.set('i', 'jj', '<ESC>', {noremap = true})

-- Save & Exit
vim.keymap.set('n', '<C-s>',     ':w<Enter>',                  {noremap = true})
vim.keymap.set('n', '<C-c>',     ':wq<Enter>',                 {noremap = true})
vim.keymap.set('n', '<C-x>',     ':q!<Enter>',                 {noremap = true})
vim.keymap.set('i', '<C-s>',     '<ESC>:w<Enter>',             {noremap = true})
vim.keymap.set('i', '<C-c>',     '<ESC>:wq<Enter>',            {noremap = true})
vim.keymap.set('i', '<C-x>',     '<ESC>:q!<Enter>',            {noremap = true})

-- No highligh
vim.keymap.set('n', '<leader>h', ':nohlsearch<Enter>',         {noremap = true, silent = true})

