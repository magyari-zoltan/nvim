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
function _G.executeCommand(command)
  vim.api.nvim_command(command)
end

--
-- Send a notification message to user
--
function _G.notify(message, level, opts)
  vim.notify(message, level, opts)
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
    notify(message, TRACE)
  end
end

--
-- Wraps a function into an error handler
--
function _G.tryCatch(resolve, reject, args)
  local ok, message = pcall(resolve, args or {})

  if not ok then
    if reject then
      reject(message)
    else
      notify(message, TRACE)
    end
  end
end
