--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
local Window = require('core.window')
local dockCurrentWindowToBottom = Window.dockCurrentWindowToBottom

-- Leader key
vim.g.mapleader = '-'
vim.g.maplocalleader = '-'

-- Alternative to escape char
vim.keymap.set('i', 'jj', '<ESC>', { noremap = true })

-- Editor
vim.keymap.set('n', '<Leader>w', ':set nowrap<Enter>', { noremap = true })
vim.keymap.set('n', '<Leader>h', ':nohlsearch<Enter>', { noremap = true, silent = true })

-- Save & Exit
vim.keymap.set('n', '<C-s>', ':w<Enter>', { noremap = true })
vim.keymap.set('n', '<C-c>', ':wq<Enter>', { noremap = true })
vim.keymap.set('n', '<C-x>', ':q!<Enter>', { noremap = true })
vim.keymap.set('i', '<C-s>', '<ESC>:w<Enter>', { noremap = true })
vim.keymap.set('i', '<C-c>', '<ESC>:wq<Enter>', { noremap = true })
vim.keymap.set('i', '<C-x>', '<ESC>:q!<Enter>', { noremap = true })

-- Window movements
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })
vim.keymap.set('i', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('i', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('i', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('i', '<C-l>', '<C-w>l', { noremap = true })

-- Source
vim.keymap.set('n', '%%', ':source %<Enter>', { noremap = true })

-- Find
-- vim.keymap.set('n', '<leader>fb',':buffer ',                                    { noremap = true })

-- Terminal
local function openTerminalWindow()
  executeCommand('split')
  dockCurrentWindowToBottom(10)
  executeCommand('terminal')
end

vim.keymap.set('n', '<C-t>', openTerminalWindow, { noremap = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true })
