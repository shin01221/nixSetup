{
  lib,
  pkgs,
  ...
}:
{
  lsp.servers = {
    marksman.enable = true;
  };

  plugins = {
    markdown-preview = {
      enable = true;
    };

    conform-nvim.settings = {
      formatters_by_ft.markdown = [ "deno_fmt" ];
      formatters.deno_fmt = {
        command = "deno";
        args.__raw = ''
          function(self, ctx)
            local ext = vim.fn.expand("%:e")
            if ext == "" then ext = vim.bo.filetype end
            local args = { "fmt", "--ext", ext }
            if ext == "md" or ext == "markdown" then
              vim.list_extend(args, { "--options-prose-wrap", "preserve" })
            end
            table.insert(args, "-")
            return args
          end
        '';
      };
    };

    lint = {
      lintersByFt.markdown = [ "markdownlint" ];
      linters.markdownlint.cmd = lib.getExe pkgs.markdownlint-cli;
    };
  };

  # keymaps = [
  #   {
  #     mode = "n";
  #     key = "<leader>m";
  #     action = "<cmd>MarkdownPreviewToggle<cr>";
  #     options = {
  #       silent = true;
  #       desc = "Toggle markdown preview";
  #     };
  #   }
  # ];
}
