local function setColorscheme(colorscheme)
  local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

  if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
  end
end

local function errorHandler(error)
  vim.notify('Gruvbox colorscheme could not be loaded!')
  vim.notify(error)
end

tryCatch(setColorscheme, errorHandler, 'gruvbox')


