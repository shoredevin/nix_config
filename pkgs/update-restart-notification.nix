{ pkgs }:

(pkgs.writeShellApplication { 
      name = "update-n"; 
	  runtimeInputs = [ pkgs.libnotify ];
      text = builtins.readFile ../bin/update-restart-notification.sh;
})
