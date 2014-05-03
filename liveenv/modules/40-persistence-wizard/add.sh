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
persistence-wizard
------------------
- add a Persistence Wizard icon in the user 'one' desktop.


EOF

PERSISTENCEWIZARD="$(readlink -f "$(ls -1 "$PKGSDIR"/persistence-wizard-*.txz "$LOCALDIR"/persistence-wizard-*.txz 2>/dev/null | head -n 1)")"
if [ -n "$PERSISTENCEWIZARD" ]; then
  tar xf "$PERSISTENCEWIZARD" usr/share/applications
  mkdir -p "$RDIR"/home/one/Desktop
  cp usr/share/applications/*.desktop "$RDIR"/home/one/Desktop/
  rm -rf usr
else
  echo "Cannot add $0 because package persistence-wizard is missing in PKGS." >&2
  exit 1
fi
