{ config, pkgs, lib, ... }:

{
  sops.secrets."user_age_key" = {
    path = "/home/dshore/.config/sops/age/keys.txt";
    owner = "dshore";
    group = "users";
    mode = "0400";
  };
}
