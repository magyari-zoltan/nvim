--------------------------------------------------------------------------------
-- https://github.com/folke/lazy.nvim
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- The `stdpath("data")` returns Neovim's data directory.
--
-- On Linux, for example: `~/.local/share/nvim`
-- This makes the `lazypath` value: `~/.local/share/nvim`
--
-- On windows: `C:\Users\<User>\AppData\Local\nvim`
-- This makes the `lazypath` value: `C:\Users\<User>\AppData\Local\nvim\lazy\lazy.nvim`
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

--------------------------------------------------------------------------------
-- `vim.uv` is Neovim's built-in access to the `libuv` library.
--
-- libuv is a low-level asynchronous I/O library that Neovim uses for many operations:
--
--  * file operations 📄
--  * network communication 🌐
--  * process management 📊
--  * timers ⏳
--  * filesystem watching 👀
--
-- `vim.loop` is Neovim's older libuv API.
--
-- Why `vim.uv or vim.loop` ?
--
-- This code is compatible with both.
--
-- Check whether the directory exists
--------------------------------------------------------------------------------
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    ----------------------------------------------------------------------------
    -- Download `lazy.nvim`
    --
    -- It executes the following command:
    --
    -- ```bash
    -- git clone \
    --    --filter=blob:none \
    --    --branch=stable \
    --    https://github.com/folke/lazy.nvim.git \
    --    ~/.local/share/nvim/lazy/lazy.nvim
    -- ```
    --
    -- What does `--filter=blob:none` mean?
    --
    -- Git does not download file contents immediately, only the required
    -- metadata.
    --
    -- ➡️ Faster cloning
    -- ➡️ Less network traffic
    --
    ----------------------------------------------------------------------------
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

--------------------------------------------------------------------------------
-- Add the plugin to the runtime path.
-- `rtp` is short for runtimepath.
--
-- Neovim loads these from here:
--  * plugins
--  * colorschemes
--  * Lua modules
--  * syntax files
--
-- prepend() puts the lazy.nvim directory at the beginning of the list:
--
-- ```text
-- runtimepath =
--     ~/.local/share/nvim/lazy/lazy.nvim
--     ...
-- ```
--------------------------------------------------------------------------------
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
local plugins = {
    -- Gruvbox colorscheme
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            executeCommand('set background=dark')
            executeCommand('colorscheme gruvbox')
        end
    },

    -- Paper colorscheme
    {
        'NLKNguyen/papercolor-theme',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        -- config = function()
        --   executeCommand('set background=light')
        --   executeCommand('colorscheme papercolor')
        -- end
    },

    -- Notify
    {
        'rcarriga/nvim-notify',
        lazy = false,
        priority = 1001,
        config = function()
            require('plugins.nvim-notify')
        end
    },

    -- File manager: nvim-tree
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false,
        config = function()
            require('plugins.nvim-tree')
        end
    },

    -- Status line & icons
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'gruvbox'
            },

            sections = {
                lualine_a = {
                    { 'filename', path = 1, }
                }
            }
        }
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('plugins.telescope')
        end
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        config = function()
            require('plugins.treesitter')
        end,
    },

    -- Git
    {
        'tpope/vim-fugitive',
        dependencies = {
            { 'sindrets/diffview.nvim' },
            { 'mhinz/vim-signify' },
            { 'junegunn/gv.vim' },
        },
        config = function()
            require('plugins.fugitive')
        end
    },

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {

            -- Lsp support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Lsp improvements
            { 'nvimdev/lspsaga.nvim' },
            { 'lukas-reineke/lsp-format.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'L3MON4D3/LuaSnip' },

            -- Debugging
            { 'mfussenegger/nvim-dap' },
            { 'mfussenegger/nvim-dap-ui' },

            -- Java language server
            { 'mfussenegger/nvim-jdtls' }
        },
        config = function()
            require('plugins.lsp-zero')
        end
    },

    -- OpenAI Codex
    {
        'kkrampis/codex.nvim',
        cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
        init = function()
            require('plugins.openai')
        end,
    },

    -- Github copilot
    {
        "github/copilot.vim",
        event = "InsertEnter",
        init = function()
            vim.g.copilot_enterprise_uri = "https://mercedes-benz.ghe.com"
        end,
    },

    -- CodeCompanion
    {
        'olimorris/codecompanion.nvim',
        cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionCLI', 'CodeCompanionCmd', 'CodeCompanionActions' },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'github/copilot.vim',
        },
        init = function()
            require('plugins.codecompanion')
        end,
    },

    -- Bookmarks
    {
        'MattesGroeger/vim-bookmarks'
    },

    -- Emmet
    {
        'mattn/emmet-vim',
        ft = {
            'html',
            'css',
            'javascriptreact',
            'typescriptreact',
            'javascript',
            'typescript',
            'vue',
            'svelte',
        },
        init = function()
            vim.g.user_emmet_expandabbr_key = '<C-e>'
        end,
    },

    -- Editor
    {
        'tpope/vim-surround',
        'tpope/vim-repeat'
    },

    -- StartupTime
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- Markdown format
    {
        "stevearc/conform.nvim",
        config = function()
            require('plugins.conform')
        end,
    },
}

--------------------------------------------------------------------------------
-- This line starts `lazy.nvim`.
--  * processes the plugin list,
--  * installs the missing plugins,
--  * configures the lazy loading rules,
--  * loads the required plugins.
--------------------------------------------------------------------------------
require("lazy").setup(plugins, {})
