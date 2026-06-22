{ ... }:

{
  config = {
    extraConfigLuaPre = ''
      vim.fn.sign_define("diagnosticsignerror", { text = " ", texthl = "diagnosticerror", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignwarn", { text = " ", texthl = "diagnosticwarn", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsignhint", { text = "󰌵", texthl = "diagnostichint", linehl = "", numhl = "" })
      vim.fn.sign_define("diagnosticsigninfo", { text = " ", texthl = "diagnosticinfo", linehl = "", numhl = "" })

      vim.o.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"
      vim.o.backspace = "start,eol,indent"

      vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
        pattern = "*",
        callback = function()
          vim.highlight.on_yank({ timeout = 5 })
        end,
        desc = "Highlight yank",
      })

      if vim.g.neovide then
        vim.g.neovide_theme = "dark"
        vim.o.guifont = "DejaVu Sans Mono:h11"
        vim.g.neovide_padding_top = 0
        vim.g.neovide_padding_right = 20
        vim.g.neovide_padding_left = 20
      end
    '';

    globals = {
      # Disable useless providers
      loaded_ruby_provider = 0; # Ruby
      loaded_perl_provider = 0; # Perl
      loaded_python_provider = 0; # Python 2
      vim_markdown_frontmatter = 1;
    };

    # feature that enhances the way Neovim loads and executes Lua modules,
    # offering improved performance and flexibility.
    luaLoader.enable = true;

    clipboard.providers.wl-copy.enable = true;

    opts = {
      clipboard = "unnamedplus";
      # Performance & Timing
      updatetime = 100; # CursorHold delay; faster completion and git signs
      lazyredraw = false; # Breaks noice plugin
      synmaxcol = 240; # Disable syntax highlighting for long lines
      timeoutlen = 500; # Key sequence timeout (ms)
      # timeoutlen = 250;

      # UI & Appearance
      ## Enable relative line numbers
      number = true;
      relativenumber = true;
      cursorline = true; # Highlight the line where the cursor is located
      cursorcolumn = false;
      signcolumn = "yes"; # Enable the sign column to prevent the screen from jumping
      laststatus = 3; # Global statusline
      showmode = false; # Don't show the editor mode in status line
      showmatch = true;
      matchtime = 1; # Flash duration in deciseconds
      termguicolors = true; # Better colors
      winborder = "rounded";

      # Windows & Splits
      splitbelow = true;
      splitright = true;

      # Search
      incsearch = true;
      ignorecase = true; # Case-insensitive search
      smartcase = true; # Unless pattern contains uppercase
      hlsearch = true;

      # Files & Buffers
      swapfile = false;
      undofile = true;
      autoread = true;
      writebackup = false;
      fileencoding = "utf-8";
      modeline = true; # Scan for editor directives like 'vim: set ft=nix:'
      modelines = 100; # Scan first/last 100 lines for modelines

      # Indentation & Formatting
      tabstop = 4; # Tab spacing 4 spaces
      shiftwidth = 4;
      expandtab = true;
      autoindent = true;
      breakindent = true; # Smart indent on word wrap
      copyindent = true;
      preserveindent = true;
      linebreak = true;
      wrap = false;

      # Completion & Popup
      pumheight = 10; # Maximum number of items to show in the popup menu (0 means "use available screen space")
      infercase = true;

      # Command Line & Messages
      cmdheight = 0; # Hide command line when not in use
      history = 100; # Command history limit
      report = 9001; # Disable "x more/fewer lines" messages

      # Editor Behavior
      virtualedit = "block"; # Allow cursor to move where there is no text in visual block mode
      startofline = true;
      title = true;
      conceallevel = 2;
      concealcursor = "c";
      smarttab = true;
      smartindent = true;
      shell = "fish";
      confirm = true;
      list = true;

      # cmdheight = 2; # more space in the neovim command line for displaying messages

      # softtabstop = 2;

      # smartindent = true;

      backup = false;

      grepprg = "rg --vimgrep";
      grepformat = "%f:%l:%c:%m";

      scrolloff = 8; # Will never have less than 8 characters as you scroll down
      mouse = "a"; # Mouse

      # Set encoding type
      encoding = "utf-8";
    };
  };
}
