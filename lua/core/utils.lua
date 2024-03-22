local Utils = {}

--
-- Send a notification message to user
--
function Utils.notify(message)
  vim.notify(message)
end 

return Utils -- Return the module containing all methods
