#!/bin/sh
# vim: set syn=sh ft=sh et sw=2 sts=2 ts=2 tw=0:
# Maintainer: JRD <jrd@salixos.org>
# Contributors: Shador <shador@salixos.org>, Akuna <akuna@salixos.org>, <djemos@slackel.gr>
# Licence: GPL v3+
#
# Used to build the live ISO
# build-slackware-live.sh (from slackware-live) is used to create the initrd.gz need to boot the Live CD.
# build-slackware-live.sh is used also to build this Live CD. 
# funionfs (unionfs with fuse) is still used for building the modules because it is simpler and easier than aufs which may not be compiled in your kernel and which is not available in FUSE. The 0.4.2 version is used in time of writing, instead of 0.4.3 because this one is buggy. Later versions must be checked to see if it's ok with "cp" and "mkfifo" for example.
#
# See README

cd $(dirname "$0")
. scripts/00_common
echo3 "Building $DISTRO live v.$VER"
. scripts/01_getfunionfs
. scripts/02_liveenv
. scripts/03_readmodules
. scripts/04_checkmodules
[ -e src ] && rm -rf src
. scripts/05_preparesources
. scripts/06_createmodule
. scripts/07_prepareiso
. scripts/08_compressmodule
rm -f $modules
. scripts/09_createiso

