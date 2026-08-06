local function setupPlugin()
    require('git-conflict').setup({
        default_mappings = true,
        default_commands = true,
        disable_diagnostics = true,
        list_opener = 'copen',
    })
end

local function errorHandler(error)
    vim.notify('git-conflict plugin could not be loaded!', vim.log.levels.WARN)
    vim.notify(error, vim.log.levels.ERROR)
end

tryCatch(setupPlugin, errorHandler)
