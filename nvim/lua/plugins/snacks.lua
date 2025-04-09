return {
	{
		"folke/snacks.nvim",
		event = { "VimEnter" },
		lazy = false,
		priority = 1000,
		opts = {
			dashboard = {
				preset = {
					header = [[
██╗  ██╗██████╗ ██████╗
██║ ██╔╝██╔══██╗██╔══██╗
█████╔╝ ██████╔╝██████╗
██╔═██╗ ██╔═ ══╝██╔══██╗
██║  ██╗██║     ██║  ██║
╚═╝  ╚═╝╚═╝     ╚═   ╚═╝]],
				},
				sections = {
					{ section = "header" },
					{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
					{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{ section = "startup" },
				},
			},
			lazygit = {},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
		},
		keys = function()
			return {
				{
					"<leader>lg",
					function()
						Snacks.lazygit.open()
					end,
					desc = "LazyGit",
				},
				{
					"<leader>nsh",
					function()
						Snacks.notifier.show_history()
					end,
					desc = "[N]otifier [S]how [H]istory",
				},
				{
					"<leader>nh",
					function()
						Snacks.notifier.hide()
					end,
					desc = "[N]otifier [H]ide",
				},
			}
		end,
	},
}
