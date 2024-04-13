--------------------------------------------------
-- Private methods
--------------------------------------------------

-- Default keymap
local function default_keymaps(lsp_zero, bufnr)
  lsp_zero.default_keymaps({
    buffer = bufnr,
    preserve_mappings = true -- By default lsp-zero will not create a keybinding if its "taken".
  })
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<A-a>', '<cmd>lua vim.lsp.buf.code_action()<CR>', {
    noremap = true,
    silent = true,
    desc = "Code Action"
  })
end

-- Configure formatting
local function configure_formatting(client)
  if client.supports_method('textDocument/formatting') then
    require('lsp-format').on_attach(client)
  end
end

-- Language server configurations
local function configure_lang_servers(lsp_zero)
  local lspconfig = require('lspconfig')

  require('mason').setup({})
  require('mason-lspconfig').setup({
    handlers = {
      ------------------------------------------------------
      -- default settings
      lsp_zero.default_setup,

      ------------------------------------------------------
      -- default handler for all servers
      function(server_name)
        require('lspconfig')[server_name].setup({})
      end,

      ------------------------------------------------------
      -- lua
      lua_ls = function()
        local opts = lsp_zero.nvim_lua_ls()
        lspconfig.lua_ls.setup(opts)
      end,

      ------------------------------------------------------
      -- java
      jdtls = lsp_zero.noop, -- Java lsp server won't be handled by lsp-zero, it will be handled by nvim-jdtls plugin

      ------------------------------------------------------
      -- ts server
      tsserver = function()
        -- Disable a feature for a specific server
        lspconfig.tsserver.setup({
          -- on_init = function(client)
          --  client.server_capabilities.semanticTokensProvider = nil
          --  client.server_capabilities.documentFormattingProvider = false
          --  client.server_capabilities.documentFormattingRangeProvider = false
          -- end,
        })
      end
      ------------------------------------------------------
    },
    ensure_installed = { 'lua_ls', 'jdtls', 'tsserver' }, -- Automatically install the listed language servers
    automatic_installation = true,                        -- Automatically install missing servers
  })

  -- handling java lsp
  require('plugins.nvim-jdtls')
end

-- Configure autocompletion
local function configure_autocompletion()
  local cmp = require('cmp')

  cmp.setup({
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
    },
    mapping = {
      ['<C-y>'] = cmp.mapping.confirm({ select = false }),
      ['<Enter>'] = cmp.mapping.confirm({ select = true }),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
      ['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
      ['<C-p>'] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = 'insert' })
        else
          cmp.complete()
        end
      end),
      ['<C-n>'] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = 'insert' })
        else
          cmp.complete()
        end
      end),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    formatting = {
      -- changing the order of fields so the icon is the first
      fields = { 'menu', 'abbr', 'kind' },

      -- here is where the change happens
      format = function(entry, item)
        local menu_icon = {
          nvim_lsp = 'λ',
          luasnip = '⋗',
          buffer = 'Ω',
          path = '🖫',
          nvim_lua = 'Π',
        }

        item.menu = menu_icon[entry.source.name]
        return item
      end,
    },
  })
end

-- Lsp zero configurations
local function setupPlugin()
  local lsp_zero = require('lsp-zero')

  lsp_zero.on_attach(function(client, buffer)
    default_keymaps(lsp_zero, buffer)
    configure_formatting(client)
  end)

  lsp_zero.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
  })

  -- Disable a feature in every server
  lsp_zero.set_server_config({
    -- on_init = function(client)
    --  client.server_capabilities.semanticTokensProvider = nil
    --  client.server_capabilities.documentFormattingProvider = false
    --  client.server_capabilities.documentFormattingRangeProvider = false
    -- end,
  })

  configure_lang_servers(lsp_zero)
  configure_autocompletion()
end

--------------------------------------------------
-- Error handling
--------------------------------------------------
local function errorHandler(error)
  vim.notify('Lsp plugin could not be loaded!', WARN)
  vim.notify(error, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setupPlugin, errorHandler)
--------------------------------------------------
