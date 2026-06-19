{
  config,
  pkgs,
  lib,
  ...
}:
let
  associations = {
    # nvim
    "application/json" = "nvim.desktop";
    "text/english" = "nvim.desktop";
    "text/plain" = "nvim.desktop";
    "text/x-makefile" = "nvim.desktop";
    "text/x-c++hdr" = "nvim.desktop";
    "text/x-c++src" = "nvim.desktop";
    "text/x-chdr" = "nvim.desktop";
    "text/x-csrc" = "nvim.desktop";
    "text/x-java" = "nvim.desktop";
    "text/x-moc" = "nvim.desktop";
    "text/x-pascal" = "nvim.desktop";
    "text/x-tcl" = "nvim.desktop";
    "text/x-tex" = "nvim.desktop";
    "application/x-shellscript" = "nvim.desktop";
    "text/x-c" = "nvim.desktop";
    "text/x-c++" = "nvim.desktop";

    # zen browser
    "text/html" = "app.zen_browser.zen.desktop";
    "application/pdf" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/ftp" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/about" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/unknown" = "app.zen_browser.zen.desktop";

    # gwenview
    "image/avif" = "org.kde.gwenview.desktop";
    "image/bmp" = "org.kde.gwenview.desktop";
    "image/gif" = "org.kde.gwenview.desktop";
    "image/jpeg" = "org.kde.gwenview.desktop";
    "image/jpg" = "org.kde.gwenview.desktop";
    "image/png" = "org.kde.gwenview.desktop";
    "image/svg+xml" = "org.kde.gwenview.desktop";
    "image/tiff" = "org.kde.gwenview.desktop";
    "image/webp" = "org.kde.gwenview.desktop";
    "image/x-bmp" = "org.kde.gwenview.desktop";
    "image/x-portable-bitmap" = "org.kde.gwenview.desktop";
    "image/x-portable-graymap" = "org.kde.gwenview.desktop";
    "image/x-portable-pixmap" = "org.kde.gwenview.desktop";
    "image/x-tga" = "org.kde.gwenview.desktop";

    # mpv
    "audio/aac" = "mpv.desktop";
    "audio/flac" = "mpv.desktop";
    "audio/m4a" = "mpv.desktop";
    "audio/mp3" = "mpv.desktop";
    "audio/mpeg" = "mpv.desktop";
    "audio/ogg" = "mpv.desktop";
    "audio/wav" = "mpv.desktop";
    "audio/webm" = "mpv.desktop";
    "audio/x-flac" = "mpv.desktop";
    "audio/x-m4a" = "mpv.desktop";
    "audio/x-matroska" = "mpv.desktop";
    "audio/x-vorbis" = "mpv.desktop";
    "audio/x-wav" = "mpv.desktop";
    "video/3gpp" = "mpv.desktop";
    "video/avi" = "mpv.desktop";
    "video/mp2t" = "mpv.desktop";
    "video/mp4" = "mpv.desktop";
    "video/mpeg" = "mpv.desktop";
    "video/ogg" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/x-flv" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/x-mpeg" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
    "video/x-ms-wmv" = "mpv.desktop";

    # libreoffice
    "application/msword" = "writer.desktop";
    "application/rtf" = "writer.desktop";
    "application/vnd.oasis.opendocument.text" = "writer.desktop";
    "application/vnd.oasis.opendocument.text-template" = "writer.desktop";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = "writer.desktop";
    "application/vnd.ms-word" = "writer.desktop";
    "application/vnd.ms-word.document.macroEnabled.12" = "writer.desktop";
    "application/vnd.wordperfect" = "writer.desktop";
    "text/csv" = "calc.desktop";
    "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
    "application/vnd.oasis.opendocument.spreadsheet-template" = "calc.desktop";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.template" = "calc.desktop";
    "application/vnd.ms-excel" = "calc.desktop";
    "application/vnd.ms-excel.sheet.macroEnabled.12" = "calc.desktop";
    "application/vnd.oasis.opendocument.presentation" = "impress.desktop";
    "application/vnd.oasis.opendocument.presentation-template" = "impress.desktop";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "impress.desktop";
    "application/vnd.openxmlformats-officedocument.presentationml.slideshow" = "impress.desktop";
    "application/vnd.ms-powerpoint" = "impress.desktop";
    "application/vnd.ms-powerpoint.presentation.macroEnabled.12" = "impress.desktop";
    "application/vnd.oasis.opendocument.database" = "base.desktop";
    "application/vnd.oasis.opendocument.graphics" = "draw.desktop";
    "application/vnd.oasis.opendocument.formula" = "math.desktop";

    # calibre
    "application/epub+zip" = "calibre-gui.desktop";
    "application/x-mobipocket-ebook" = "calibre-gui.desktop";
    "application/vnd.amazon.ebook" = "calibre-gui.desktop";
    "application/x-cbr" = "calibre-gui.desktop";
    "application/x-cbz" = "calibre-gui.desktop";

    # ark
    "application/gzip" = "org.kde.ark.desktop";
    "application/x-7z-compressed" = "org.kde.ark.desktop";
    "application/x-archive" = "org.kde.ark.desktop";
    "application/x-arj" = "org.kde.ark.desktop";
    "application/x-bzip" = "org.kde.ark.desktop";
    "application/x-bzip-compressed-tar" = "org.kde.ark.desktop";
    "application/x-bzip1" = "org.kde.ark.desktop";
    "application/x-bzip1-compressed-tar" = "org.kde.ark.desktop";
    "application/x-cabinet" = "org.kde.ark.desktop";
    "application/x-compress" = "org.kde.ark.desktop";
    "application/x-compressed-tar" = "org.kde.ark.desktop";
    "application/x-cpio" = "org.kde.ark.desktop";
    "application/x-deb" = "org.kde.ark.desktop";
    "application/x-ear" = "org.kde.ark.desktop";
    "application/x-gtar" = "org.kde.ark.desktop";
    "application/x-gzip" = "org.kde.ark.desktop";
    "application/x-gzip-compressed-tar" = "org.kde.ark.desktop";
    "application/x-iso9660-image" = "org.kde.ark.desktop";
    "application/x-java-archive" = "org.kde.ark.desktop";
    "application/x-lha" = "org.kde.ark.desktop";
    "application/x-lhz" = "org.kde.ark.desktop";
    "application/x-lrzip" = "org.kde.ark.desktop";
    "application/x-lrzip-compressed-tar" = "org.kde.ark.desktop";
    "application/x-lz4" = "org.kde.ark.desktop";
    "application/x-lz4-compressed-tar" = "org.kde.ark.desktop";
    "application/x-lzip" = "org.kde.ark.desktop";
    "application/x-lzip-compressed-tar" = "org.kde.ark.desktop";
    "application/x-lzma" = "org.kde.ark.desktop";
    "application/x-lzma-compressed-tar" = "org.kde.ark.desktop";
    "application/x-lzo" = "org.kde.ark.desktop";
    "application/x-lzo-compressed-tar" = "org.kde.ark.desktop";
    "application/x-rar" = "org.kde.ark.desktop";
    "application/x-rar-compressed" = "org.kde.ark.desktop";
    "application/x-rpm" = "org.kde.ark.desktop";
    "application/x-rzip" = "org.kde.ark.desktop";
    "application/x-tar" = "org.kde.ark.desktop";
    "application/x-tarz" = "org.kde.ark.desktop";
    "application/x-tgz" = "org.kde.ark.desktop";
    "application/x-xar" = "org.kde.ark.desktop";
    "application/x-xz" = "org.kde.ark.desktop";
    "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
    "application/x-zip" = "org.kde.ark.desktop";
    "application/x-zip-compressed" = "org.kde.ark.desktop";
    "application/x-zoo" = "org.kde.ark.desktop";
    "application/zip" = "org.kde.ark.desktop";
    "application/zstd" = "org.kde.ark.desktop";
    "application/x-zstd-compressed-tar" = "org.kde.ark.desktop";

    # file manager
    "inode/directory" = "org.kde.dolphin.desktop";
  };
in
{
  xdg.configFile."mimeapps.list".force = true;
  xdg.configFile."user-dirs.dirs".force = true;
  xdg.configFile."user-dirs.conf".force = true;

  home.preferXdgDirectories = true;

  xdg = {
    enable = true;
    portal = {
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [ "gtk" ];
      };
    };

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;

      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      desktop = "${config.home.homeDirectory}/Desktop";
      videos = "${config.home.homeDirectory}/Videos";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      publicShare = "${config.home.homeDirectory}/Public/share";
      templates = "${config.home.homeDirectory}/Public/templates";

      extraConfig = {
        SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
        DEV = "${config.home.homeDirectory}/dev";
      };
    };

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };

  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    GNUPGHOME = "${config.home.homeDirectory}/.local/share/gnupg";
  };
}
