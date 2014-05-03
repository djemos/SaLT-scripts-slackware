#!/bin/sh
# vim: set syn=sh ft=sh et sw=2 sts=2 ts=2 tw=0:
# Maintainer: JRD <jrd@salixos.org>
# Contributors: Shador <shador@salixos.org>, Akuna <akuna@salixos.org>
# Licence: GPL v3+
#
cd $(dirname "$0")
if [ "$(basename $(pwd))" = liveenv ]; then
  cd ..
  . $PWD/config
  startdir="$PWD"
  cd liveenv
  VER=$(echo $VER|cut -d- -f2)
else
  exit 1
fi

usage() {
  echo "$0 MODULE1 MODULE2 ..."
  echo "  Will create a liveenv package and will place it in PKGS/"
  exit 1
}
check_root() {
  if [ $(id -ru) -ne 0 ]; then
    echo "You need to be root" >&2
    exit 1
  fi
}
get_all_modules() {
  modules="$1"
  all=''
  for m in $modules; do
    deps="$(cat modules/[0-9][0-9]-$m/deps 2>/dev/null)"
    if [ -n "$deps" ]; then
      all="$all $(get_all_modules "$deps")"
    fi
    all="$all $m"
  done
  echo "$all"|sed 's/ /\n/g'|sort -u
}
get_full_path() {
  modules="$1"
  for m in $modules; do
    echo modules/[0-9][0-9]-$m
  done
}
check_root
MODULES=''
while [ -n "$1" ] && [ "$1" != "--" ]; do
  M="$1"
  shift
  if [ -d modules/[0-9][0-9]-"$M" ]; then
    MODULES="$MODULES $M"
  else
    echo "The module $M does not exist" >&2
  fi
done
[ -z "$MODULES" ] && usage
# add dependancies
MODULES="$(get_all_modules "$MODULES")"
# get full path and sort
MODULES="$(ls -1d $(get_full_path "$MODULES")|sort -u)"
rm -rf root doinst MODIFICATIONS
mkdir root
touch doinst MODIFICATIONS
for m in $MODULES; do
  echo "* Adding $m"
  # fill root directory and append to doinst and MODIFICATIONS files
  $m/add.sh "$startdir"
done
sed "s/^pkgver=/\0$VER/; /^doinst/r doinst" SLKBUILD.tmpl > SLKBUILD
slkbuild -X
rm -rf SLKBUILD doinst MODIFICATIONS root *.md5 *.log
mv liveenv-*-*-*.txz "$startdir"/PKGS/
