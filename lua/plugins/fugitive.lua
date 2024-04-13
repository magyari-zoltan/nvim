--------------------------------------------------
-- Dependencies
--------------------------------------------------
local Window = require('core.window')
require('core.winkeymaps').setup()
--------------------------------------------------

--------------------------------------------------
-- Private methods
--------------------------------------------------
local dockCurrentWindowToRightSide = Window.dockCurrentWindowToRightSide
local getCurrentWindow = Window.getCurrentWindow
local setCurrentWindow = Window.setCurrentWindow

--
-- Open git commit window
--
local function openGitCommitWindow(window_id, args)
  setCurrentWindow(window_id)
  executeCommand(':Git commit ' .. (args or ''))
end

--
-- Setup keybinding for this window
--
local function setupKeymapForFugitiveWindow()
  local window_id = getCurrentWindow()

  setKeymap(window_id, '<C-a>', ':Git add .<Enter>')

  setKeymap(window_id, '<C-k>', function()
    openGitCommitWindow(window_id)
  end)

  setKeymap(window_id, '<C-k>a', function()
    openGitCommitWindow(window_id, '--amend')
  end)
end

--
-- Open fugitive window
--
local function openFugitveWindow()
  executeCommand('Git') -- Opens fugitive window
end

--
-- Opens git status window
--
local function openGitStatusWindow()
  openFugitveWindow()
  dockCurrentWindowToRightSide(50)
  setupKeymapForFugitiveWindow()
end

--
-- Configure plugin
--
local function setupPlugin()
  vim.keymap.set('n', '<A-g>', openGitStatusWindow, { noremap = true })
end

--------------------------------------------------
-- Error handling
--------------------------------------------------
local function errorHandler(error)
  notify('Fugitive plugin could not be loaded!', WARN)
  notify(error, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setupPlugin, errorHandler)
--------------------------------------------------
