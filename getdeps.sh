#!/bin/sh
# vim: set syn=sh ft=sh et sw=2 sts=2 ts=2 tw=0:
# Maintainer: JRD <jrd@salixos.org>
# Contributors: Shador <shador@salixos.org>, Akuna <akuna@salixos.org>
#
# Extract dependancies list for a package.

cd $(dirname "$0")
PKG="$1"
CONF_FILE="$2"
if [ -z "$PKG" ]; then
  echo "$0 Package_Name [slapt-getrc Conf File]" >&2
  echo "  Extract dependancies list for the package." >&2
  exit 1
fi
LANG=
if [ -n "$CONF_FILE" ]; then
  /usr/sbin/slapt-get -c "$CONF_FILE" --show "$PKG"|sed -rn '/Required:/s/^[^:]+:(.*)/\1/p'
else
  /usr/sbin/slapt-get --show "$PKG"|sed -rn '/Required:/s/^[^:]+:(.*)/\1/p'
fi
