--------------------------------------------------
local Window = {} -- Module declaration
--------------------------------------------------

--------------------------------------------------
-- Module Api
--------------------------------------------------

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
  executeCommand('wincmd L')
  executeCommand('setlocal winfixwidth')
  executeCommand('vertical resize ' .. size)
  executeCommand('set nowrap')
end

--
-- Dock current window to the bottom
--
function Window.dockCurrentWindowToBottom(size)
  executeCommand('wincmd J')
  executeCommand('setlocal winfixheight')
  executeCommand('resize ' .. size)
end

--------------------------------------------------
-- TODO: Api methods to try out
--------------------------------------------------

--
-- Check if window is floating
--
--function isFloating(window)
--  return vim.api.nvim_win_get_config(window).relative ~= ''
--end

--
-- Create floating window
--
--function createFloatingWindow()
--  let buf = nvim_create_buf(v:false, v:true)
--  call nvim_buf_set_lines(buf, 0, -1, v:true, ['test', 'text'])
--
--  let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0, 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
--  let win = nvim_open_win(buf, 0, opts)
--
--  -- optional: change highlight, otherwise Pmenu is used
--  call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
--:end

--------------------------------------------------
return Window -- Return the module
--------------------------------------------------
