#!/bin/sh

PKGDESC=`echo "select package_description from packages where package_name='$PKGNAME' order by package_id desc limit 1;" | sqlite3 /var/mpkg/packages.db`
PKGSHORTDESC=`echo "select package_short_description from packages where package_name='$PKGNAME' order by package_id desc limit 1;" | sqlite3 /var/mpkg/packages.db`
PKGDEP=`echo "select dependency_package_name from dependencies where packages_package_id in (select package_id from packages where package_name='$PKGNAME' order by package_id desc limit 1);" | sqlite3 /var/mpkg/packages.db`
PKGTAGS=`echo "SELECT DISTINCT tags.tags_name FROM tags,tags_links WHERE tags_links.packages_package_id IN (SELECT package_id FROM packages WHERE package_name='$PKGNAME' ORDER BY package_id DESC) AND tags_links.tags_tag_id=tags.tags_id;" | sqlite3 /var/mpkg/packages.db`

BUILDSYSTEM="autotools"

ABUILD_BASE="pkgname=$PKGNAME\n\
pkgver=$PKGVER\n\
pkgbuild=$PKGBUILD\n\
arch=('$PKGARCH')\n\
\n\
shortdesc=('$PKGSHORTDESC')\n\
longdesc=('$PKGDESC')\n\
\n\
tags=('$PKGTAGS')\n\
\n\
source=('$SRCBASE/$PKGNAME-$PKGVER.tar.bz2')\n\
\n\
build_deps='$PKGDEP'\n\
\n\
before_build() {\n\
	echo \"\"\n\
}\n\
\n\
BUILD_SYSTEM='$BUILDSYSTEM'\n\
BUILD_KEYS=\"$KEYS\"\n\
INSTALL_KEYS=\"DESTDIR=\$pkgdir\"\n\
after_build() {\n\
	echo \"\"\n\
}\n\
"

echo -e $ABUILD_BASE > ABUILD


