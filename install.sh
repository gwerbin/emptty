#!/bin/sh

set -eu

contains() {
	string="$1"
	substring="$2"
	if test "${string#*$substring}" != "$string"
	then
		return 0    # $substring is in $string
	else
		return 1    # $substring is not in $string
	fi
}

ISSUE=$( tr '[:upper:]' '[:lower:]' < /etc/issue )

set -x

if contains "$ISSUE" 'suse'
then
	sudo zypper install gcc go pam-devel libx11-devel
elif contains "$ISSUE" 'fedora'
	#sudo dnf install ???
elif contains "$ISSUE" 'debian'
then
	sudo apt install gcc golang-go libpam0g-dev libx11-dev
fi

make build
sudo make install install-manual install-config install-motd-gen install-systemd

if contains "$ISSUE" 'suse'
then
	sudo make install-pam-suse
if contains "$ISSUE" 'fedora'
then
	sudo make install-pam-fedora
elif contains "$ISSUE" 'debian'
then
	sudo make install-pam-debian
fi

# TODO: RPM & DEB packages
