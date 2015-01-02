################################################################################
# Embtoolkit
# Copyright(C) 2009-2015 Abdoulaye Walsimou GAYE.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################
#
# \file         classpath.mk
# \brief	classpath.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2014
################################################################################

CLASSPATH_NAME		:= classpath
CLASSPATH_VERSION	:= $(call embtk_pkg_version,classpath)
CLASSPATH_SITE		:= ftp://ftp.gnu.org/gnu/classpath
CLASSPATH_PACKAGE	:= classpath-$(CLASSPATH_VERSION).tar.gz
CLASSPATH_SRC_DIR	:= $(embtk_pkgb)/classpath-$(CLASSPATH_VERSION)
CLASSPATH_BUILD_DIR	:= $(embtk_pkgb)/classpath-$(CLASSPATH_VERSION)-build

CLASSPATH_INCLUDES := jawt.h jawt_md.h jni.h jni_md.h
CLASSPATH_LIBS     := classpath logging.properties security

CLASSPATH_SHARES := classpath
CLASSPATH_SHARES += info/cp-hacking.info
CLASSPATH_SHARES += info/cp-tools.info
CLASSPATH_SHARES += info/cp-vmintegration.info
CLASSPATH_SHARES += info/dir
CLASSPATH_SHARES += man/man1/gappletviewer.1
CLASSPATH_SHARES += man/man1/gcjh.1
CLASSPATH_SHARES += man/man1/gjar.1
CLASSPATH_SHARES += man/man1/gjarsigner.1
CLASSPATH_SHARES += man/man1/gjavah.1
CLASSPATH_SHARES += man/man1/gjdoc.1
CLASSPATH_SHARES += man/man1/gkeytool.1
CLASSPATH_SHARES += man/man1/gnative2ascii.1
CLASSPATH_SHARES += man/man1/gorbd.1
CLASSPATH_SHARES += man/man1/grmid.1
CLASSPATH_SHARES += man/man1/grmiregistry.1
CLASSPATH_SHARES += man/man1/gserialver.1
CLASSPATH_SHARES += man/man1/gtnameserv.1

CLASSPATH_CONFIGURE_ENV := JAVA="$(HOSTJAVA)"
CLASSPATH_CONFIGURE_ENV += JAVAC="$(HOSTJAVAC)"

CLASSPATH_CONFIGURE_OPTS := --program-transform-name='s;$(STRICT_GNU_TARGET)-;;'
CLASSPATH_CONFIGURE_OPTS += --enable-jni
CLASSPATH_CONFIGURE_OPTS += --disable-alsa
CLASSPATH_CONFIGURE_OPTS += --disable-dssi
CLASSPATH_CONFIGURE_OPTS += --disable-examples
CLASSPATH_CONFIGURE_OPTS += --disable-gconf-peer
CLASSPATH_CONFIGURE_OPTS += --disable-gmp
CLASSPATH_CONFIGURE_OPTS += --disable-gstreamer-peer
CLASSPATH_CONFIGURE_OPTS += --disable-gtk-peer
CLASSPATH_CONFIGURE_OPTS += --disable-plugin
CLASSPATH_CONFIGURE_OPTS += --disable-qt-peer
CLASSPATH_CONFIGURE_OPTS += --disable-tools
CLASSPATH_CONFIGURE_OPTS += --disable-Werror
CLASSPATH_CONFIGURE_OPTS += --without-x
CLASSPATH_CONFIGURE_OPTS += --disable-xmlj
CLASSPATH_CONFIGURE_OPTS += --with-jar="$(HOSTJAR)"

CLASSPATH_DEPS := zlib_install

define embtk_postinstall_classpath
	rm -rf $(embtk_rootfs)/usr/$(LIBDIR)/classpath
	rm -rf $(embtk_rootfs)/usr/$(LIBDIR)/logging.properties
	rm -rf $(embtk_rootfs)/usr/$(LIBDIR)/security
	rm -rf $(embtk_rootfs)/usr/share/classpath
	[ -e $(embtk_rootfs)/usr/$(LIBDIR) ] ||					\
		install -d $(embtk_rootfs)/usr/$(LIBDIR)
	[ -e $(embtk_rootfs)/usr/share ] ||					\
		install -d $(embtk_rootfs)/usr/share
	for f in $(LIBDIR)/classpath						\
		$(LIBDIR)/logging.properties					\
		$(LIBDIR)/security share/classpath;				\
	do									\
		cp -R $(embtk_sysroot)/usr/$$f $(embtk_rootfs)/usr/$$f;		\
	done
	rm -rf $(embtk_rootfs)/usr/$(LIBDIR)/classpath/*.la
endef
