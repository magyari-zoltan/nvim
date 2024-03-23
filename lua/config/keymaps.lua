-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("i", "jj", "<ESC>")

-- Save & exit
keymap.set("i", "<C-s>", "<ESC>:w<Enter>")
keymap.set("i", "<C-x>", "<ESC>:q!<Enter>")
keymap.set("i", "<C-c>", "<ESC>:wq!<Enter>")
keymap.set("n", "<C-s>", ":w<Enter>")
keymap.set("n", "<C-x>", ":q!<Enter>")
keymap.set("n", "<C-c>", ":wq!<Enter>")

-- Delete a word backwards
-- keymap.set("n", "dw", "bv_d")

-- New tab
keymap.set("n", "<C-w>t", ":tabedit<Enter>", opts)
keymap.set("n", "<tab>", ":tabnext<Enter>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Enter>", opts)

-- Split window
keymap.set("n", "ss", "split<Enter>", opts)
keymap.set("n", "sv", "vsplit<Enter>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sl", "<C-w>l", opts)

-- Resize window
keymap.set("n", "<C-left>", "<C-w>>", opts)
keymap.set("n", "<C-right>", "<C-w><", opts)
keymap.set("n", "<C-up>", "<C-w>+", opts)
keymap.set("n", "<C-down>", "<C-w>-", opts)

-- Diagnostics
-- keymap.set("n", "<C-n>", function()
--  vim.diagnostic.goto_next()
-- end, opts)
