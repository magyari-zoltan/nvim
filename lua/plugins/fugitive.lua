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

--
-- Starts an interactive rebase: `git rebase -i <branch>`
--
local function interactiveRebase()
    vim.ui.input({ prompt = 'Rebase onto branch: ' }, function(branch)
        if not branch or vim.trim(branch) == '' then
            return
        end

        executeCommand('Git rebase -i ' .. vim.fn.fnameescape(vim.trim(branch)))
    end)
end

--
-- Resets get a given number of commits: `git reset --mixed HEAD~<number>`
--
local function mixedReset()
    vim.ui.input({ prompt = 'Reset (--mixed) commits from HEAD (default 1): ' }, function(commit_count)
        if not commit_count then
            return
        end

        commit_count = vim.trim(commit_count)
        if commit_count == '' then
            commit_count = '1'
        end

        local count = tonumber(commit_count)
        if not count or count < 1 or count % 1 ~= 0 then
            notify('Reset commit count must be a positive integer.', WARN)
            return
        end

        executeCommand('Git reset --mixed HEAD~' .. count)
    end)
end

--------------------------------------------------
-- Configure plugin
--------------------------------------------------
local function setupPlugin()
    vim.keymap.set('n', '<leader>gb', createCommand('Git blame'))
    vim.keymap.set('n', '<leader>rb', interactiveRebase)
    vim.keymap.set('n', '<leader>gr', mixedReset)
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
