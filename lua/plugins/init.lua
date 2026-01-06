--------------------------------------------------------------------------------
-- https://github.com/folke/lazy.nvim
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
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
	{ 'rcarriga/nvim-notify', lazy = false, priority = 1001 },

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

	-- Vim Wiki
	{
		'vimwiki/vimwiki',
		init = function()
			vim.g.vimwiki_list = {
				{
					path = '~/.vimwiki',
					syntax = 'markdown', -- default, markdown
					ext = '.md', -- wiki, md
				}
			}

			vim.g.vimwiki_global_ext = 0
		end
	},

	-- Bookmarks
	{
		'MattesGroeger/vim-bookmarks'
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
}

require("lazy").setup(plugins, opts)
