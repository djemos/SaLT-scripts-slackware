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
firefox-profile
---------------
- Add a default profile for Firefox for user 'one'.


EOF

FIREFOXVER=$(ls -1 "$PKGSDIR"/mozilla-firefox-*-*-*.txz 2>/dev/null | head -n 1 | sed 's/.*-.*-\([^-]*\)-[^-]*-[^-]*\.txz/\1/')
if [ -n "$FIREFOXVER" ]; then
  LIBDIRSUFFIX=
  [ $(uname -m) = x86_64 ] && LIBDIRSUFFIX=64
  FIREFOXMILESTONE=$(tar -xOf "$PKGSDIR"/mozilla-firefox-$FIREFOXVER-*.txz usr/lib$LIBDIRSUFFIX/firefox-$FIREFOXVER/platform.ini|grep Milestone| sed 's/^Milestone=\(.*\)/\1/')
  PROFILE_NAME=jb8obseq
  mkdir -p "$RDIR"/home/one/.mozilla/firefox/$PROFILE_NAME.default/
  cat <<EOF > "$RDIR"/home/one/.mozilla/firefox/profiles.ini
[General]
StartWithLastProfile=1

[Profile0]
Name=default
IsRelative=1
Path=$PROFILE_NAME.default

EOF
  cat <<EOF > "$RDIR"/home/one/.mozilla/firefox/$PROFILE_NAME.default/prefs.js
# Mozilla User Preferences

user_pref("browser.rights.3.shown", true);
user_pref("browser.startup.homepage_override.mstone", "rv:$FIREFOXMILESTONE");
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.enabled", true);
user_pref("extensions.autoDisableScopes", 2);

EOF
else
  echo "Cannot add $0 because package mozilla-firefox is missing in PKGS." >&2
  exit 1
fi
