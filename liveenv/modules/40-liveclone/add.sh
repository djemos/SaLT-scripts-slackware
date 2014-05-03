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
liveclone
---------
- add a Liveclone icon in the user 'one' desktop.


EOF

LIVECLONE="$(readlink -f "$(ls -1 "$PKGSDIR"/liveclone-*.txz "$LOCALDIR"/liveclone-*.txz 2>/dev/null | head -n 1)")"
if [ -n "$LIVECLONE" ]; then
  tar xf "$LIVECLONE" usr/share/applications
  mkdir -p "$RDIR"/home/one/Desktop
  cp usr/share/applications/*.desktop "$RDIR"/home/one/Desktop/
  rm -rf usr
else
  echo "Cannot add $0 because package liveclone is missing in PKGS." >&2
  exit 1
fi
