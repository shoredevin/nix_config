#!/usr/bin/env bash

# Resolve the current booted generation path
BOOTED_GEN=$(readlink -f /run/booted-system)

# Resolve the latest system profile generation path
CURRENT_GEN=$(readlink -f /nix/var/nix/profiles/system)

# If the booted generation doesn't match the current profile, a reboot is pending
if [ "$BOOTED_GEN" != "$CURRENT_GEN" ]; then
	notify-send -u critical \
		-a "system Update" \
	    -i system-software-update \
	    -t 0 \
	    "System Update Pending" \
	    "A new NixOS generation has been built. Restart to apply updates."
fi
