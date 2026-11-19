#!/bin/bash

# Removes unwanted Omarchy preinstalled web apps if they are present.
set -euo pipefail

WEBAPPS=(
  "Basecamp"
  "HEY"
  "X"
  "YouTube"
  "Google Photos"
  "Google Messages"
)

DESKTOP_DIR="$HOME/.local/share/applications"

for app in "${WEBAPPS[@]}"; do
  if [[ -f "$DESKTOP_DIR/$app.desktop" ]]; then
    OMARCHY_REMOVE_NOTIFY=false omarchy webapp remove "$app"
    echo "Removed web app: $app"
  else
    echo "Web app not installed: $app — skipping."
  fi
done

# HEY registers itself as the mailto handler; drop the entry so mailto links
# don't point at a launcher that no longer exists.
MIMEAPPS="$HOME/.config/mimeapps.list"
if [[ -f "$MIMEAPPS" ]] && grep -q '^x-scheme-handler/mailto=HEY.desktop$' "$MIMEAPPS"; then
  sed -i '/^x-scheme-handler\/mailto=HEY.desktop$/d' "$MIMEAPPS"
  echo "Removed HEY as the mailto handler."
fi
