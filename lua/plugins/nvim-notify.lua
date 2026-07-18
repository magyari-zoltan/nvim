--------------------------------------------------
-- Private methods
--------------------------------------------------
local function setupPlugin()
    vim.notify = require('notify')
    vim.notify.setup({
        background_color = "#FF9E3",

        -- level = TRACE,
        -- level = DEBUG,
        -- level = INFO,
        -- level = WARN,
        level = ERROR,
    })
end

--------------------------------------------------
-- Error handling
--------------------------------------------------
local function errorHandler(error)
    notify('Notify plugin could not be loaded!', WARN)
    notify(error, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setupPlugin, errorHandler)
--------------------------------------------------
