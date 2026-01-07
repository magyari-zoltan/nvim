--------------------------------------------------
-- Private methods
--------------------------------------------------

-- Default keymap
local function default_keymaps(lsp_zero, bufnr)
	local preserve_mappings = true

	if lsp_zero == nil then
		lsp_zero = {}
	end

	local function should_skip(mode, lhs)
		if not preserve_mappings then
			return false
		end
		return vim.fn.mapcheck(lhs, mode) ~= ''
	end

	local function map(mode, lhs, rhs, desc)
		if should_skip(mode, lhs) then
			return
		end
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, nowait = true })
	end

	-- Explicit lsp-zero default keymaps.
	vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr }) -- Does not work with map function
	if vim.fn.has('nvim-0.11') == 1 then
		map('n', 'K', function() vim.lsp.buf.hover({ border = vim.g.lsp_zero_border_style }) end, 'Hover documentation')
		map('n', 'gs', function() vim.lsp.buf.signature_help({ border = vim.g.lsp_zero_border_style }) end,
			'Show function signature')
	else
		map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
		map('n', 'gs', vim.lsp.buf.signature_help, 'Show function signature')
	end

	local mappings = {
		{ 'n', 'gd',    vim.lsp.buf.definition,                              'Go to definition' },
		{ 'n', 'gD',    vim.lsp.buf.declaration,                             'Go to declaration' },
		{ 'n', 'gi',    vim.lsp.buf.implementation,                          'Go to implementation' },
		{ 'n', 'go',    vim.lsp.buf.type_definition,                         'Go to type definition' },

		{ 'n', '<F2>',  vim.lsp.buf.rename,                                  'Rename symbol' },
		{ 'n', '<F3>',  function() vim.lsp.buf.format({ async = true }) end, 'Format file' },
		{ 'x', '<F3>',  function() vim.lsp.buf.format({ async = true }) end, 'Format selection' },
		{ 'n', '<F4>',  vim.lsp.buf.code_action,                             'Execute code action' },
		{ 'n', '<A-a>', vim.lsp.buf.code_action,                             'Code Action' },
	}

	for _, mapping in ipairs(mappings) do
		map(mapping[1], mapping[2], mapping[3], mapping[4])
	end
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
			ts_ls = function()
				-- Disable a feature for a specific server
				lspconfig.ts_ls.setup({
					-- on_init = function(client)
					--  client.server_capabilities.semanticTokensProvider = nil
					--  client.server_capabilities.documentFormattingProvider = false
					--  client.server_capabilities.documentFormattingRangeProvider = false
					-- end,
				})
			end
			------------------------------------------------------
		},
		ensure_installed = { 'lua_ls', 'jdtls', 'ts_ls' }, -- Automatically install the listed language servers
		automatic_installation = true,               -- Automatically install missing servers
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
