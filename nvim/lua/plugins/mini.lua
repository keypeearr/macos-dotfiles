return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.surround").setup()
		local mini_comment = require("mini.comment")
		mini_comment.setup({
			hooks = {
				pre = function()
					vim.b.minicomment_original_commentstring = vim.bo.commentstring
				end,
				post = function()
					if vim.b.minicomment_original_commentstring then
						vim.bo.commentstring = vim.b.minicomment_original_commentstring
						vim.b.minicomment_original_commentstring = nil
					end
				end,
			},
		})

		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = "templ",
			callback = function()
				vim.bo.commentstring = "//%s"
			end,
		})

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
