#!/bin/sh
startdir="$1"
[ -n "$startdir" ] && [ -d "$startdir" ] || exit 1
cd "$(dirname "$0")"
HDIR="$startdir/liveenv"
PKGSDIR="$startdir/PKGS"
LOCALDIR="$startdir/local"
RDIR="$HDIR"/root
doinst="$HDIR"/doinst
modtxt="$HDIR"/MODIFICATIONS

cat <<EOF >> "$modtxt"
slackware-live-installer
-------------------
- add a Slackware Live Installer icon in the user 'one' desktop.


EOF

SLACKWARELIVEINSTALLER="$(readlink -f "$(ls -1 "$PKGSDIR"/sli-*.txz "$LOCALDIR"/sli-*.txz 2>/dev/null | head -n 1)")"
if [ -n "$SLACKWARELIVEINSTALLER" ]; then
  tar xf "$SLACKWARELIVEINSTALLER" usr/share/applications
  mkdir -p "$RDIR"/home/one/Desktop
  cp usr/share/applications/*.desktop "$RDIR"/home/one/Desktop/
  rm -rf usr
else
  echo "Cannot add $0 because package slackware-live-installer is missing in PKGS." >&2
  exit 1
fi
