{
  plugins = {
    nvim-lightbulb = {
      enable = false;

      lazyLoad.settings.event = "DeferredUIEnter";

      settings = {
        autocmd = {
          enabled = true;
          updatetime = 200;
        };

        line = {
          enabled = true;
        };

        number = {
          enabled = true;
        };

        sign = {
          enabled = true;
          text = " 󰌶";
        };

        status_text = {
          enabled = true;
          text = " 󰌶 ";
        };
      };
    };
  };
}
