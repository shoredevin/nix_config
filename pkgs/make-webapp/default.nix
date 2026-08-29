{ pkgs }:

pkgs.writeShellApplication {
  name = "make-webapp";
  runtimeInputs = with pkgs; [
    gum curl file gnused gnugrep gtk3
  ];
  text = builtins.readFile ../../bin/make-webapp.sh;
}