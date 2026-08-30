{ pkgs }:

(pkgs.writeShellApplication { 
    name = "bash-gui"; 
    runtimeInputs = [ pkgs.yad ];
    text = builtins.readFile ../../bin/bash-gui.sh;
})
