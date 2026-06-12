local group = vim.api.nvim_create_augroup('UserNotifications', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    callback = function(event)
        local file = vim.fn.fnamemodify(event.match, ':~:.')

        notify('Saved ' .. file, INFO, {
            title = 'File saved',
        })
    end,
})
