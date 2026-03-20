# echo $1

if [ -z "$1" ]; then
  hostname=$(hostname)
else
  hostname=$1
fi

# echo "hostname: $hostname"

sudo nixos-rebuild switch --impure --flake ~/Documents/nix_config#$hostname
