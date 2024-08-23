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

  -- Vim Wiki
  {
    'vimwiki/vimwiki',
    init = function()
      vim.g.vimwiki_list = {
        {
          path = '~/.vimwiki',
          syntax = 'markdown', -- default, markdown
          ext = '.md',         -- wiki, md
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
