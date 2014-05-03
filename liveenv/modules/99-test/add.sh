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
test
----
- echo a string to say it has booted the kernel until userspace.

EOF

mkdir -p "$RDIR"/sbin
cat <<EOF > "$RDIR"/sbin/init
#!/mnt/salt/bin/busybox sh
/mnt/salt/bin/busybox mount -t tmpfs tmpfs /tmp
/mnt/salt/bin/busybox cat <<'EOT'

[1;36m  ***********************************[0m
[1;36m  ** End of Live Boot, all went Ok **[0m
[1;36m  ***********************************[0m

Type exit to reboot.
EOT
/mnt/salt/bin/busybox sh
exec /mnt/salt/bin/busybox reboot -f
EOF
chmod +x "$RDIR"/sbin/init
