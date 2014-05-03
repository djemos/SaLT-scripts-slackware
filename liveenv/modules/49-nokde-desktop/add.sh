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
nokde-desktop
-------------
- remove all *-kde.desktop files in the user 'one' desktop. Some DE will display them even in OnlyShownIn=KDE is specified.


EOF

rm -f "$RDIR"/home/one/Desktop/*-kde.desktop 2>/dev/null
chmod u+x "$RDIR"/home/one/Desktop/*.desktop

