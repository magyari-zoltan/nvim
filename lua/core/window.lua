local Window = {}

--
-- Set focus on a giwen window
--
function Window.setCurrentWindow(window)
  if vim.api.nvim_win_is_valid(window) then
    vim.api.nvim_set_current_win(window)
  else
    print("Window " .. window .. " does not exist.")
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
  vim.cmd('wincmd L')
  vim.cmd('setlocal winfixwidth')
  vim.cmd('vertical resize '.. size)
  vim.cmd('set nowrap')
end

--
-- Dock current window to the bottom
--
function Window.dockCurrentWindowToBottom(size)
  vim.cmd('wincmd J')
  vim.cmd('setlocal winfixheight')
  vim.cmd('resize '.. size)
end

--
-- Check if window is floating
-- TODO: not used yet!
--
--function isFloating(window)
--  return vim.api.nvim_win_get_config(window).relative ~= '' 
--end

-- 
-- Create floating window
-- TODO: not used yet!
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

return Window -- Return the module containing all methods
