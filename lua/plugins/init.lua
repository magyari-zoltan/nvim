--------------------------------------------------------------------------------
-- https://github.com/folke/lazy.nvim
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- A `stdpath("data")` visszaadja a Neovim adatkönyvtárát.
-- Linux alatt pl: `~/.local/share/nvim`
-- Így a `lazypath` értéke: `~/.local/share/nvim`
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

--------------------------------------------------------------------------------
-- A `vim.uv` a Neovim beépített hozzáférése a `libuv` könyvtárhoz.
--
-- A libuv egy alacsony szintű aszinkron I/O könyvtár, amelyet a Neovim számos művelethez használ:
--
--  * fájlműveletek 📄
--  * hálózati kommunikáció 🌐
--  * folyamatkezelés ⚙️
--  * időzítők ⏱️
--  * fájlrendszer figyelése 👀
--
-- A `vim.loop` a Neovim régebbi libuv API-ja.
--
-- Miért `vim.uv or vim.loop` ?
--
-- Ez a kód mindkettővel kompatibilis.
--
-- Ellenőrzöm, hogy létezik-e a könyvtár
--------------------------------------------------------------------------------
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	----------------------------------------------------------------------------
	-- A `lazy.nvim` letöltése
	--
	-- A következő parancsot hajtja végre:
	--
	-- ```bash
	-- git clone \
	--    --filter=blob:none \
	--    --branch=stable \
	--    https://github.com/folke/lazy.nvim.git \
	--    ~/.local/share/nvim/lazy/lazy.nvim
	-- ```
	--
	-- Mit jelent a `--filter=blob:none` ?
	--
	-- A Git nem tölti le azonnal a fájlok tartalmát, csak a szükséges
	-- metaadatokat.
	--
	-- ➡️ Gyorsabb klónozás
	-- ➡️ Kevesebb hálózati forgalom
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
-- A plugin hozzáadása a runtime path-hoz.
-- A `rtp` a runtimepath rövidítése.
--
-- A Neovim innen tölti be:
--  * pluginokat
--  * színsémákat
--  * Lua modulokat
--  * szintaxisfájloka
--
-- A prepend() a lista elejére teszi a lazy.nvim könyvtárát:
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
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			executeCommand('set background=dark')
			executeCommand('colorscheme gruvbox')
		end
	},

	-- Paper colorscheme
	{
		'NLKNguyen/papercolor-theme',
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
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
				toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
				quit = '<C-q>', -- Keybind to close the Codex window (default: Ctrl + q)
			},              -- Disable internal default keymap (<leader>cc -> :CodexToggle)
			border      = 'rounded', -- Options: 'single', 'double', or 'rounded'
			width       = 0.8, -- Width of the floating window (0.0 to 1.0)
			height      = 0.8, -- Height of the floating window (0.0 to 1.0)
			model       = nil, -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
			autoinstall = true, -- Automatically install the Codex CLI if not found
			panel       = false, -- Open Codex in a side-panel (vertical split) instead of floating window
			use_buffer  = false, -- Capture Codex stdout into a normal buffer instead of a terminal buffer
		},
	},

	-- Github copilot
	{
		"github/copilot.vim",
		event = "InsertEnter",
		init = function()
			vim.g.copilot_settings = vim.tbl_deep_extend("force", vim.g.copilot_settings or {}, {
				model = "auto",
			})
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
-- Ez a sor indítja el a `lazy.nvim`-et.
--
-- A `require("lazy") betölti a `lazy.nvim` Lua modulját.
--
-- A `require(...)` a runtimepath-on keresi a modult. Ezért volt fontos
-- korábban ez a sor: `vim.opt.rtp:prepend(lazypath)`
--
-- A `.setup(...)` a betöltött modul setup() függvényét hívja meg:
--
-- ```lua
--   local lazy = require("lazy")
--   lazy.setup(plugins, opts)
-- ```
--
-- Ez:
--  * feldolgozza a plugin listát,
--  * telepíti a hiányzó pluginokat,
--  * beállítja a lazy loading szabályokat,
--  * betölti a szükséges pluginokat.
--------------------------------------------------------------------------------
require("lazy").setup(plugins, opts)
