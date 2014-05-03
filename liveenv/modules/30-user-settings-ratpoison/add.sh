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
user-settings-ratpoison
-----------------------
- user 'one' with common user-settings for Ratpoison


EOF

USERSETTINGS_RATPOISON="$(readlink -f "$(ls -1 "$PKGSDIR"/user-settings-ratpoison-[0-9]*.txz 2>/dev/null)")"
if [ -n "$USERSETTINGS_RATPOISON" ]; then
  tar -C "$RDIR" -xf "$USERSETTINGS_RATPOISON" etc/skel
else
  echo "Cannot add $0 because package user-settings-ratpoison is missing in PKGS." >&2
  exit 1
fi
cp -r "$RDIR"/etc/skel/* "$RDIR"/etc/skel/.??* "$RDIR"/home/one/ 2>/dev/null
