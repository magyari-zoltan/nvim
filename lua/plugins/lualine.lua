local function setupPlugin()
  require('lualine').setup {

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
end

local function errorHandler(error)
  vim.notify('Lualine plugin could not be loaded!')
  vim.notify(error)
end

tryCatch(setupPlugin, errorHandler)
