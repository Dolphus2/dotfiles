#!/bin/bash

# Idempotently patches omarchy's omarchy-launch-webapp script to redirect to the Firefox WebApp profile
set -euo pipefail

XDG_BROWSER="firefox.desktop"
FIREFOX_PROFILE="WebApps"
OMARCHY_BIN="$HOME/.local/share/omarchy/bin"
TARGET="$OMARCHY_BIN/omarchy-launch-webapp"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PATCH_SOURCE="$SCRIPT_DIR/omarchy-launch-webapp.patched"
PATCH_CSS_SOURCE="$SCRIPT_DIR/userChrome.css"
MARKER="# Redirect standard WebApp calls to Firefox WebApp profile"

if [[ ! -f "$TARGET" ]]; then
  echo "ERROR: Target script not found: $TARGET" >&2
  exit 1
fi

if [[ ! -f "$PATCH_SOURCE" ]]; then
  echo "ERROR: Patch source not found: $PATCH_SOURCE" >&2
  exit 1
fi

if [[ ! -f "$PATCH_CSS_SOURCE" ]]; then
  echo "ERROR: CSS source not found: $PATCH_CSS_SOURCE" >&2
  exit 1
fi

xdg-settings set default-web-browser "$XDG_BROWSER"
echo "Default browser set to: $XDG_BROWSER"

# Patch omarchy-launch-webapp

if grep -qF "$MARKER" "$TARGET"; then
  echo "Launch script patch already applied — skipping."
else
  BACKUP="${TARGET}.orig"
  if [[ ! -f "$BACKUP" ]]; then
    cp "$TARGET" "$BACKUP"
    echo "Backup saved: $BACKUP"
  fi

  cp "$PATCH_SOURCE" "$TARGET"
  chmod +x "$TARGET"
  echo "Launch script patch applied: $TARGET"
fi

# Create Firefox WebApps profile

firefox -CreateProfile "$FIREFOX_PROFILE" --headless 2>/dev/null
echo "Firefox profile ready: $FIREFOX_PROFILE"

# Firefox appends a random salt to the profile folder name (e.g. "a1b2c3d4.WebApps"),
# so we locate it dynamically rather than hardcoding the path.

PROFILE_DIR=$(grep -A1 "Name=$FIREFOX_PROFILE" "$HOME/.mozilla/firefox/profiles.ini" \
  | grep "^Path=" \
  | sed 's/^Path=//')

if [[ -z "$PROFILE_DIR" ]]; then
  echo "ERROR: Could not locate Firefox profile directory for '$FIREFOX_PROFILE'" >&2
  exit 1
fi

PROFILE_PATH="$HOME/.mozilla/firefox/$PROFILE_DIR"
TARGET_CHROME_DIR="$PROFILE_PATH/chrome"
TARGET_CSS="$TARGET_CHROME_DIR/userChrome.css"

# Set toolkit.legacyUserProfileCustomizations.stylesheets Can also be set under about:config
USER_JS="$PROFILE_PATH/user.js"
PREF='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'

if grep -qF "toolkit.legacyUserProfileCustomizations.stylesheets" "$USER_JS" 2>/dev/null; then
  echo "userChrome pref already set in user.js — skipping."
else
  echo "$PREF" >> "$USER_JS"
  echo "userChrome pref added to: $USER_JS"
fi

mkdir -p "$TARGET_CHROME_DIR"

if [[ -f "$TARGET_CSS" ]] && diff -q "$PATCH_CSS_SOURCE" "$TARGET_CSS" > /dev/null 2>&1; then
  echo "userChrome.css already up to date — skipping."
else
  cp "$PATCH_CSS_SOURCE" "$TARGET_CSS"
  echo "userChrome.css deployed: $TARGET_CSS"
fi