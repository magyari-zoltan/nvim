--------------------------------------------------
-- Private methods
--------------------------------------------------
local function setColorscheme(colorscheme)
  executeCommand("colorscheme " .. colorscheme)
end

local function errorHandler(error)
  notify('Colorscheme could not be loaded!', WARN)
  notify(error, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setColorscheme, errorHandler, 'gruvbox')
--------------------------------------------------
