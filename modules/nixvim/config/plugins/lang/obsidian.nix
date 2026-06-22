{
  plugins.obsidian = {
    enable = true;
    settings = {
      note_id_func.__raw = ''
        function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      '';
      legacy_commands = false;
      workspaces = [
        {
          name = "shin";
          path = "/Media/Docs/notes";
        }
      ];
      checkbox = {
        enabled = true;
        create_new = true;
        order = [
          " "
          "x"
          "!"
        ];
      };
      daily_notes = {
        folder = "dailies";
        date_format = "%Y-%m-%d";
        alias_format = "%B %-d, %Y";
        default_tags = [ "dailies" ];
        template = null;
      };
      attachments.folder = "assets/imgs";
      templates = {
        subdir = "templates";
        date_format = "%Y-%m-%d";
        time_format = "%H:%M:%S";
      };
      ui.enable = false;
      completion.min_chars = 2;
      footer.enabled = false;
    };
  };

  extraConfigLua = ''
    local keymap = vim.keymap
    keymap.set("n", "<leader>o", "", { desc = "+obsidian" })
    keymap.set("n", "<leader>of", "", { desc = "+formatting" })
    keymap.set("v", "<leader>ofb", ":lua require('markdowny').bold()<cr>", { desc = "bold" })
    keymap.set("v", "<leader>ofi", ":lua require('markdowny').italic()<cr>", { desc = "italic" })
    keymap.set("v", "<leader>ofl", ":lua require('markdowny').link()<cr>", { desc = "link" })
    keymap.set("v", "<leader>ofe", ":lua require('markdowny').code()<cr>", { desc = "code block" })
    keymap.set("v", "<leader>oll", "<cmd>Obsidian link_new<cr>", { desc = "New Link" })
    keymap.set("n", "<leader>ols", "<cmd>Obsidian links<cr>", { desc = "Search Links" })
    keymap.set("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Paste Image" })
    keymap.set("n", "<leader>or", "<cmd>Obsidian rename<cr>", { desc = "rename note" })
    keymap.set("n", "<leader>oll", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "toggle checkbox" })
    keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Note" })
    keymap.set("n", "<leader>og", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
    keymap.set("n", "<leader>os", function()
      if vim.fn.exists(":Obsidian quick_switch") == 2 then
        vim.cmd("Obsidian quick_switch")
      else
        Snacks.picker.files({ cwd = vim.fn.expand("/Media/Docs/notes/") })
      end
    end)
    keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Search backlinks" })
    keymap.set("n", "<leader>ot", "<cmd>Obsidian new_from_template<cr>", { desc = "New Note with template" })
    keymap.set("n", "<leader>od", "<cmd>Obsidian dailies<cr>", { desc = "New Daily Note" })
    keymap.set("n", "<leader>oh", "<cmd>Obsidian tags<cr>", { desc = "Search Tags" })
    keymap.set("n", "<leader>oc", "<cmd>Obsidian toc<cr>", { desc = "TOC search" })
    keymap.set("n", "<leader>oP", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle markdown preview" })
  '';
}
