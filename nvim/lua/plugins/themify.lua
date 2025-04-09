return {
	"lmantw/themify.nvim",

	lazy = false,
	priority = 999,
	opts = {
		async = false,
		"folke/tokyonight.nvim",
		"Yazeed1s/minimal.nvim",
		"sho-87/kanagawa-paper.nvim",
		"catppuccin/nvim",
		"ellisonleao/gruvbox.nvim",
		"default",
		"habamax",
	},
	keys = {
		{ mode = "n", "<leader>ft", "<CMD>:Themify<CR>", desc = "[F]ind [T]heme" },
	},
}
