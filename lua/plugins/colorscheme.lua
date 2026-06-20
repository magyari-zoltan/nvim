--------------------------------------------------------------------------------
-- Colorschemes
--------------------------------------------------------------------------------
local theme = 'gruvbox-baby'

local function setupPlugin()
    executeCommand('set background=dark')
    executeCommand('colorscheme ' .. theme)
end

--------------------------------------------------------------------------------
-- Error handling
--------------------------------------------------------------------------------
local function errorHandler(error)
    notify('Colorscheme plugin could not be loaded!', WARN)
    notify(error, ERROR)
end

--------------------------------------------------------------------------------
-- Entrypoint
--------------------------------------------------------------------------------
local plugins = {
    -- Melange colorscheme
    {
        'savq/melange-nvim',
        config = function()
            if theme == 'melange' then
                tryCatch(setupPlugin, errorHandler)
            end
        end,
    },

    -- Gruvbox colorscheme
    {
        'ellisonleao/gruvbox.nvim',
        config = function()
            if theme == 'gruvbox' then
                tryCatch(setupPlugin, errorHandler)
            end
        end,
    },

    -- Gruvbox-baby colorscheme
    {
        'luisiacc/gruvbox-baby',
        config = function()
            if theme == 'gruvbox-baby' then
                tryCatch(setupPlugin, errorHandler)
            end
        end,
    },

    -- Status line & icons
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'gruvbox',
            },
            sections = {
                lualine_a = {
                    { 'filename', path = 1, },
                },
            },
        },
    },
}

return plugins
