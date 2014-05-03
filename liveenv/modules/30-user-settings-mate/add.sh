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
user-settings-mate
------------------
- user 'one' with common user-settings for Maté


EOF

USERSETTINGS_MATE="$(readlink -f "$(ls -1 "$PKGSDIR"/user-settings-mate-[0-9]*.txz 2>/dev/null)")"
if [ -n "$USERSETTINGS_MATE" ]; then
  tar -C "$RDIR" -xf "$USERSETTINGS_MATE" etc/skel
else
  echo "Cannot add $0 because package user-settings-mate is missing in PKGS." >&2
  exit 1
fi
cp -r "$RDIR"/etc/skel/* "$RDIR"/etc/skel/.??* "$RDIR"/home/one/ 2>/dev/null
# needed to prevent weird behavior on first launch of some apps.
mkdir -p "$RDIR"/home/one/.mate2
