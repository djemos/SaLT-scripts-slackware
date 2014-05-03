#!/bin/sh
startdir="$1"
[ -n "$startdir" ] && [ -d "$startdir" ] || exit 1
cd "$(dirname "$0")"
HDIR="$startdir/liveenv"
PKGSDIR="$startdir/PKGS"
RDIR="$HDIR"/root
doinst="$HDIR"/doinst
modtxt="$HDIR"/MODIFICATIONS

ETC="$(readlink -f "$(ls -1 "$PKGSDIR"/etc-[0-9]*.txz 2>/dev/null)")"
if [ -n "$ETC" ]; then
  tar -C "$RDIR" -xf "$ETC" etc/skel etc/group.new etc/passwd.new etc/shadow.new
  mv "$RDIR"/etc/group.new "$RDIR"/etc/group
  mv "$RDIR"/etc/passwd.new "$RDIR"/etc/passwd
  mv "$RDIR"/etc/shadow.new "$RDIR"/etc/shadow
else
  echo "Cannot add $0 because package etc is missing in PKGS." >&2
  exit 1
fi
