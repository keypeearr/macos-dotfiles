return {
	{
		"ibhagwan/fzf-lua",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		keys = function()
			local fzf = require("fzf-lua")
			return {
				{
					mode = "n",
					"<leader>fh",
					function()
						fzf.helptags()
					end,
					desc = "[F]ind [H]elp",
				},
				{
					mode = "n",
					"<leader>fk",
					function()
						fzf.keymaps()
					end,
					desc = "[F]ind [K]eymaps",
				},
				{
					mode = "n",
					"<leader>ff",
					function()
						fzf.files()
					end,
					desc = "[F]ind [F]iles",
				},
				{
					mode = "n",
					"<leader>fw",
					function()
						fzf.grep_cword()
					end,
					desc = "[F]ind current [W]ord",
				},
				{
					mode = "n",
					"<leader>fg",
					function()
						fzf.live_grep()
					end,
					desc = "[F]ind [G]rep",
				},
				{
					mode = "n",
					"<leader>fdd",
					function()
						fzf.diagnostics_document()
					end,
					desc = "[F]ind [D]iagnostics [D]ocument",
				},
				{
					mode = "n",
					"<leader>fdw",
					function()
						fzf.diagnostics_workspace()
					end,
					desc = "[F]ind [D]iagnostics [W]orkspace",
				},
				{
					mode = "n",
					"<leader>fr",
					function()
						fzf.resume()
					end,
					desc = "[F]ind [R]esume",
				},
				{
					mode = "n",
					"<leader>f.",
					function()
						fzf.oldfiles()
					end,
					desc = "[F]ind [.]Recent Files",
				},
				{
					mode = "n",
					"<leader><leader>",
					function()
						fzf.buffers()
					end,
					desc = "[ ][ ] Find in Buffers",
				},
				{
					mode = "n",
					"<leader>/",
					function()
						fzf.blines()
					end,
					desc = "[ ][/] Find in current Buffer ",
				},
				{
					mode = "n",
					"<leader>f/",
					function()
						fzf.lines()
					end,
					desc = "[F]ind [/] in Open Buffers ",
				},
				{
					mode = "n",
					"<leader>fn",
					function()
						fzf.files({ cwd = vim.fn.stdpath("config") })
					end,
					desc = "[F]ind [N]eovim Files",
				},
			}
		end,
	},
}
