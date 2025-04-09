return {
	"OXY2DEV/markview.nvim",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		preview = {
			filetypes = { "markdown" },
		},
	},
	keys = {
		{ mode = "n", "<leader>mt", "<CMD>Markview toggleAll<CR>", desc = "[M]arkview [T]oggle" },
		{ mode = "n", "<leader>ms", "<CMD>Markview splitToggle<CR>", desc = "[M]arkview [S]plit Toggle" },
		{ mode = "n", "<leader>mo", "<CMD>MarkOpen<CR>", desc = "[M]arkview [O]pen" },
	},
}
