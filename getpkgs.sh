#!/bin/sh
# vim: set syn=sh ft=sh et sw=2 sts=2 ts=2 tw=0:
# Maintainer: JRD <jrd@salixos.org>
# Contributors: Shador <shador@salixos.org>, Akuna <akuna@salixos.org>
# Licence: GPL v3+
#
# Download packages from the repo and from "local" directory, according to "packages-*" files.

cd "$(dirname "$0")"
help() {
  echo "syntax: $(basename "$0") 32|64 version [upgrade]"
  echo '  Will download the packages from the repo according to "packages-*" files.'
  echo '  If a package is already present in "local" directory, it will be used instead.'
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
upgrade=
[ "$3" = "upgrade" ] && upgrade=1
trap "{ rm -rf slapt-get* var availables; exit 255; }" SIGHUP SIGINT SIGTERM
mkdir -p slapt-get
[ "$arch" = "32" ] && exclude=-x86_64-
[ "$arch" = "64" ] && exclude=-i?86-
[ "$arch" = "32" ] && srcdir=i486
[ "$arch" = "64" ] && srcdir=x86_64
cat <<EOF > slapt-getrc
WORKINGDIR=$PWD/slapt-get
EXCLUDE=.*-[0-9]+dl$,$exclude
#SOURCE=http://salix.enialis.net/$srcdir/slackware-$ver/:OFFICIAL
#SOURCE=http://salix.enialis.net/$srcdir/slackware-$ver/extra/:OFFICIAL
SOURCE=http://salix.enialis.net/$srcdir/$ver/:PREFERRED

SOURCE=http://www.slackel.gr/repo/$srcdir/slackware-current/:OFFICIAL
SOURCE=http://www.slackel.gr/repo/$srcdir/slackware-current/extra/:OFFICIAL
SOURCE=http://www.slackel.gr/repo/$srcdir/current/:CUSTOM
EOF
ROOT=$PWD
export ROOT
mkdir -p var/log/packages
/usr/sbin/slapt-get -c $PWD/slapt-getrc -u
nb=$(cat packages-* | wc -l)
i=0
d0=$(date +%s)
cat /dev/null > pkgs_in_errors
mkdir -p PKGS
if [ -n "$upgrade" ]; then
  cat /dev/null > pkgs_upgraded
  cat /dev/null > pkgs_skipped
  /usr/sbin/slapt-get -c $PWD/slapt-getrc --available|cut -d' ' -f1|sed 's/.*/:\0:/' > availables
else
  rm -rf PKGS/* 2>/dev/null
fi
cat packages-* | sort | while read p; do
  i=$(( $i + 1 ))
  clear
  echo '⋅⋅⋅---=== getpkgs.sh ===---⋅⋅⋅'
  echo ''
  echo -n 'Progression : ['
  perct=$(($i * 100 / $nb))
  nbSharp=$(($i * 50 / $nb))
  nbSpace=$((50 - $nbSharp))
  for j in $(seq $nbSharp); do echo -n '#'; done
  for j in $(seq $nbSpace); do echo -n '_'; done
  echo "] $i / $nb ($perct%)"
  offset=$(($(date +%s) - $d0))
  timeremain=$((($nb - $i) * $offset / $i))
  echo 'Remaining time (estimated) :' $(date -d "1970-01-01 UTC +$timeremain seconds" +%M:%S)
  echo ''
  echo "$p..."
  pkg=$(find local/ -regex "local/$(echo $p | sed -e 's:\+:\\+:g')-[^-]*-[^-]*-[^-]*\.t[gxlb]z")
  if [ -e "$pkg" ]; then
    find PKGS/ -regex "PKGS/$(echo $p | sed -e 's:\+:\\+:g')-[^-]*-[^-]*-[^-]*\.t[gxlb]z" -exec rm -f '{}' \;
    cp -v "$pkg" PKGS/
  elif [ "$p" = "liveenv" ]; then
    echo "$p will be created later"
    rm -f PKGS/liveenv-*-*-*.t?z
  else
    skip=false
    if [ -n "$upgrade" ]; then
      pkg=$(basename $(find PKGS/ -regex "PKGS/$(echo $p | sed -e 's:\+:\\+:g')-[^-]*-[^-]*-[^-]*\.t[gxlb]z" || echo '') | sed 's:\(.*\)\.t[gxlb]z:\1:')
      if grep -q ":$pkg:" availables; then
        skip=true
      fi
    fi
    if [ $skip = "false" ]; then
      find PKGS/ -regex "PKGS/$(echo $p | sed -e 's:\+:\\+:g')-[^-]*-[^-]*-[^-]*\.t[gxlb]z" -exec rm -f '{}' \;
      /usr/sbin/slapt-get -c $PWD/slapt-getrc -i -d -y --no-dep $p || echo $p >> pkgs_in_errors
      echo $p >> pkgs_upgraded
    else
      echo $p >> pkgs_skipped
    fi
  fi
done
find slapt-get -name '*PACKAGES.TXT.gz' -exec mv '{}' PKGS/ \;
find slapt-get -name '*.t[gx]z' -exec mv '{}' PKGS/ \;
rm -rf slapt-get* var availables
