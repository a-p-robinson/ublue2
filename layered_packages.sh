#!/bin/bash
## Install our layered packages on Fedora SIlverblue
set -eu

[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

BITS=./bits
source $BITS/common

echo "Checking base layer..."
while ! is_ostree_idle; do
    echo "Waiting for rpm-ostree..."
    sleep 5
done

if rpm-ostree override remove firefox > /dev/null; then
    echo "Removed Firefox from base layer."
fi

# --idempotent seems to fix running this multiple times
echo "Installing layered packages..."
cat layered-packages.list | rpm-ostree --idempotent install `xargs`

# Install VScode layered (why?)
source $BITS/vscode

# Bug fix
sudo grub2-mkconfig
sudo rpm-ostree update

echo "You should reboot!"
exit 0;
