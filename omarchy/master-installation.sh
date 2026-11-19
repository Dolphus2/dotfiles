#!/bin/sh

. ./install-firefox.sh
. ./install-stow.sh
# . ./install-copyq.sh
# . ./install-flameshot.sh

. ./install-overrides.sh
# Disabled: Omarchy 4.5 ships omarchy-launch-webapp as a package file under
# /usr/share/omarchy, so this patch no longer applies. Web apps use Chromium.
# . ./patch-omarchy-webapp-launcher.sh
