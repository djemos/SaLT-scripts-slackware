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
alias
-----
- add some cool alias to ls and vi.


EOF

mkdir -p "$RDIR"/etc/profile.d
cat <<EOF > "$RDIR"/etc/profile.d/alias.sh
alias ls='ls -lhF --group-directories-first --color'
alias vi='vim'

EOF
chmod +x "$RDIR"/etc/profile.d/alias.sh
