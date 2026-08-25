hostname=$(hostname)
if [ -z "$1" ]; then
 file="flake.nix"
else
   if [ "$1" = "-c" ]; then
     file="/modules/core/common.nix"
   fi
   if [ "$1" = "-f" ]; then
      file="flake.nix"
   fi
   if [ "$1" = "-u" ]; then
     file="users/dshore/default.nix"
   fi
   if [ "$1" = "-h" ]; then
	 file="hosts/$hostname/default.nix"
   fi
fi

if [ -z "$file" ]; then
  echo "$1 is not a valid argument. Valid arguments are: -c -f -u -h"
  exit -1
fi

nano "~/Documents/nix_config/$file";
