---
--- https://codecompanion.olimorris.dev/configuration/chat-buffer#context
---

--------------------------------------------------
-- Dependencies
--------------------------------------------------
local keymap = require('core.keymap')
--------------------------------------------------

--------------------------------------------------
-- Private methods
--------------------------------------------------
local registerGlobalKeybindings = keymap.registerGlobalKeybindings

--------------------------------------------------
-- Configure plugin
--------------------------------------------------

--
-- Disable line numbers in CodeCompanion windows/buffers
--
local augroup = vim.api.nvim_create_augroup("CodeCompanionNoNumbers", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "WinEnter" }, {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf or vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(bufnr) or ""
        local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

        if ft == "codecompanion" or name:match("[Cc]ode[Cc]ompanion") or name:match("codecompanion") then
            vim.api.nvim_buf_set_option(bufnr, "number", false)
            vim.api.nvim_buf_set_option(bufnr, "relativenumber", false)
        end
    end,
})

--
-- Register agent keybindings
--
local function registerKeybindings()
    --
    -- Register global keybindings
    registerGlobalKeybindings(function(keybinding)
        -- Copilot chat (open in right vertical split)
        keybinding('n', '<leader>cp', createCommand('CodeCompanionChat'), 'Copilot Chat')
        keybinding('n', '<leader>ca', createCommand('CodeCompanionActions'), 'Copilot Actions')
    end)
end


--------------------------------------------------
-- Configure plugin
--------------------------------------------------

local function setupPlugin()
    require("codecompanion").setup({
        display = {
            chat = {
                icons = {
                    buffer_sync_all = "📡 ",
                    buffer_sync_diff = " ",
                    chat_context = "📌 ",
                    chat_fold = "📁 ",
                    tool_pending = "🪢  ",
                    tool_in_progress = "⏳  ",
                    tool_failure = "💥  ",
                    tool_success = "✨  ",
                },
                fold_context = true,
                fold_reasoning = false,
                show_reasoning = false,
            },
        },
        interactions = {
            chat = {
                adapter = "copilot",
                tools = {
                    opts = {
                        default_tools = {
                            "agent",
                            "files",
                            "web_search",
                            "fetch_webpage",
                            --"memory", -- Needs the `<project root>/memories/` folder to exist
                        },
                    },
                },
            },
            inline = {
                adapter = "copilot",
            },
        },
    })
    registerKeybindings()
end

--------------------------------------------------
-- Error handling
--------------------------------------------------
local function errorHandler(error)
    notify('CodeCompanion plugin could not be loaded!', WARN)
    notify(error, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setupPlugin, errorHandler)
--------------------------------------------------
