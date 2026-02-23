--------------------------------------------------------------------------------
-- Conform (Formatting)
--------------------------------------------------------------------------------
require('conform').setup({
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

-- Markdown keymaps
local markdown_keymaps_group = vim.api.nvim_create_augroup('MarkdownKeymaps', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
	group = markdown_keymaps_group,
	pattern = 'markdown',
	callback = function(event)
		local function format_markdown()
			local ok, conform = pcall(require, 'conform')
			if ok then
				conform.format({ bufnr = event.buf, lsp_fallback = true })
			end
		end

		vim.keymap.set('n', '<leader>fm', format_markdown, { buffer = event.buf, desc = 'Format Markdown' })
		vim.keymap.set('x', '<leader>fm', format_markdown, { buffer = event.buf, desc = 'Format Markdown' })
	end,
})

-- Format Markdown on save
local markdown_format_on_save_group = vim.api.nvim_create_augroup('MarkdownFormatOnSave', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
	group = markdown_format_on_save_group,
	pattern = '*.md',
	callback = function(event)
		local ok, conform = pcall(require, 'conform')
		if ok then
			conform.format({ bufnr = event.buf, lsp_fallback = true })
		end
	end,
})
