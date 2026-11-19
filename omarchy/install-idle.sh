#!/bin/bash

# Sets the Omarchy shell idle timeouts (in seconds since idle began).
# Only the idle section of shell.json is changed; the bar layout and other
# settings are left as they are. The shell hot-reloads shell.json on save.
set -euo pipefail

SCREENSAVER_SECONDS=1800 # 30 minutes
LOCK_SECONDS=3600        # 60 minutes; the screensaver never starts once locked,
                         # so this must stay later than the screensaver.

SHELL_CONFIG="$HOME/.config/omarchy/shell.json"

if [[ ! -f "$SHELL_CONFIG" ]]; then
  echo "Omarchy shell config not found at $SHELL_CONFIG" >&2
  echo "Please install Omarchy 4 first" >&2
  exit 1
fi

current=$(jq -c '[.idle.screensaver, .idle.lock]' "$SHELL_CONFIG")
if [[ "$current" == "[$SCREENSAVER_SECONDS,$LOCK_SECONDS]" ]]; then
  echo "Idle timeouts already up to date: screensaver ${SCREENSAVER_SECONDS}s, lock ${LOCK_SECONDS}s"
  exit 0
fi

tmp=$(mktemp "$SHELL_CONFIG.XXXXXX")
trap 'rm -f "$tmp"' EXIT
jq --indent 2 \
  --argjson screensaver "$SCREENSAVER_SECONDS" \
  --argjson lock "$LOCK_SECONDS" \
  '.idle.screensaver = $screensaver | .idle.lock = $lock' \
  "$SHELL_CONFIG" > "$tmp"
chmod --reference="$SHELL_CONFIG" "$tmp"
mv "$tmp" "$SHELL_CONFIG"
trap - EXIT

echo "Idle timeouts set: screensaver ${SCREENSAVER_SECONDS}s, lock ${LOCK_SECONDS}s"
