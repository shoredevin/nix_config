
if [ -z "$1" ]; then
  hostname=$(hostname)
else
  if [ "$1" = "-u" ]; then
  	hostname=$(hostname)
  else
    hostname=$1
  fi
fi

if [[ "$1" = "-u" || "$2" = "-u" ]]; then
  sudo nix flake update
fi

sudo nixos-rebuild switch --flake ~/Documents/nix_config#$hostname
