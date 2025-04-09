local set = vim.keymap.set
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
set("n", "<leader>Q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Deletes current buffer without saving
set("n", "<leader>q", ":bdelete!<CR>", { desc = "[Q]uit Current Buffer", noremap = true, silent = true })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Create a keymap to create a new terminal buffer
set("n", "<leader>T", ":terminal<CR>", { desc = "Create [T]erminal", noremap = true, silent = true })

-- Allows creation of splits
set("n", "<leader>H", ":split<CR>", { desc = "Create Horizontal Split", noremap = true, silent = true })
set("n", "<leader>V", ":vsplit<CR>", { desc = "Create Vertical Split", noremap = true, silent = true })

-- Allows easier transition from splits
set("n", "<c-j>", "<c-w><c-j>", { desc = "Split Move Down", noremap = true, silent = true })
set("n", "<c-k>", "<c-w><c-k>", { desc = "Split Move Up", noremap = true, silent = true })
set("n", "<c-h>", "<c-w><c-h>", { desc = "Split Move Left", noremap = true, silent = true })
set("n", "<c-l>", "<c-w><c-l>", { desc = "Split Move Right", noremap = true, silent = true })

-- Allows resizing of splits
set("n", "<leader>rh", "<c-w>5<", { desc = "Split [R]esize Left", noremap = true, silent = true })
set("n", "<leader>rl", "<c-w>5>", { desc = "Split [R]esize Right", noremap = true, silent = true })
set("n", "<leader>rk", "<c-w>+", { desc = "Split [R]esize Up", noremap = true, silent = true })
set("n", "<leader>rj", "<c-w>-", { desc = "Split [R]esize Down", noremap = true, silent = true })
