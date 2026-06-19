{
  config,
  pkgs,
  ...
}:
{
  xdg.configFile."menus/applications.menu".text = builtins.readFile ./applications.menu;

  xdg.configFile."dolphinrc" = {
    text = ''
      [DetailsMode]
      PreviewSize=32

      [General]
      GlobalViewProps=false
      RememberOpenedTabs=false
      ShowFullPath=true
      ShowFullPathInTitleBar=true
      Version=202

      [IconsMode]
      IconSize=80
      PreviewSize=96

      [InformationPanel]
      dateFormat=ShortFormat

      [KFileDialog Settings]
      Places Icons Auto-resize=false
      Places Icons Static Size=22

      [MainWindow]
      MenuBar=Disabled

      [UiSettings]
      ColorScheme=noctalia

      [PreviewSettings]
      Plugins=ffmpegthumbnailer,appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,gsf-office,opendocumentthumbnail,svgthumbnail,ffmpegthumbs
    '';
  };

  home.packages = with pkgs; [
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    kdePackages.qtimageformats
  ];
}
