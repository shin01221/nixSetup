{
  plugins = {
    bufferline = {
      enable = true;
      settings = {
        options = {
          diagnostics = "nvim_lsp";
          diagnostics_indicator = /* Lua */ ''
            function(count, level, diagnostics_dict, context)
              local s = ""
              for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " "
                  or (e == "warning" and " " or "" )
                if(sym ~= "") then
                  s = s .. " " .. n .. sym
                end
              end
              return s
            end
          '';
          # Will make sure all names in bufferline are unique
          enforce_regular_tabs = false;
          always_show_bufferline = false;

          offsets = [
            {
              filetype = "neo-tree";
              text = "Neo-tree";
              highlight = "Directory";
              text_align = "left";
            }
          ];

          left_trunc_marker = "";
          max_name_length = 18;
          max_prefix_length = 15;
          modified_icon = "●";

          persist_buffer_sort = true;
          right_trunc_marker = "";
          separator_style = "slope";
          show_buffer_close_icons = true;
          show_buffer_icons = true;
          show_close_icon = true;
          show_tab_indicators = true;
          sort_by = "extension";
          tab_size = 18;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-Tab>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = {
        desc = "Cycle to next buffer";
      };
    }

    {
      mode = "n";
      key = "<C-S-Tab>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = {
        desc = "Cycle to previous buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>br";
      action = "<cmd>BufferLineCloseRight<cr>";
      options = {
        desc = "Delete buffers to the right";
      };
    }

    {
      mode = "n";
      key = "<leader>bl";
      action = "<cmd>BufferLineCloseLeft<cr>";
      options = {
        desc = "Delete buffers to the left";
      };
    }

    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineTogglePin<cr>";
      options = {
        desc = "Toggle pin";
      };
    }

    {
      mode = "n";
      key = "<leader>bP";
      action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
      options = {
        desc = "Delete non-pinned buffers";
      };
    }
  ];
}
