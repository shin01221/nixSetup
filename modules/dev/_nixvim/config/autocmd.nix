{
  autoGroups = {
    # highlight_yank = { };
    vim_enter = { };
    indentscope = { };
    restore_cursor = { };
    no_auto_comment = { };
  };

  autoCmd = [
    # markdown: disable snacks indent
    {
      event = [ "FileType" ];
      pattern = "markdown";
      callback = {
        __raw = ''
          function()
            vim.b.snacks_indent = false
          end
        '';
      };
    }
    # Auto-reload files changed externally
    {
      event = [
        "FocusGained"
        "BufEnter"
        "CursorHold"
        "CursorHoldI"
      ];
      pattern = "*";
      command = "if mode() != 'c' | checktime | endif";
    }
    # highlight Text on Yank
    # {
    #   group = "highlight_yank";
    #   event = "TextYankPost";
    #   pattern = "*";
    #   callback = {
    #     __raw = "
    #     function()
    #       vim.highlight.on_yank()
    #     end
    #   ";
    #   };
    # }
    {
      group = "indentscope";
      event = [ "FileType" ];
      pattern = [
        "help"
        "Startup"
        "startup"
        "neo-tree"
        "Trouble"
        "trouble"
        "notify"
      ];
      callback = {
        __raw = ''
          function()
            vim.b.miniindentscope_disable = true
          end
        '';
      };
    }
    ## restore cursor position when opening a file
    {
      group = "restore_cursor";
      event = [ "BufReadPost" ];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local line_count = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= line_count then
              vim.api.nvim_win_set_cursor(0, mark)
              vim.schedule(function()
                vim.cmd("normal! zz")
              end)
            end
          end
        '';
      };
    }
    # no auto continue comments on new line
    {
      group = "no_auto_comment";
      event = [ "FileType" ];
      pattern = "*";
      callback = {
        __raw = ''
          function()
            vim.opt_local.formatoptions:remove({ "c", "r", "o" })
          end
        '';
      };
    }
  ];

  userCommands = {
    LspRestart = {
      command.__raw = ''
        function()
          for _, client in ipairs(vim.lsp.get_active_clients()) do
            client:stop()
          end
          vim.cmd("edit")
        end
      '';
    };
  };
}
