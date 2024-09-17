#!/bin/bash
# vim: set ft=sh ts=4 sw=4 et:

major_version=2
vers=

set -e
. /usr/share/makepkg/util/util.sh

warning "This script calls out to github's API to determine the latest"
warning "version and build number. Press Ctrl+C within 2 seconds to abort."
sleep 2

if [ -n "$1" ]; then
    vers="$1"; shift
else
    msg "Getting latest Coder release"
    gh_url="https://api.github.com/repos/coder/coder/git/matching-refs/tags/v${major_version}."
    vers=$(curl -SsLl "${gh_url}" | jq -r 'reverse | .[0].ref' | sed -re 's;^refs/tags/v;;')
    if ! [[ "$vers" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
		echo "Version string "\""${vers}"\"" doesn't look like a valid version number" >&2
		exit 1
    fi
fi

msg "Using Coder version: ${vers}"

sed -re "s;^pkgver=.+$;pkgver=${vers};" -i PKGBUILD

# delete sha512sums, but leave a placeholder as a hint to use sha256 and not md5
sed -zre "s;sha512sums=\('([a-f0-9]{128}|SKIP)'(\n *'([a-f0-9]{128}|SKIP)')*\);sha512sums=('SKIP');g" -i PKGBUILD

makepkg -g >> PKGBUILD
sed -re "/^sha512sums=\('SKIP'\)$/ d" -i PKGBUILD

makepkg --printsrcinfo > .SRCINFO
