--------------------------------------------------------------------------------
local Keymap = {} -- Module declaration
--------------------------------------------------------------------------------

BufferKeymapperCallbacks = {}
WindowKeymapperCallbacks = {}
WindowKeyBindings = {}

--------------------------------------------------
-- Dependencies
--------------------------------------------------
local Window = require('core.window')
--------------------------------------------------

--------------------------------------------------
-- Class Keymapper
--------------------------------------------------

-- Class definition
local Keymapper = {}
Keymapper.__index = Keymapper

--
-- Constructor
--
-- @param windowId: the
function Keymapper:new(windowId, onKeymap)
    local instance = setmetatable({}, Keymapper)
    instance.windowId = windowId
    instance.onKeymap = onKeymap
    return instance
end

--------------------------------------------------
-- Private methods
--------------------------------------------------
local isWindowOpen = Window.isWindowOpen
local getCurrentWindow = Window.getCurrentWindow

--------------------------------------------------
-- Window key binding related
--------------------------------------------------

--
-- Register keybinding to know which bindings should be removed on window leave
--
local function registerKeyBinding(window_id, mapping)
    notify('registerKeymap: ' .. tostring(window_id) .. ',' .. mapping.mode .. ',' .. mapping.key, TRACE)
    table.insert(WindowKeyBindings[window_id], {
        mode = mapping.mode,
        key = mapping.key
    })
end

--
-- Unregisters all keybindings for a given window
--
local function unregisterKeyBindings(window_id)
    notify('unregisterKeyBindings: ' .. tostring(window_id), TRACE)
    WindowKeyBindings[window_id] = nil
end

--
-- Creates the binding between a key combination and a command
--
local function createKeyBinding(mapping)
    notify('createKeyBinding: ' .. mapping.mode .. ',' .. mapping.key, TRACE)
    vim.keymap.set(mapping.mode, mapping.key, mapping.command, mapping.opts)
end

--
-- Checks wheter a keybinding is already registered in vim
--
local function existsKeyBinding(mode, key)
    for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
        if map.lhs == key then
            return true
        end
    end

    return false
end

--
-- Deletes the binding between a key combination and a command
--
local function deleteKeyBinding(mapping)
    notify('deleteKeyBinding: ' .. mapping.mode .. ',' .. mapping.key, DEBUG)
    if existsKeyBinding(mapping.mode, mapping.key) then
        vim.api.nvim_del_keymap(mapping.mode, mapping.key)
    end
end

--
-- Deletes the binding between a key combination and a command for all registered key bindings
--
local function deleteRegisteredKeyBindings(window_id)
    local bindings = WindowKeyBindings[window_id]
    if bindings then
        for _, binding in ipairs(bindings) do
            try(deleteKeyBinding, binding)
        end
    else
        notify('deleteRegisteredKeyBindings: bindings is nil: ' .. window_id, TRACE)
    end
end

--------------------------------------------------
-- Window keymapper callback method related
--------------------------------------------------

--
-- Registers a keymapper calback method to be able to call it
-- whenever the window is activated.
--
local function registerKeymapperCallback(window_id, on_keymap)
    notify('registerKeymapperCallback: ' .. window_id, TRACE)
    WindowKeymapperCallbacks[window_id] = on_keymap
end

--
-- Returns the keymapper callback method for a given window.
--
local function getKeymapperCallback(window_id)
    return (WindowKeymapperCallbacks[window_id])
end

--
-- Calls the keymapper callback registered to a given window
--
local function callKeymapperCallback(window_id)
    local function keybinding(mode, key, command, opts)
        if not existsKeyBinding(mode, key) then
            registerKeyBinding(window_id, {
                mode = mode,
                key = key
            })
            createKeyBinding({
                mode = mode,
                key = key,
                command = command,
                opts = opts
            })
        end
    end

    local function errorHandler(error)
        notify('Keybindings for the window:' .. window_id .. ' could not be created! ERROR: ' .. tostring(error), ERROR)
        deleteRegisteredKeyBindings(window_id)
        unregisterKeyBindings(window_id)
    end

    if not isWindowOpen(window_id) then
        notify('callKeymapperCallback: window is closed: ' .. window_id, TRACE)
        return
    end

    local callback = getKeymapperCallback(window_id)

    if type(callback) == "function" then
        tryCatch(callback, errorHandler, keybinding)
    end
end


local function callBufferKeymapperCallback(buffer, callback_id)
    buffer = buffer or vim.api.nvim_get_current_buf()
    local did_create_keybinding = false

    local function keybinding(mode, key, command, desc, opts)
        opts = vim.tbl_extend("force", opts or {}, {
            desc = desc,
            buffer = buffer,
            silent = true
        })

        local mapping = {
            mode = mode,
            key = key,
            command = command,
            opts = opts
        }

        createKeyBinding(mapping)
        did_create_keybinding = true
    end

    if not vim.api.nvim_buf_is_valid(buffer) then
        return
    end

    if type(vim.b[buffer].keymappers) ~= 'table' then
        vim.b[buffer].keymappers = {}
    end

    -- Keymapper already initialized for this buffer
    if callback_id and vim.b[buffer].keymappers[callback_id] then
        notify('callBufferKeymapperCallback: ' .. buffer .. '/' .. callback_id .. ' is already initialized.', TRACE)
        return
    end

    local function errorHandler(error)
        notify('Keybindings for the buffer:' .. tostring(buffer) .. ' could not be created! ERROR: ' .. tostring(error),
            ERROR)
    end

    if callback_id then
        local callback = BufferKeymapperCallbacks[callback_id]
        if callback then
            did_create_keybinding = false
            tryCatch(callback, errorHandler, buffer, keybinding)
            if did_create_keybinding then
                vim.b[buffer].keymappers[callback_id] = true
            end
        end
        return
    end

    for callbackId, callback in pairs(BufferKeymapperCallbacks) do
        if not vim.b[buffer].keymappers[callbackId] then
            did_create_keybinding = false
            tryCatch(callback, errorHandler, buffer, keybinding)
            if did_create_keybinding then
                vim.b[buffer].keymappers[callbackId] = true
            end
        end
    end
end

--------------------------------------------------
-- Cleanup registries
--------------------------------------------------

local function clearRegistriesForWindow(window_id)
    notify('clearRegistriesForWindow: ' .. window_id, TRACE)
    WindowKeymapperCallbacks[window_id] = {}
    WindowKeyBindings[window_id] = {}
end

--------------------------------------------------------------------------------
-- Module Api
--------------------------------------------------------------------------------

--
-- Api for registering global keymap
--
function Keymap.registerGlobalKeybindings(on_keymap)
    notify('registerGlobalKeymap: ' .. tostring(on_keymap), TRACE)

    local function keybinding(mode, key, command, desc, opts)
        opts = vim.tbl_extend("force", opts or {}, {
            desc = desc,
            silent = true
        })

        local mapping = {
            mode = mode,
            key = key,
            command = command,
            opts = opts
        }

        createKeyBinding(mapping)
    end

    if on_keymap then
        on_keymap(keybinding)
    end
end

--
-- Api for registering keymap on BufEnter
--
function Keymap.registerOnBufEnter(callbackId, on_keymap)
    notify('registerOnBufEnter: ' .. callbackId .. ',' .. tostring(on_keymap), TRACE)
    BufferKeymapperCallbacks[callbackId] = on_keymap

    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        callBufferKeymapperCallback(buffer, callbackId)
    end
end

--
-- Api for registering keymap on WinEnter
--
function Keymap.registerOnWinEnter(window_id, on_keymap)
    notify('registerOnWinEnter: ' .. window_id .. ',' .. tostring(on_keymap), TRACE)

    if window_id and on_keymap then
        registerKeymapperCallback(window_id, on_keymap)
        callKeymapperCallback(window_id)
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

        deleteRegisteredKeyBindings(window_id)
        clearRegistriesForWindow(window_id)
    end
})

vim.api.nvim_create_autocmd("WinLeave", {
    group = group_id,
    pattern = "*",
    callback = function()
        local window_id = getCurrentWindow()
        notify('WinLeave: ' .. window_id, DEBUG)

        deleteRegisteredKeyBindings(window_id)
    end
})

vim.api.nvim_create_autocmd("WinEnter", {
    group = group_id,
    pattern = "*",
    callback = function()
        local window_id = getCurrentWindow()
        notify('WinEnter: ' .. window_id, DEBUG)

        local on_keymap = getKeymapperCallback(window_id)
        if not on_keymap then
            clearRegistriesForWindow(window_id)
            on_keymap = getKeymapperCallback(window_id)
        else
            notify('WinEnter: WindowKeyBindings is not nil!' .. window_id, TRACE)
            callKeymapperCallback(window_id)
        end
    end
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    group = group_id,
    pattern = "*",
    callback = function(event)
        callBufferKeymapperCallback(event.buffer)
    end,
})

--------------------------------------------------
return Keymap -- Return the module
--------------------------------------------------
