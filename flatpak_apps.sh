#!/bin/bash
## Install flatpak packages on Fedora Silverblue

set -eu

[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}

BITS=./bits
source $BITS/common

# Add flathub to the flatpak remotes
echo "Enabling FlatHub.."
flatpak remote-modify --enable flathub
echo "Installing Flatpak(s)..."
flatpak_install_remote flathub https://flathub.org/repo/flathub.flatpakrepo

# Install the applications from the list
flatpak_install flathub applications.list

# Configure Flatpak automatic upgrades
source $BITS/flatpak_automatic_updates

# Allow PWA in chromium browsers (which are flatpaks)
cd $BITS
source ./chromium-browsers
cd -

exit 0;
