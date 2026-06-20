--------------------------------------------------
-- Dependencies
--------------------------------------------------
local keymap = require('core.keymap')
--------------------------------------------------

--------------------------------------------------
-- Private methods
--------------------------------------------------
local registerGlobalKeybindings = keymap.registerGlobalKeybindings

--
-- Register fugitive keybindings
--
local function registerKeybindings()
    registerGlobalKeybindings(function(keybinding)
        keybinding('n', '<leader>cc', function() require('codex').toggle() end, 'Toggle Codex (OpenAI)')
        keybinding('t', '<leader>cc', function() require('codex').toggle() end, 'Toggle Codex (OpenAI)')
    end)
end

--------------------------------------------------
-- Configure plugin
--------------------------------------------------

local function setupPlugin()
    require('codex').setup({
        keymaps     = {
            toggle = nil, -- disable internal default keymap
            quit = '<C-q>',
        },
        border      = 'rounded',
        width       = 0.8,
        height      = 0.8,
        cmd         = { 'codex' },
        model       = nil,
        autoinstall = true,
        panel       = true,
        use_buffer  = false,
    })
    registerKeybindings()
end

--------------------------------------------------
-- Error handling
--------------------------------------------------
local function errorHandler(err)
    notify('Codex (OpenAI) plugin could not be loaded!', WARN)
    notify(err, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setupPlugin, errorHandler)
--------------------------------------------------
