
if [ -z "$1" ]; then
 file="configuration.nix"
else
   if [ "1" = "-c" ]; then
     file="configuration.nix"
   fi
   if [ "$1" = "-f" ]; then
      file="flake.nix"
   fi
   if [ $1 = "-u" ]; then
     file="users/dshore/default.nix"
   fi
   # file=$1
fi
if [ -z "$file" ]; then
  echo "$1 is not a valid argument"
  exit -1
fi


nano "~/Documents/nix_config/$file";
