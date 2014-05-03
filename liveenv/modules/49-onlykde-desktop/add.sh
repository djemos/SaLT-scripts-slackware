#!/bin/sh
startdir="$1"
[ -n "$startdir" ] && [ -d "$startdir" ] || exit 1
cd "$(dirname "$0")"
HDIR="$startdir/liveenv"
PKGSDIR="$startdir/PKGS"
RDIR="$HDIR"/root
doinst="$HDIR"/doinst
modtxt="$HDIR"/MODIFICATIONS

cat <<EOF >> "$modtxt"
onlykde-desktop
---------------
- rename all *-kde.desktop files in the user 'one' desktop by removing the '-kde' part and overwritting duplicate desktop files.


EOF

(
  cd "$RDIR"/root/home/one/Desktop
  for f in *-kde.desktop; do
    mv $f $(echo "$f"|sed 's/-kde//')
  done
  chmod u+x  "$RDIR"/root/home/one/Desktop/*.desktop
)
