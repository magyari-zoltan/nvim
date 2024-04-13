local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end

  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  ------------------------------------------------------------------------------
  -- Plugin manager
  use 'wbthomason/packer.nvim'

  ------------------------------------------------------------------------------
  -- Notification
  use 'rcarriga/nvim-notify'
  require('plugins.nvim-notify')

  ------------------------------------------------------------------------------
  -- Colorcheme
  use 'ellisonleao/gruvbox.nvim'
  require('plugins.colorscheme')

  ------------------------------------------------------------------------------
  -- File manager
  use 'nvim-tree/nvim-tree.lua'
  require('plugins.nvim-tree')

  ------------------------------------------------------------------------------
  -- Status line & icons for the file manager
  use {
    'nvim-lualine/lualine.nvim',

    requires = { 'nvim-tree/nvim-web-devicons' }
  }
  require('plugins.lualine')

  ------------------------------------------------------------------------------
  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',

    requires = { 'nvim-lua/plenary.nvim' }
  }
  require('plugins.telescope')

  ------------------------------------------------------------------------------
  -- Git
  use { 'NeogitOrg/neogit',

    requires = {
      { 'sindrets/diffview.nvim' },
      { 'mhinz/vim-signify' },
      { 'tpope/vim-fugitive' },
      { 'junegunn/gv.vim' },

      -- Telescope
      { 'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
      }
    },
  }
  require('plugins.neogit')

  ------------------------------------------------------------------------------
  -- Lsp
  use { 'VonHeikemen/lsp-zero.nvim',

    requires = {

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
    }
  }
  require('plugins.lsp-zero')

  ------------------------------------------------------------------------------
  -- Bookmarks
  use 'MattesGroeger/vim-bookmarks'

  ------------------------------------------------------------------------------
  -- Editor
  use {
    'tpope/vim-surround',
    'tpope/vim-repeat'
  }

  ------------------------------------------------------------------------------
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
