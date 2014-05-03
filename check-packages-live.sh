#!/bin/sh
# vim: set syn=sh ft=sh et sw=2 sts=2 ts=2 tw=0:
# Maintainer: JRD <jrd@salixos.org>
# Contributors: Shador <shador@salixos.org>, Akuna <akuna@salixos.org>
# Licence: GPL v3+
#
# Check if all dependancies are met within the packages-live module.

cd $(dirname "$0")
help() {
  echo "syntax: $(basename $0) 32|64 version"
  echo "  Will check if all dependancies are met within the packages-live module."
}
if [ "$1" != "32" ] && [ "$1" != "64" ]; then
  help
  exit 1
fi
if [ -z "$2" ]; then
  help
  exit 1
fi
arch=$1
ver=$2
mkdir -p slapt-get
[ "$arch" = "32" ] && exclude=-x86_64-
[ "$arch" = "64" ] && exclude=-i?86-
[ "$arch" = "32" ] && srcdir=i486
[ "$arch" = "64" ] && srcdir=x86_64
cat <<EOF > slapt-getrc
WORKINGDIR=$PWD/slapt-get
EXCLUDE=.*-[0-9]+dl$,$exclude
SOURCE=http://salix.enialis.net/$srcdir/slackware-$ver/:OFFICIAL
SOURCE=http://salix.enialis.net/$srcdir/slackware-$ver/extra/:OFFICIAL
SOURCE=http://salix.enialis.net/$srcdir/$ver/:PREFERRED
EOF
/usr/sbin/slapt-get -c $PWD/slapt-getrc -u
touch dep.fifo
for p in $(cat packages-live); do
  echo $p
  ./getdeps.sh $p $PWD/slapt-getrc > dep.fifo
  ./depcheck -f dep.fifo|sed 's/^/  /'
done
rm -rf dep.fifo slapt-get*
