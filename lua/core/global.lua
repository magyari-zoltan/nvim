function _G.tryCatch(resolve, reject, args)
    local ok, message = pcall(resolve, args or {})

    if not ok then
      reject(message)
    end
end
