--------------------------------------------------
-- Private methods
--------------------------------------------------
local function setupPlugin()
    local ok, configs = pcall(require, 'nvim-treesitter.configs')
    if not ok then
        return
    end

    configs.setup({
        ensure_installed = {
            'bash',
            'c',
            'css',
            'html',
            'javascript',
            'java',
            'json',
            'jsonc',
            'lua',
            'markdown',
            'markdown_inline',
            'python',
            'query',
            'typescript',
            'tsx',
            'vim',
            'vimdoc',
            'yaml',
        },
        auto_install = true,
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    })
end

--------------------------------------------------
-- Error handling
--------------------------------------------------
local function errorHandler(error)
    vim.notify('nvim-treesitter plugin could not be loaded!', WARN)
    vim.notify(error, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setupPlugin, errorHandler)
--------------------------------------------------
