--------------------------------------------------------------------------------
local Keymap = {} -- Module declaration
--------------------------------------------------------------------------------

WindowKeyMapper = {}
WindowMappedKeys = {}

--------------------------------------------------
-- Dependencies
--------------------------------------------------
local Window = require('core.window')
--------------------------------------------------

--------------------------------------------------
-- Private methods
--------------------------------------------------
local isWindowOpen = Window.isWindowOpen
local getCurrentWindow = Window.getCurrentWindow

local function deleteMapping(mapping)
  notify('deleteKeyMapping: ' .. mapping.mode .. ',' .. mapping.key, DEBUG)
  vim.api.nvim_del_keymap(mapping.mode, mapping.key)
end

local function createMapping(mapping)
  notify('createMapping: ' .. mapping.mode .. ',' .. mapping.key, DEBUG)
  vim.keymap.set(mapping.mode, mapping.key, mapping.command, mapping.opts)
end

local function getKeymapperFromRegistry(window_id)
  notify('getKeymapperFromRegistry: ' .. window_id, DEBUG)
  return WindowKeyMapper[window_id]
end

local function registerKeymapper(window_id, on_keymap)
  notify('registerKeymapper: ' .. window_id, DEBUG)
  WindowKeyMapper[window_id] = on_keymap
end

local function registerKeymap(window_id, mapping)
  notify('registerKeymap: ' .. tostring(window_id) .. ',' .. mapping.mode .. ',' .. mapping.key, DEBUG)
  table.insert(WindowMappedKeys[window_id], {
    mode = mapping.mode,
    key = mapping.key
  })
end

local function clearRegistries(window_id)
  notify('clearRegistries: ' .. window_id, DEBUG)
  WindowKeyMapper[window_id] = {}
  WindowMappedKeys[window_id] = {}
end

local function deleteMappings(window_id)
  notify('deleteMappings: ' .. window_id, DEBUG)

  local bindings = WindowMappedKeys[window_id]
  if bindings then
    for _, binding in ipairs(bindings) do
      try(deleteMapping, binding)
    end
  else
    notify('deleteMappings: bindings is nil: ' .. window_id, TRACE)
  end
end

local function mapAllKeysForWindow(window_id, on_keymap, keymapper)
  notify('mapAllKeysForWindow: ' .. window_id .. ',' .. tostring(on_keymap), DEBUG)

  local function mapSingleKey(mode, key, command, opts)
    notify('mapAllKeysForWindow: mapSingleKey:' .. window_id .. ',' .. tostring(mode) .. ',' .. tostring(key), DEBUG)
    keymapper.createMapping({
      mode = mode,
      key = key,
      command = command,
      opts = opts
    })
    keymapper.registerMapping(window_id, {
      mode = mode,
      key = key
    })
  end

  if isWindowOpen(window_id) then
    tryCatch(on_keymap, keymapper.errorHandler, mapSingleKey)
  else
    notify('mapAllKeysForWindow: window is closed: ' .. window_id, TRACE)
  end
end

--------------------------------------------------------------------------------
-- Module Api
--------------------------------------------------------------------------------

function Keymap.registerOnWindowFocusKeymapper(window_id, on_keymap)
  notify('registerWindowKeymapper: ' .. window_id .. ',' .. tostring(on_keymap), DEBUG)

  if window_id and on_keymap then
    registerKeymapper(window_id, on_keymap)

    local function errorHandler(error)
      notify('registerWindowKeymapper: errorHandler: ' .. window_id .. ',' .. tostring(error), TRACE)
      clearRegistries(window_id)
    end

    mapAllKeysForWindow(window_id, on_keymap, {
      createMapping = createMapping,
      registerMapping = registerKeymap,
      errorHandler = errorHandler
    })
  else
    notify('registerWindowKeymapper: condition not fullfilled: ' .. window_id .. ',' .. tostring(on_keymap), TRACE)
  end
end

--------------------------------------------------------------------------------
-- Configure module
--------------------------------------------------------------------------------
local group_id = vim.api.nvim_create_augroup("Keymap", { clear = true })

vim.api.nvim_create_autocmd("WinClosed", {
  group = group_id,
  pattern = "*",
  callback = function()
    local window_id = getCurrentWindow()
    notify('WinClosed: ' .. window_id, DEBUG)

    deleteMappings(window_id)
    clearRegistries(window_id)
  end
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = group_id,
  pattern = "*",
  callback = function()
    local window_id = getCurrentWindow()
    notify('WinLeave: ' .. window_id, DEBUG)

    deleteMappings(window_id)
  end
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = group_id,
  pattern = "*",
  callback = function()
    local window_id = getCurrentWindow()
    notify('WinEnter: ' .. window_id, DEBUG)

    local on_keymap = getKeymapperFromRegistry(window_id)
    local keymapper = {
      createMapping = createMapping,
      registerMapping = doNothing,
      errorHandler = doNothing
    }

    if not on_keymap then
      clearRegistries(window_id)
      on_keymap = getKeymapperFromRegistry(window_id)
    else
      notify('WinEnter: WindowMappedKeys is not nil!' .. window_id, TRACE)
      mapAllKeysForWindow(window_id, on_keymap, keymapper)
    end
  end
})

--------------------------------------------------
return Keymap -- Return the module
--------------------------------------------------
