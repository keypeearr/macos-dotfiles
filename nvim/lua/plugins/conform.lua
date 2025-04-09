return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			mode = "n",
			"<leader>F",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = true,
		format_on_save = function(bufnr)
			local ft = vim.bo[bufnr].filetype
			local disabled_fts = { c = true, cpp = true }

			return {
				timeout_ms = 500,
				quiet = true,
				lsp_format = disabled_fts[ft] and "never" or "fallback",
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			go = {
				"goimports-reviser",
				"gofumpt",
				"golines",
				"goimports",
			},
			templ = {
				"templ",
				"gofumpt",
				"goimports",
				"goimports-reviser",
				"golines",
				"gomodifytags",
				"tailwindcss-language-server",
				"prettierd",
				"prettier",
			},
			sql = { "sql-formatter" },
			javascript = { "prettierd", "biome" },
		},
	},
}
