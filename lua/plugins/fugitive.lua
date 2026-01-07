--------------------------------------------------
-- Dependencies
--------------------------------------------------
local window = require('core.window')
local keymap = require('core.keymap')
--------------------------------------------------

--------------------------------------------------
-- Private methods
--------------------------------------------------
local dockCurrentWindowToRightSide = window.dockCurrentWindowToRightSide
local getCurrentWindow = window.getCurrentWindow
local registerOnWindowFocusKeymapper = keymap.registerOnWindowFocusKeymapper

--
-- Open file history view
--
local function openFileHistoryWindow()
	local window_id = getCurrentWindow()

	executeCommand('DiffviewFileHistory')
	registerOnWindowFocusKeymapper(window_id, function(keybinding)
		keybinding('n', 'q', createCommand('DiffviewClose'))
	end)
end

--
-- Opens git status window
--
local function openGitStatusWindow()
	local function openFugitveWindow()
		executeCommand('Git') -- Opens fugitive window
	end

	openFugitveWindow()
	dockCurrentWindowToRightSide(75)

	local window_id = getCurrentWindow()
	local function closeWindow()
		vim.api.nvim_win_close(window_id, false)
	end
	registerOnWindowFocusKeymapper(window_id, function(keybinding)
		keybinding('n', 'q', closeWindow)
	end)
end

--------------------------------------------------
-- Configure plugin
--------------------------------------------------
local function setupPlugin()
	vim.keymap.set('n', '<leader>gb', createCommand('Git blame'))
	vim.keymap.set('n', '<leader>gs', openGitStatusWindow)
	vim.keymap.set('n', '<leader>gl', createCommand('GV HEAD master'))
	vim.keymap.set('n', '<leader>gla', createCommand('GV --all'))
	vim.keymap.set('n', '<leader>gh', function() openFileHistoryWindow() end)
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
