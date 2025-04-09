return {
	"stevearc/oil.nvim",
	opts = {
		view_options = {
			show_hidden = true,
			is_hidden_file = function(name, bufnr)
				return vim.startswith(name, ".")
			end,
			is_always_hidden = function(name, bufnr)
				return false
			end,
			natural_order = true,
			case_insensitive = false,
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},
	},
	keys = {
		{ mode = "n", "<leader>e", "<CMD>Oil<CR>", desc = "Open parent directory" },
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
