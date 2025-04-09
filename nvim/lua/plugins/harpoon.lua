return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = function()
		return {
			{
				mode = "n",
				"<leader>hm",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "[H]arpoon [M]ark file",
			},
			{
				mode = "n",
				"<leader>hs",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				'<CMD>lua require("harpoon.ui").toggle_quick_menu()<CR>',
				desc = "[H]arpoon [S]how marks",
			},
		}
	end,
}
