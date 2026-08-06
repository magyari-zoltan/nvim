--------------------------------------------------------------------------------
-- Group autocmds that show user-facing notifications.
--------------------------------------------------------------------------------
local group = vim.api.nvim_create_augroup('UserNotifications', { clear = true })

--------------------------------------------------------------------------------
-- Group autocmds that detect and reload files changed outside Neovim.
--------------------------------------------------------------------------------
local autoread_group = vim.api.nvim_create_augroup('AutoReadFiles', { clear = true })

--------------------------------------------------------------------------------
-- Group autocmds that keep Fugitive/GV git views in sync with git commands.
--------------------------------------------------------------------------------
local git_views_group = vim.api.nvim_create_augroup('GitViews', { clear = true })

--------------------------------------------------------------------------------
-- Show a notification after a buffer is written to disk.
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    callback = function(event)
        local filename = vim.fn.fnamemodify(event.file, ':t')

        if filename == 'COMMIT_EDITMSG' then
            notify('Commit completed successfully', INFO, {
                title = 'Git commit',
            })
            return
        end

        local file = vim.fn.fnamemodify(event.match, ':~:.')
        notify('Saved ' .. file, INFO, {
            title = 'File saved',
        })
    end,
})

--------------------------------------------------------------------------------
-- Ask Neovim to check whether open files changed on disk.
-- This makes 'autoread' react when focus returns, buffers are entered,
-- or the user has been idle for 'updatetime' milliseconds.
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    group = autoread_group,
    callback = function()
        -- Avoid running file checks while the command-line window is active.
        if vim.fn.mode() ~= 'c' then
            vim.cmd('checktime')
        end
    end,
})

--------------------------------------------------------------------------------
-- Show a notification after Neovim reloads a file changed on disk.
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('FileChangedShellPost', {
    group = autoread_group,
    callback = function(event)
        -- Display paths relative to the current working directory or home.
        local file = vim.fn.fnamemodify(event.match, ':~:.')

        notify('Reloaded ' .. file, INFO, {
            title = 'File changed',
        })
    end,
})

--- Refresh GV by closing any existing GV tabs first, then reopening once.
-- GV always creates a new tab, so reusing an existing GV window would pile up tabs.
--------------------------------------------------------------------------------
local function normalizeGVCommand(command)
    if type(command) ~= 'string' then
        return nil
    end

    command = vim.trim(command)
    command = command:gsub('^silent%s+', '')
    command = command:gsub('^keepalt%s+', '')

    if command == 'GV' or command:match('^GV%s') ~= nil then
        return command
    end

    return nil
end

local function getGVCommand()
    local command = normalizeGVCommand(vim.g.gv_last_command)
    if command then
        return command
    end

    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].filetype == 'GV' then
            local ok, command = pcall(vim.api.nvim_buf_get_var, buffer, 'gv_command')
            if ok then
                command = normalizeGVCommand(command)
                if command then
                    return command
                end
            end
        end
    end

    return 'GV'
end

local function refreshGVViews()
    if vim.fn.exists(':GV') ~= 2 then
        return
    end

    local gv_windows = {}
    local seen_windows = {}

    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].filetype == 'GV' then
            for _, window in ipairs(vim.fn.win_findbuf(buffer)) do
                if vim.api.nvim_win_is_valid(window) and not seen_windows[window] then
                    seen_windows[window] = true
                    table.insert(gv_windows, window)
                end
            end
        end
    end

    if #gv_windows == 0 then
        return
    end

    for index = #gv_windows, 1, -1 do
        pcall(vim.api.nvim_win_close, gv_windows[index], true)
    end

    local ok, err = pcall(vim.cmd, 'silent keepalt ' .. getGVCommand())
    if not ok then
        notify('Failed to reopen GV view: ' .. err, WARN)
    end
end

vim.api.nvim_create_autocmd('User', {
    group = git_views_group,
    pattern = 'FugitiveChanged',
    callback = function()
        vim.schedule(refreshGVViews)
    end,
})

vim.api.nvim_create_autocmd('User', {
    group = git_views_group,
    pattern = 'FugitiveShellCmdPost',
    callback = function()
        vim.schedule(refreshGVViews)
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = git_views_group,
    pattern = 'GV',
    callback = function(event)
        if type(vim.b[event.buf].gv_command) ~= 'string' or vim.b[event.buf].gv_command == '' then
            local command = normalizeGVCommand(vim.fn.histget('cmd', -1))
            if command then
                vim.b[event.buf].gv_command = command
                vim.g.gv_last_command = command
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- Wipe closed GV buffers so they do not linger in buffer or tab listings.
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufWinLeave', {
    group = git_views_group,
    callback = function(event)
        if not vim.api.nvim_buf_is_valid(event.buf) then
            return
        end

        if vim.bo[event.buf].filetype ~= 'GV' then
            return
        end

        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) then
                return
            end

            if #vim.fn.win_findbuf(event.buf) > 0 then
                return
            end

            pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
        end)
    end,
})

--------------------------------------------------------------------------------
-- Close terminal windows that opt in once their job exits.
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('TermClose', {
    group = autoread_group,
    callback = function(event)
        if not vim.api.nvim_buf_is_valid(event.buf) then
            return
        end

        if not vim.b[event.buf].close_window_on_exit then
            return
        end

        vim.schedule(function()
            for _, window in ipairs(vim.fn.win_findbuf(event.buf)) do
                if vim.api.nvim_win_is_valid(window) then
                    pcall(vim.api.nvim_win_close, window, true)
                end
            end
        end)
    end,
})
