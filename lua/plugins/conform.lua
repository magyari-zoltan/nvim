--------------------------------------------------------------------------------
-- Dependencies
--------------------------------------------------------------------------------
local keymap = require('core.keymap')

--------------------------------------------------------------------------------
-- Private methods
--------------------------------------------------------------------------------
local registerOnBufEnter = keymap.registerOnBufEnter

--
-- Formats markdown file
--
local function formatMarkdown(conform, buffer)
    return function()
        if vim.api.nvim_buf_is_valid(buffer) then
            notify('Format markdown in buffer: ' .. tostring(buffer), INFO)
            conform.format({ bufnr = buffer, lsp_fallback = true })
        end
    end
end

--
-- Check if file is markdown file
--
local function isMarkdownFile(buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(buffer) then
        return false
    end

    return vim.api.nvim_get_option_value('filetype', { buf = buffer }) == 'markdown'
end

--
-- Register markdown keybinding
--
local function registerMarkdownKeybindings(conform)
    registerOnBufEnter('MarkdownKeymaps', function(buffer, keybinding)
        if isMarkdownFile(buffer) then
            keybinding('n', '<leader>fm', formatMarkdown(conform, buffer), 'Format Markdown')
            keybinding('x', '<leader>fm', formatMarkdown(conform, buffer), 'Format Markdown')
        end
    end)
end

--
-- Format markdown on save
--
local function registerMarkdownFormatOnSave(conform)
    local grou_id = vim.api.nvim_create_augroup('MarkdownFormatOnSave', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = grou_id,
        pattern = '*.md',
        callback = function(event)
            conform.format({ bufnr = event.buf, lsp_fallback = true })
        end,
    })
end

--------------------------------------------------
-- Configure plugin
--------------------------------------------------

local function setupPlugin()
    local conform = require('conform')
    conform.setup({
        formatters_by_ft = {
            markdown = { "prettier" },
        },
        formatters = {
            prettier = {
                command = "prettier",
                args = { "--stdin-filepath", "$FILENAME" },
                stdin = true,
            },
        },
    })

    registerMarkdownKeybindings(conform)
    registerMarkdownFormatOnSave(conform)
end

--------------------------------------------------
-- Error handling
--------------------------------------------------
local function errorHandler(error)
    notify('Conform plugin could not be loaded!', WARN)
    notify(error, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setupPlugin, errorHandler)
--------------------------------------------------
