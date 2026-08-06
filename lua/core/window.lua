--------------------------------------------------
local Window = {} -- Module declaration
--------------------------------------------------

--------------------------------------------------
-- Module Api
--------------------------------------------------

--
-- Resolve the size of a docked window based on the given size and total
-- dimension.
--
-- * If size is then it is returned as is.
--
-- * If size is a string representing a number (e.g., "80"), it is converted
--   to a number and returned.
--
-- * If size is a string ending with '%', (e.g., "25%"), it is treated as a
--   percentage of the total dimension and the corresponding size is
--   calculated and returned.
--
local function resolveDockSize(size, total, dimension)
    if type(size) == 'number' then
        return size
    end

    if type(size) == 'string' then
        local trimmed = vim.trim(size)

        if vim.endswith(trimmed, '%') then
            local percentage = tonumber(vim.trim(trimmed:sub(1, -2)))
            if not percentage then
                notify('Invalid ' .. dimension .. ' percentage: ' .. size, vim.log.levels.WARN)
                return nil
            end

            return math.floor(total * percentage / 100)
        end

        local absolute = tonumber(trimmed)
        if absolute then
            return absolute
        end
    end

    notify('Invalid ' .. dimension .. ' size: ' .. tostring(size), vim.log.levels.WARN)
    return nil
end

--
-- Set focus on a giwen window
--
function Window.setCurrentWindow(window)
    if vim.api.nvim_win_is_valid(window) then
        vim.api.nvim_set_current_win(window)
    else
        notify("Window " .. window .. " does not exist.", vim.log.levels.WARN)
    end
end

--
-- Returns the current window id
--
function Window.getCurrentWindow()
    return vim.api.nvim_get_current_win()
end

--
-- Returns true if the window with the given window id is still open
--
function Window.isWindowOpen(window_id)
    local windows = vim.api.nvim_list_wins()
    local exists = false

    for _, win in ipairs(windows) do
        if win == window_id then
            exists = true
            break
        end
    end

    return exists
end

--
-- Dock current window to the right side
--
function Window.dockCurrentWindowToRightSide(size)
    local width = resolveDockSize(size, vim.o.columns, 'width')
    if not width then
        return
    end
    if width < 1 then
        width = 1
    end

    executeCommand('wincmd L')
    executeCommand('setlocal winfixwidth')
    executeCommand('vertical resize ' .. width)
    executeCommand('set nowrap')
end

--
-- Dock current window to the bottom
--
function Window.dockCurrentWindowToBottom(size)
    local height = resolveDockSize(size, vim.o.lines, 'height')
    if not height then
        return
    end
    if height < 1 then
        height = 1
    end

    executeCommand('wincmd J')
    executeCommand('setlocal winfixheight')
    executeCommand('resize ' .. height)
end

--------------------------------------------------
return Window -- Return the module
--------------------------------------------------
