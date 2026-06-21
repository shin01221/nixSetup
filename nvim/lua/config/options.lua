vim.g.vim_markdown_frontmatter = 1
vim.opt.spell = false
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"

-- basic
vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.concealcursor = "c" -- show conceal only in normal and command mode
vim.opt.autoread = true
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldmethod = "expr"
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.g.python3_host_prog = vim.fn.expand("~/.local/venvs/nvim/bin/python")
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wrap = false -- No Wrap lines
vim.o.virtualedit = "block" -- make visual select go beyond the end of the line
vim.opt.shell = "fish"
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.o.splitright = true
vim.o.splitbelow = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.scrolloff = 20
vim.opt.cmdheight = 1
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.inccommand = "split"
vim.o.list = true
vim.o.confirm = true
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight yank",
})
-- enable universal clipboard
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)
-- end basics

-- neovide configs
if vim.g.neovide then
  local config_dir = (vim.env.XDG_CONFIG_HOME and #vim.env.XDG_CONFIG_HOME > 0) and vim.env.XDG_CONFIG_HOME
    or os.getenv("HOME") .. "/.config"

  local function readf(p)
    local f = io.open(p, "r")
    if not f then
      return nil
    end
    local c = f:read("*a")
    f:close()
    return c
  end

  local function val(c, k)
    for l in c:gmatch("[^\r\n]+") do
      local a, b = l:match("^%s*([%w-]+)%s*=%s*(.-)%s*$")
      if a and a == k then
        return b:match('^"(.*)"$') or b:match("^'(.*)'$") or b
      end
    end
  end

  local c = readf(config_dir .. "/ghostty/config")
  local bg
  if c then
    bg = val(c, "background")
      or (val(c, "theme") and val(readf(config_dir .. "/ghostty/themes/" .. val(c, "theme")), "background"))
  end

  if bg then
    local function apply()
      vim.api.nvim_set_hl(0, "Normal", { bg = bg })
    end
    apply()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = apply,
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.schedule(apply)
      end,
    })
  end

  vim.g.neovide_theme = "dark"
  vim.o.guifont = "DejaVu Sans Mono:h11"
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_right = 20
  vim.g.neovide_padding_left = 20
end

-- lsps
-- vim.lsp.enable("copilot")
vim.env.JAVA_HOME = "/usr/lib/jvm/java-17-openjdk"
vim.env.PATH = vim.env.JAVA_HOME .. "/bin:" .. vim.env.PATH
