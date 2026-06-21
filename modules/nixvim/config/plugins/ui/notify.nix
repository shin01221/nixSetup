{
  plugins = {
    notify = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings = {
        background_colour = "#000000";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>un";
      action = ''
        <cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>
      '';
      options = {
        desc = "Dismiss All Notifications";
      };
    }
  ];
}
