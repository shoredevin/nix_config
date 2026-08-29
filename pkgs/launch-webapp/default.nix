{ pkgs }:

(pkgs.writeShellApplication { 
    name = "launch-webapp"; 
    runtimeInputs = [ pkgs.chromium ];
    text = builtins.readFile ../../bin/launch-web-app.sh;
})