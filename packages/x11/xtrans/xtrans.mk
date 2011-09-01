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
# \file         xtrans.mk
# \brief	xtrans.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

XTRANS_NAME		:= xtrans
XTRANS_VERSION		:= $(call embtk_get_pkgversion,xtrans)
XTRANS_SITE		:= http://xorg.freedesktop.org/archive/individual/lib
XTRANS_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
XTRANS_PACKAGE		:= xtrans-$(XTRANS_VERSION).tar.bz2
XTRANS_SRC_DIR		:= $(PACKAGES_BUILD)/xtrans-$(XTRANS_VERSION)
XTRANS_BUILD_DIR	:= $(PACKAGES_BUILD)/xtrans-$(XTRANS_VERSION)

XTRANS_BINS		=
XTRANS_SBINS		=
XTRANS_INCLUDES		= X11/xtrans
XTRANS_LIBS		=
XTRANS_PKGCONFIGS	=

XTRANS_CONFIGURE_OPTS := --disable-malloc0returnsnull

define embtk_postinstall_xtrans
	$(Q)if [ ! -e $(XTRANS_BUILD_DIR)/.postinstalled ]; then		\
		cp $(SYSROOT)/usr/share/pkgconfig/xtrans.pc			\
						$(EMBTK_PKG_CONFIG_PATH);	\
		$(MAKE) pkgconfig_files_adapt;					\
		touch $(XTRANS_BUILD_DIR)/.postinstalled;			\
	fi
endef
