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
local registerOnWinEnter = keymap.registerOnWinEnter
local registerOnBufEnter = keymap.registerOnBufEnter
local registerGlobalKeybindings = keymap.registerGlobalKeybindings

--
-- Open file history view
--
local function openFileHistoryWindow()
    executeCommand('DiffviewFileHistory')
    local window_id = getCurrentWindow()

    registerOnWinEnter(window_id, function(keybinding)
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
    dockCurrentWindowToRightSide(50)

    local window_id = getCurrentWindow()
    local function closeWindow()
        vim.api.nvim_win_close(window_id, false)
    end
    registerOnWinEnter(window_id, function(keybinding)
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

--
-- Checks if the file belonging to the buffer is git version controlled
--
local function isVersionControlledFile(buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(buffer) then
        return false
    end

    if vim.api.nvim_get_option_value('buftype', { buf = buffer }) ~= '' then
        return false
    end

    local file = vim.api.nvim_buf_get_name(buffer)
    if file == '' or vim.fn.filereadable(file) ~= 1 then
        return false
    end

    local directory = vim.fs.dirname(file)
    if not directory then
        return false
    end

    vim.fn.systemlist({ 'git', '-C', directory, 'ls-files', '--error-unmatch', '--', file })
    return vim.v.shell_error == 0
end

--
-- Checks whether the current project is a git repository
--
local function isGitRepository()
    local cwd = vim.fn.getcwd()
    if not cwd or cwd == '' then
        return false
    end

    vim.fn.systemlist({ 'git', '-C', cwd, 'rev-parse', '--is-inside-work-tree' })
    return vim.v.shell_error == 0
end

--
-- Register fugitive keybindings
--
local function registerKeybindings()
    --
    -- Register keybindings for git version controlled files
    registerOnBufEnter('FugitiveKeymaps', function(buffer, keybinding)
        if isVersionControlledFile(buffer) then
            keybinding('n', '<localleader>gb', createCommand('Git blame'), 'Git blame')
            keybinding('n', '<leader>gh', openFileHistoryWindow, 'Git file history')
        end
    end)
    --
    -- Register global keybindings for git repositories
    registerGlobalKeybindings(function(keybinding)
        if isGitRepository() then
            keybinding('n', '<leader>gs', openGitStatusWindow, 'Git status')
            keybinding('n', '<leader>rb', interactiveRebase, 'Git interactive rebase')
            keybinding('n', '<leader>gr', mixedReset, 'Git mixed reset')
            keybinding('n', '<leader>gl', createCommand('GV HEAD master'), 'Git log')
            keybinding('n', '<leader>gla', createCommand('GV --all'), 'Git log all')
        end
    end)
end

--------------------------------------------------
-- Configure plugin
--------------------------------------------------

local function setupPlugin()
    registerKeybindings()
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
