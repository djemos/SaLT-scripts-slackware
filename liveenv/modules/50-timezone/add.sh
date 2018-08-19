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
timezone
-------------
- Set timezone to Etc/GMT

EOF

	mkdir -p "$RDIR"/usr/share/zoneinfo/Etc
	mkdir -p "$RDIR"/etc
	cp /usr/share/zoneinfo/Etc/GMT "$RDIR"/usr/share/zoneinfo/Etc/
	cp -a "$RDIR"/usr/share/zoneinfo/Etc/GMT "$RDIR"/etc/localtime
	cp "$RDIR"/etc
	ln -sf "$RDIR"/usr/share/zoneinfo/Etc/GMT "$RDIR"/etc/localtime-copied-from
