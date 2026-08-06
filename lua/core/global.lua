--
-- Log levels
--
_G.TRACE = vim.log.levels.TRACE
_G.DEBUG = vim.log.levels.DEBUG
_G.INFO = vim.log.levels.INFO
_G.WARN = vim.log.levels.WARN
_G.ERROR = vim.log.levels.ERROR
_G.OFF = vim.log.levels.OFF

--
--
--
function _G.createCommand(command)
    return function()
        vim.api.nvim_command(command)
    end
end

--
-- Executes a neo vim command
--
local function isGVCommand(command)
    return command == 'GV' or command:match('^GV%s') ~= nil
end

function _G.executeCommand(command)
    vim.api.nvim_command(command)

    if isGVCommand(command) then
        vim.g.gv_last_command = command

        local buffer = vim.api.nvim_get_current_buf()
        if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].filetype == 'GV' then
            vim.b[buffer].gv_command = command
        end
    end
end

--
-- Send a notification message to user
--
function _G.notify(message, level, opts)
    vim.schedule(function()
        vim.notify(message, level, opts)
    end)
end

--
-- Do nothing
--
function _G.doNothing()
end

--
-- Wraps a function into an error handler
--
function _G.try(resolve, args)
    local ok, message = pcall(resolve, args or {})

    if not ok then
        notify(message, ERROR)
    end
end

--
-- Wraps a function into an error handler
--
function _G.tryCatch(resolve, reject, ...)
    local ok, message = pcall(resolve, ...)

    if not ok then
        if reject then
            reject(message)
        else
            notify(message, ERROR)
        end
    end
end
