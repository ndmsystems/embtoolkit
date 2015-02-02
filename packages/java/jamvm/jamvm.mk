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
# \file         jamvm.mk
# \brief	jamvm.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         October 2014
################################################################################

JAMVM_NAME	:= jamvm
JAMVM_VERSION	:= $(call embtk_pkg_version,jamvm)
JAMVM_SITE	:= $(embtk_ftp/packages-mirror)
JAMVM_PACKAGE	:= jamvm-$(JAMVM_VERSION).tar.gz
JAMVM_SRC_DIR	:= $(embtk_pkgb)/jamvm-$(JAMVM_VERSION)
JAMVM_BUILD_DIR	:= $(embtk_pkgb)/jamvm-$(JAMVM_VERSION)-build

JAMVM_BINS   := jamvm
JAMVM_LIBS   := libjamvm.*
JAMVM_SHARES := jamvm

JAMVM_CONFIGURE_OPTS := --disable-int-inlining
JAMVM_CONFIGURE_OPTS += --disable-ffi
JAMVM_CONFIGURE_OPTS += --disable-zip
JAMVM_CONFIGURE_OPTS += --with-classpath-install-dir=/usr

JAMVM_DEPS := classpath_install

pembtk_jamvm_makefilein := $(call embtk_pkg_srcdir,jamvm)/src/Makefile.in
define embtk_beforeinstall_jamvm
	sed -e "s;\(^include_HEADERS = .*\)jni.h\(.*\);\1\2;" \
		< $(pembtk_jamvm_makefilein) > $(pembtk_jamvm_makefilein).tmp
	cp $(pembtk_jamvm_makefilein).tmp $(pembtk_jamvm_makefilein)
endef

define embtk_postinstall_jamvm
	rm -rf $(embtk_rootfs)/usr/share/jamvm
	[ -e $(embtk_rootfs)/usr/share ] || install -d $(embtk_rootfs)/usr/share
	cp -R $(embtk_sysroot)/usr/share/jamvm $(embtk_rootfs)/usr/share/jamvm
endef
