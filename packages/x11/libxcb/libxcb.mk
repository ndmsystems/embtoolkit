################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         libxcb.mk
# \brief	libxcb.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

LIBXCB_NAME		:= libxcb
LIBXCB_VERSION		:= $(call embtk_get_pkgversion,libxcb)
LIBXCB_SITE		:= http://xcb.freedesktop.org/dist
LIBXCB_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBXCB_PACKAGE		:= libxcb-$(LIBXCB_VERSION).tar.gz
LIBXCB_SRC_DIR		:= $(embtk_pkgb)/libxcb-$(LIBXCB_VERSION)
LIBXCB_BUILD_DIR	:= $(embtk_pkgb)/libxcb-$(LIBXCB_VERSION)

LIBXCB_BINS		=
LIBXCB_SBINS		=
LIBXCB_INCLUDES 	= xcb
LIBXCB_LIBS		= libxcb*
LIBXCB_PKGCONFIGS	= xcb*.pc

LIBXCB_CONFIGURE_OPTS	:= --enable-xinput

LIBXCB_DEPS		:= xcbproto_install libpthreadstubs_install libxau_install

define embtk_postinstall_libxcb
	$(Q)test -e $(LIBXCB_BUILD_DIR)/.patchlibtool ||			\
	$(MAKE) $(LIBXCB_BUILD_DIR)/.patchlibtool
endef


$(LIBXCB_BUILD_DIR)/.patchlibtool:
	$(Q)LIBXCB_LT_FILES=`find $(embtk_sysroot)/usr/$(LIBDIR)/libxcb-* -type f -name *.la`; \
	for i in $$LIBXCB_LT_FILES; \
	do \
	sed \
	-i "s; /usr/$(LIBDIR)/libxcb.la ; $(embtk_sysroot)/usr/$(LIBDIR)/libxcb.la ;" $$i; \
	done

