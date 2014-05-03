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
user-one
-------------
- user 'one' already created with password 'one'
- user 'one' added to the following groups:
  * floppy
  * audio
  * video
  * cdrom
  * plugdev
  * power
  * netdev
  * scanner
  * users
  * fuse
  * wheel (so is sudoer)


EOF

echo 'one:x:1000:100::/home/one:/bin/bash' >> "$RDIR"/etc/passwd
echo 'one:$5$wC3Ap/4t7$o/lDUbBMF5RT7DFaHYW2g0NO.ArrvHd7G2m1mdHhXR7:13686:0:99999:7:::' >> "$RDIR"/etc/shadow
sed -i 's/^floppy:.*/\0one/; s/^audio:.*/\0one/; s/^video:.*/\0one/; s/^cdrom:.*/\0one/; s/^plugdev:.*/\0one/; s/^power:.*/\0one/; s/^netdev:.*/\0one/; s/^scanner:.*/\0one/; s/^users:.*/\0one/; s/^fuse:.*/\0one/; s/^wheel:.*/\0,one/;' "$RDIR"/etc/group
mkdir -p "$RDIR"/home/one
cp -r "$RDIR"/etc/skel/* "$RDIR"/etc/skel/.??* "$RDIR"/home/one/ 2>/dev/null

echo 'chown -R 1000:100 home/one' >> "$doinst"
