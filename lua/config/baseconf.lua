-- Tab
vim.opt.tabstop = 4      -- number of visual spaces per TAB
vim.opt.softtabstop = 4  -- number of spacesin tab when editing
vim.opt.shiftwidth = 4   -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces

-- UI config
vim.opt.number = true          -- show absolute number
vim.opt.relativenumber = false -- add numbers to each line on the left side
vim.opt.cursorline = true      -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true      -- open new vertical split bottom
vim.opt.splitright = true      -- open new horizontal splits right
vim.opt.termguicolors = true   -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = true        -- we are experienced, wo don't need the "-- INSERT --" mode hint
vim.opt.laststatus = 2
vim.opt.wrap = false           -- do not wrap long lines

-- Searching
vim.opt.incsearch = true  -- search as characters are entered
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true  -- but make it case sensitive if an uppercase is entered
vim.opt.hlsearch = true   -- do not highlight matches

-- Other
vim.opt.autoread = true
-- vim.opt.clipboard = 'unnamedplus'   -- use system clipboard
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local folding_group = vim.api.nvim_create_augroup('Folding', { clear = true })

vim.api.nvim_create_autocmd('BufWinEnter', {
    group = folding_group,
    --
    -- Entering a buffer window callback, set up syntax-based folding
    callback = function(event)
        if vim.bo[event.buf].buftype ~= '' then
            return
        end

        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

        vim.wo.foldenable = true
        vim.wo.foldlevel = 99
        vim.o.foldlevelstart = 99
    end
})
