{ pkgs }:

(pkgs.writeShellApplication { 
      name = "update-n"; 
	  runtimeInputs = [ pkgs.coreutils pkgs.libnotify ];
      text = builtins.readFile ../../bin/pending-update-notification.sh;
})
