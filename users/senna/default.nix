{ config, lib, pkgs, modulePath, ... }:

{
  users.users.senna = {
    isNormalUser = true;
    description = "Senna Shore";
	extraGroups = [ "networkmanager" ];
	initialPassword = "senna";
	packages = with pkgs; [
      neovim
    ];
  };
}
