{ pkgs, makeWebapp, copyDesktopItems, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "make-webapp";
    desktopName = "Make Web App";
    comment = "Create a desktop launcher for a web app";
    exec = "make-webapp-gui";
    terminal = false;
    type = "Application";
    icon = "${./icon.png}";
    startupNotify = true;
    startupWMClass = "make-webapp-dialog";
  };
in
pkgs.symlinkJoin {
  name = "make-webapp-gui";
  paths = [
    (pkgs.writeScriptBin "make-webapp-gui" ''
      #!${pkgs.stdenv.shell}
      
      exec ${pkgs.foot}/bin/foot \
        -a "make-webapp-dialog" \
        -T "Make Web App" \
        -f "monospace:size=14" \
        -w "700x480" \
        -o "pad=24x20" \
        -o "colors-dark.background=1e1e2e" \
        -o "colors-dark.foreground=cdd6f4" \
        -o "colors-dark.regular0=45475a" \
        -o "colors-dark.regular1=f38ba8" \
        -o "colors-dark.regular2=a6e3a1" \
        -o "colors-dark.regular3=f9e2af" \
        -o "colors-dark.regular4=89b4fa" \
        -o "colors-dark.regular5=f5c2e7" \
        -o "colors-dark.regular6=94e2d5" \
        -o "colors-dark.regular7=bac2de" \
        -o "colors-dark.bright0=585b70" \
        -o "colors-dark.bright1=f38ba8" \
        -o "colors-dark.bright2=a6e3a1" \
        -o "colors-dark.bright3=f9e2af" \
        -o "colors-dark.bright4=89b4fa" \
        -o "colors-dark.bright5=f5c2e7" \
        -o "colors-dark.bright6=94e2d5" \
        -o "colors-dark.bright7=a6adc8" \
        -o "colors-dark.selection-foreground=cdd6f4" \
        -o "colors-dark.selection-background=45475a" \
        ${makeWebapp}/bin/make-webapp
    '')
  ];

  postBuild = ''
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';
}