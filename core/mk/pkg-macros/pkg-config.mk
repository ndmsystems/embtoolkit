################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         pkg-config.mk
# \brief	pkg-config.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################

#
# embtk_pkgconfig-libs:
# A macro to get pkg-config libs entry for a target package
# Usage: $(call embtk_pkgconfig_getlibs,pkgname)
#
define embtk_pkgconfig-libs
	$(shell									\
		PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH)			\
		PKG_CONFIG_LIBDIR="$(EMBTK_PKG_CONFIG_LIBDIR)"			\
		$(PKGCONFIG_BIN) $(strip $(1)) --libs)
endef

#
# embtk_pkgconfig-cflags:
# A macro to get pkg-config cflags entry for a target package
# Usage: $(call embtk_pkgconfig_getcflags,pkgname)
#
define embtk_pkgconfig-cflags
	$(shell									\
		PKG_CONFIG_PATH=$(EMBTK_PKG_CONFIG_PATH)			\
		PKG_CONFIG_LIBDIR="$(EMBTK_PKG_CONFIG_LIBDIR)"			\
		$(PKGCONFIG_BIN) $(strip $(1)) --cflags)
endef

#
# FIXME: Get rid of this macro, each package should indicate its .pc files
# Macro to adapt pkg-config files for cross compiling
#
__pkgconfig_includedir	= includedir=$(embtk_sysroot)/usr/include
__pkgconfig_prefix	= prefix=$(embtk_sysroot)/usr
__pkgconfig_libdir	= libdir=$(embtk_sysroot)/usr/$(LIBDIR)
__embtk_pkgconfig_dir0	= $(embtk_sysroot)/usr/$(LIBDIR)/pkgconfig
__embtk_pkgconfig_dir1	= $(embtk_sysroot)/usr/share/pkgconfig
define __embtk_fix_pkgconfig_files
	if [ -d $(__embtk_pkgconfig_dir0) ]; then				\
		__conf_files0=$$(find $(__embtk_pkgconfig_dir0) -name *.pc);	\
	fi;									\
	if [ -d $(__embtk_pkgconfig_dir1) ]; then				\
		__conf_files1=$$(find $(__embtk_pkgconfig_dir1) -name *.pc);	\
	fi;									\
	for i in $$__conf_files0 $$__conf_files1; do				\
		sed -e 's;prefix=.*;$(__pkgconfig_prefix);'			\
		-e 's;includedir=$${prefix}/include;$(__pkgconfig_includedir);'	\
		-e 's;includedir=/usr/include;$(__pkgconfig_includedir);'	\
		-e 's;libdir=.*;$(__pkgconfig_libdir);' < $$i > $$i.new;	\
		mv $$i.new $$i;							\
	done
endef
