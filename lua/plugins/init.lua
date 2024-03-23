local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end

  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Colorcheme
  use 'ellisonleao/gruvbox.nvim'
  require('plugins.colorscheme')  

  -- File manager
  use 'nvim-tree/nvim-tree.lua'
  require('plugins.nvim-tree')

  -- Status line
  use 'nvim-lualine/lualine.nvim'
  -- Icons for the file manager
  use 'nvim-tree/nvim-web-devicons'
  require('plugins.lualine')

  -- Git
  use 'doronbehar/nvim-fugitive'
  require('plugins.nvim-fugitive')


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
