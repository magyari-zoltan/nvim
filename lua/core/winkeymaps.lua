--------------------------------------------------------------------------------
local WinKeyMaps = {} -- Module declaration
--------------------------------------------------------------------------------

-- Global table to hold window bindings
WindowKeyBindingMap = {} -- Map keybindings to a given window id

--------------------------------------------------
-- Dependencies
--------------------------------------------------
local Window = require('core.window')
--------------------------------------------------

--------------------------------------------------
-- Private methods
--------------------------------------------------
local isWindowOpen = Window.isWindowOpen

-- Initialize the list for the window
local function resetWindowKeybindingMap(window_id)
  WindowKeyBindingMap[window_id] = {}
end

-- Set key map to a command
local function setKeymap(key, command)
  vim.keymap.set('n', key, command, { noremap = true, silent = true })
end

-- Adds a key map to a window
local function addKeybindingToMap(window_id, key)
  -- Initialize the list for the window if it doesn't exist
  if not WindowKeyBindingMap[window_id] then
    resetWindowKeybindingMap(window_id)
  end

  table.insert(WindowKeyBindingMap[window_id], key)
end

-- Remove the key binding using the stored key
local function deleteKeymap(key)
  vim.api.nvim_del_keymap('n', key)
end

-- Function to remove all keymap to a give window id
local function deleteAllKeymaps(window_id)
  local bindings = WindowKeyBindingMap[window_id]

  if bindings then
    -- Remove all keybindings from the map for a window id
    for _, binding in ipairs(bindings) do
      deleteKeymap(binding)
    end
  end

  -- Clear the entry in the table
  resetWindowKeybindingMap(window_id)
end

--------------------------------------------------------------------------------
-- Module Api
--------------------------------------------------------------------------------

-- Function to set a keybinding if a specific window is open
function _G.setKeymap(window_id, key, command)
  if isWindowOpen(window_id) then
    -- Add the key binding to Neovim and to the table
    setKeymap(key, command)
    addKeybindingToMap(window_id, key)
  end
end

-- Module setup
function WinKeyMaps.setup()
  -- Create or get an autocommand group for key binding clean up when window is closed
  local group_id = vim.api.nvim_create_augroup("WinCloseKeyMappingCleanup", { clear = true })

  -- Define an autocommand within this group to handle window closures
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group_id,
    pattern = "*",
    callback = function(args)
      deleteAllKeymaps(tonumber(args.file)) -- Call the function to remove key bindings using the window_id
    end
  })

  -- Return the module
  return WinKeyMaps
end

--------------------------------------------------
return WinKeyMaps -- Return the module
--------------------------------------------------
