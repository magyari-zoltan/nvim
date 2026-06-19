--------------------------------------------------------------------------------
-- https://github.com/folke/lazy.nvim
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- `stdpath("data")` returns Neovim's data directory.
-- On Linux, for example: `~/.local/share/nvim`
-- This makes the `lazypath` value: `~/.local/share/nvim`
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local copilot_model = "gpt-5-mini"

--------------------------------------------------------------------------------
-- `vim.uv` is Neovim's built-in access to the `libuv` library.
--
-- libuv is a low-level asynchronous I/O library that Neovim uses for many operations:
--
--  * file operations 📄
--  * network communication 🌐
--  * process management ⚙️
--  * timers ⏱️
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
        lazy = true,
        cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
        keys = {
            {
                '<leader>cc', -- Change this to your preferred keybinding
                function() require('codex').toggle() end,
                desc = 'Toggle Codex popup or side-panel',
                mode = { 'n', 't' }
            },
        },
        opts = {
            keymaps     = {
                toggle = nil,          -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
                quit = '<C-q>',        -- Keybind to close the Codex window (default: Ctrl + q)
            },                         -- Disable internal default keymap (<leader>cc -> :CodexToggle)
            border      = 'rounded',   -- Options: 'single', 'double', or 'rounded'
            width       = 0.8,         -- Width of the floating window (0.0 to 1.0)
            height      = 0.8,         -- Height of the floating window (0.0 to 1.0)
            cmd         = { 'codex' }, -- Start each Codex chat in normal mode
            model       = nil,         -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
            autoinstall = true,        -- Automatically install the Codex CLI if not found
            panel       = false,       -- Open Codex in a side-panel (vertical split) instead of floating window
            use_buffer  = false,       -- Capture Codex stdout into a normal buffer instead of a terminal buffer
        },
    },

    -- Github copilot
    {
        "github/copilot.vim",
        event = "InsertEnter",
        init = function()
            vim.g.copilot_enterprise_uri = "https://mercedes-benz.ghe.com"
            vim.g.copilot_settings = vim.tbl_deep_extend("force",
                vim.g.copilot_settings or {}, {
                    model = copilot_model,
                })
        end,
        config = function()
            vim.cmd.Copilot("setup")
            vim.cmd.Copilot("enable")
        end,
    },

    -- Copilot Chat
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = { "github/copilot.vim", "nvim-lua/plenary.nvim" },
        cmd = {
            "CopilotChat",
            "CopilotChatOpen",
            "CopilotChatClose",
            "CopilotChatToggle",
            "CopilotChatReset",
            "CopilotChatStop",
            "CopilotChatSave",
            "CopilotChatLoad",
            "CopilotChatModels",
            "CopilotChatAgents",
            "CopilotChatPrompts",
            "CopilotChatExplain",
            "CopilotChatReview",
            "CopilotChatFix",
            "CopilotChatOptimize",
            "CopilotChatDocs",
            "CopilotChatTests",
            "CopilotChatCommit",
            "CopilotChatCommitStaged",
        },
        keys = {
            { "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
            { "<leader>cr", "<cmd>CopilotChatReset<cr>",  desc = "Reset Copilot Chat" },
        },
        opts = {
            model = copilot_model,
            tools = {
                "file",
                "glob",
                "grep",
                "bash",
                "git",
                "gitdiff"
            },
            resources = {
                "buffer:listed",
                "glob",
            },
        },
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
--
-- `require("lazy") loads the `lazy.nvim` Lua module.
--
-- `require(...)` looks for the module on the runtimepath. That is why this
-- earlier line was important: `vim.opt.rtp:prepend(lazypath)`
--
-- `.setup(...)` calls the setup() function on the loaded module:
--
-- ```lua
--   local lazy = require("lazy")
--   lazy.setup(plugins, opts)
-- ```
--
-- This:
--  * processes the plugin list,
--  * installs the missing plugins,
--  * configures the lazy loading rules,
--  * loads the required plugins.
--------------------------------------------------------------------------------
require("lazy").setup(plugins, opts)
