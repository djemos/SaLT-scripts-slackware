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
user-settings
-------------
- user 'one' with common user-settings


EOF

USERSETTINGS="$(readlink -f "$(ls -1 "$PKGSDIR"/user-settings-slackel-[0-9]*.txz 2>/dev/null)")"
if [ -n "$USERSETTINGS" ]; then
  tar -C "$RDIR" -xf "$USERSETTINGS" etc/skel
else
  echo "Cannot add $0 because package user-settings is missing in PKGS." >&2
  exit 1
fi
cp -r "$RDIR"/etc/skel/* "$RDIR"/etc/skel/.??* "$RDIR"/home/one/ 2>/dev/null
