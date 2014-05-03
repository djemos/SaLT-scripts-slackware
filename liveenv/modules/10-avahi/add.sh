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
avahi
-----
- avahi configured, but daemon not running by default


EOF

cat <<EOF >> "$doinst"
chmod -x etc/rc.d/rc.avahi*

EOF

echo 'avahi:x:214:' >> "$RDIR"/etc/group
echo 'avahi:x:214:214:Avahi User:/dev/null:/bin/false' >> "$RDIR"/etc/passwd
echo 'avahi:!:15194:0:99999:7:::' >> "$RDIR"/etc/shadow
