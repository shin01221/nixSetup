local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "NextBuffer" })
-- keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "PrevBuffer" })
-- plugins

-- tree walker

-- movement
vim.keymap.set({ "n", "v" }, "<leader>k", "<cmd>Treewalker Up<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>j", "<cmd>Treewalker Down<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>h", "<cmd>Treewalker Left<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>l", "<cmd>Treewalker Right<cr>", { silent = true })

-- swapping
vim.keymap.set("n", "<A-k>", "<cmd>Treewalker SwapUp<cr>", { silent = true })
vim.keymap.set("n", "<A-j>", "<cmd>Treewalker SwapDown<cr>", { silent = true })
vim.keymap.set("n", "<A-h>", "<cmd>Treewalker SwapLeft<cr>", { silent = true })
vim.keymap.set("n", "<A-l>", "<cmd>Treewalker SwapRight<cr>", { silent = true })

-- keymap.set("n", "tt", vim.cmd.Themery)
keymap.set("n", "tt", "<cmd>Themify<cr>")
-- toggle markview
keymap.set("n", "<leader>um", "<cmd>Markview Toggle<cr>", { desc = "Toggle markdwon" })
--toggle top bar buffer on or off
keymap.set("n", "<leader>us", function()
  if vim.o.showtabline == 0 then
    vim.o.showtabline = 2
  else
    vim.o.showtabline = 0
  end
end, { desc = "Toggle bufferline visibility" })
vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({
    lsp_format = "fallback",
  })
end, { desc = "Format current file" })

-- obsidian  keymaps
-- keymap.set("n", "<leader>os", function()
-- 	Snacks.picker.files({
-- 		cwd = "/Media/Docs/notes/",
-- 	})
-- end, { desc = "Notes search" })
-- keymap.set("v", "<leader>ox", "<cmd>Obsidian extract_note", { desc = "Note Extract" })

keymap.set("n", "<leader>o", "", { desc = "+obsidian" })
keymap.set("n", "<leader>of", "", { desc = "+formating" })
keymap.set("v", "<leader>ofb", ":lua require('markdowny').bold()<cr>", { desc = "bold" })
keymap.set("v", "<leader>ofi", ":lua require('markdowny').italic()<cr>", { desc = "italic" })
keymap.set("v", "<leader>ofl", ":lua require('markdowny').link()<cr>", { desc = "link" })
keymap.set("v", "<leader>ofe", ":lua require('markdowny').code()<cr>", { desc = "code block" })
keymap.set("v", "<leader>oll", "<cmd>Obsidian link_new<cr>", { desc = "New Link" })
keymap.set("n", "<leader>ols", "<cmd>Obsidian links<cr>", { desc = "Search Links" })
keymap.set("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Paste Image" })
keymap.set("n", "<leader>or", "<cmd>Obsidian rename<cr>", { desc = "rename note" })
keymap.set("n", "<leader>l", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "toggle checkbox" })
keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Note" })
keymap.set("n", "<leader>og", "<cmd>Obsidian search<cr>", { desc = "Search notes" })

vim.keymap.set("n", "<leader>os", function()
  if vim.fn.exists(":Obsidian quick_switch") == 2 then
    vim.cmd("Obsidian quick_switch")
  else
    Snacks.picker.files({
      cwd = vim.fn.expand("/Media/Docs/notes/"),
    })
  end
end)

keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Search backlinks" })
keymap.set("n", "<leader>ot", "<cmd>Obsidian new_from_template<cr>", { desc = "New Note with template" })
keymap.set("n", "<leader>od", "<cmd>Obsidian dailies<cr>", { desc = "New Daily Note" })
keymap.set("n", "<leader>oh", "<cmd>Obsidian tags<cr>", { desc = "Search Tags" })
keymap.set("n", "<leader>oc", "<cmd>Obsidian toc<cr>", { desc = "TOC search" })
keymap.set("n", "<leader>oP", vim.cmd.MarkdownPreviewToggle, { desc = "Toggle markdown preview" })

-- convienince

-- keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "NextBuffer" })
-- keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "PrevBuffer" })
vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "NextBuffer" })
keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "PrevBuffer" })

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Select all
keymap.set("n", "aa", "gg<S-v>G")
keymap.set("n", "<C-a>", "gg<S-v>G")
keymap.set("n", "vv", "0v$h")
keymap.set("i", "jj", "<esc>")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "gf", "<C-W>gf")

-- deletion don't affect buffer
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
keymap.set("n", "qq", vim.cmd.q)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
keymap.set("n", "<c-k>", "<C-w>k")
keymap.set("n", "c-j>", "<C-w>j")
keymap.set("n", "c-h>", "<C-w>h")
keymap.set("n", "<c-l>", "<C-w>l")

-- resize window
keymap.set("n", "<C-w><l>", "<C-w><")
keymap.set("n", "<C-w><h>", "<C-w>>")
keymap.set("n", "<C-w><j>", "<C-w>+")
keymap.set("n", "<C-w><k>", "<C-w>-")

-- move highlited text
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
