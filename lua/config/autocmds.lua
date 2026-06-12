--------------------------------------------------------------------------------
-- Group autocmds that show user-facing notifications.
--------------------------------------------------------------------------------
local group = vim.api.nvim_create_augroup('UserNotifications', { clear = true })

--------------------------------------------------------------------------------
-- Group autocmds that detect and reload files changed outside Neovim.
--------------------------------------------------------------------------------
local autoread_group = vim.api.nvim_create_augroup('AutoReadFiles', { clear = true })

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
