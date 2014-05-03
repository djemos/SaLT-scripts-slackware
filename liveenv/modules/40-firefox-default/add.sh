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
firefox-default
---------------
- Make firefox the default Internet browser for user 'one'.


EOF

FIREFOXVER=$(ls -1 "$PKGSDIR"/mozilla-firefox-*-*-*.txz 2>/dev/null | head -n 1 | sed 's/.*-.*-\([^-]*\)-[^-]*-[^-]*\.txz/\1/')
if [ -n "$FIREFOXVER" ]; then
  mkdir -p "$RDIR"/home/one/.gconf/desktop/gnome/url-handlers/chrome
  mkdir -p "$RDIR"/home/one/.gconf/desktop/gnome/url-handlers/ftp
  mkdir -p "$RDIR"/home/one/.gconf/desktop/gnome/url-handlers/http
  mkdir -p "$RDIR"/home/one/.gconf/desktop/gnome/url-handlers/https
  touch "$RDIR"/home/one/.gconf/%gconf.xml
  touch "$RDIR"/home/one/.gconf/desktop/%gconf.xml
  touch "$RDIR"/home/one/.gconf/desktop/gnome/%gconf.xml
  touch "$RDIR"/home/one/.gconf/desktop/gnome/url-handlers/%gconf.xml
  LIBDIRSUFFIX=
  [ $(uname -m) = x86_64 ] && LIBDIRSUFFIX=64
  for p in chrome ftp http https; do
    cat <<EOF > "$RDIR"/home/one/.gconf/desktop/gnome/url-handlers/$p/%gconf.xml
<?xml version="1.0"?>
<gconf>
  <entry name="needs_terminal" mtime="1255907694" type="bool" value="false"></entry>
  <entry name="enabled" mtime="1255907694" type="bool" value="true"></entry>
  <entry name="command" mtime="1255907694" type="string">
    <stringvalue>/usr/lib$LIBDIRSUFFIX/firefox-$FIREFOXVER/firefox &quot;%s&quot;</stringvalue>
  </entry>
</gconf>

EOF
  done
else
  echo "Cannot add $0 because package mozilla-firefox is missing in PKGS." >&2
  exit 1
fi
