{ pkgs }:

(pkgs.writeShellApplication { 
  name = "run-test"; 
  runtimeInputs = [ pkgs.coreutils pkgs.yad ];
  text = ''
    ${builtins.readFile ../../bin/lib/yad-ui.sh}
    ${builtins.readFile ./bin/test.sh}
  '';
})
