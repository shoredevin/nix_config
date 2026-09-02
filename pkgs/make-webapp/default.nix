{ pkgs }:

let
  # 1. The underlying shell script wrapper
  script = pkgs.writeShellApplication {
    name = "make-webapp";
    runtimeInputs = with pkgs; [
      yad libnotify
    ];
    text = ''
      ${builtins.readFile ../../bin/lib/yad-ui.sh}
      ${builtins.readFile ../../bin/make-webapp.sh}
    '';
  };

  # 2. The desktop launcher definition
  desktopItem = pkgs.makeDesktopItem {
    name = "make-webapp";
    desktopName = "Make Web App";
    comment = "Create a desktop launcher for a web app";
    exec = "make-webapp";
    icon = "make-webapp";
    terminal = false;
    type = "Application";
    startupNotify = true;
    startupWMClass = "make-webapp-dialog";
  };

  # 3. Custom icon package
  iconItem = pkgs.runCommand "make-webapp-icon" {} ''
    mkdir -p $out/share/icons/hicolor/48x48/apps
    cp ${./icon.png} $out/share/icons/hicolor/48x48/apps/make-webapp.png
  '';
in

# 4. Merge all outputs into a single valid package
pkgs.symlinkJoin {
  name = "make-webapp";
  paths = [ script desktopItem iconItem ];
}
