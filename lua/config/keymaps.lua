--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
local Window = require('core.window')
local dockCurrentWindowToBottom = Window.dockCurrentWindowToBottom
local dockCurrentWindowToRightSide = Window.dockCurrentWindowToRightSide

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
vim.keymap.set('t', '<C-x>', '<C-\\><C-n>:q!<Enter>', { noremap = true })

-- Window movements
vim.keymap.set('n', '<M-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<M-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<M-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<M-l>', '<C-w>l', { noremap = true })
vim.keymap.set('i', '<M-h>', '<C-w>h', { noremap = true })
vim.keymap.set('i', '<M-j>', '<C-w>j', { noremap = true })
vim.keymap.set('i', '<M-k>', '<C-w>k', { noremap = true })
vim.keymap.set('i', '<M-l>', '<C-w>l', { noremap = true })

-- Source
vim.keymap.set('n', '%%', ':source %<Enter>', { noremap = true })

--------------------------------------------------------------------------------
--- Terminal keybingins
--------------------------------------------------------------------------------

-- Terminal
local function openTerminalWindow()
    executeCommand('split')
    dockCurrentWindowToBottom(7)
    executeCommand('terminal')
end

local function openTerminalWindowRight()
    executeCommand('vsplit')
    -- dockCurrentWindowToRightSide(80)
    executeCommand('terminal')
end

local function openCopilotTerminalWindow()
    executeCommand('vsplit')
    executeCommand('terminal copilot')
    executeCommand('startinsert')
end

local function openCodexTerminalWindow()
    executeCommand('vsplit')
    executeCommand('terminal codex')
    executeCommand('startinsert')
end

local function openClaudeTerminalWindow()
    executeCommand('vsplit')
    executeCommand('terminal claude')
    executeCommand('startinsert')
end

-- Opening terminal
vim.keymap.set('n', '<M-t>', openTerminalWindow, { noremap = true })
vim.keymap.set('n', '<M-S-t>', openTerminalWindowRight, { noremap = true })

-- Escaping terminl
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<Esc><Esc>', '<Esc>', { noremap = true })

-- Navigation inside a terminal
vim.keymap.set('t', '<M-h>', '<C-\\><C-n><C-w>h', { noremap = true })
vim.keymap.set('t', '<M-j>', '<C-\\><C-n><C-w>j', { noremap = true })
vim.keymap.set('t', '<M-k>', '<C-\\><C-n><C-w>k', { noremap = true })
vim.keymap.set('t', '<M-l>', '<C-\\><C-n><C-w>l', { noremap = true })

--------------------------------------------------------------------------------
--- Copilot keybingins
--------------------------------------------------------------------------------

vim.keymap.set('n', '<leader>cp', openCopilotTerminalWindow, { noremap = true })
vim.keymap.set('n', '<leader>cd', openCodexTerminalWindow, { noremap = true })
vim.keymap.set('n', '<leader>cl', openClaudeTerminalWindow, { noremap = true })
