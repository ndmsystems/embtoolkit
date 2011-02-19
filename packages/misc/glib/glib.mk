################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         glib.mk
# \brief	glib.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

GLIB_NAME := glib
GLIB_MAJOR_VERSION := $(call EMBTK_GET_PKG_VERSION,GLIB_MAJOR)
GLIB_VERSION :=  $(call EMBTK_GET_PKG_VERSION,GLIB)
GLIB_SITE := http://ftp.gnome.org/pub/gnome/sources/glib/$(GLIB_MAJOR_VERSION)
GLIB_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GLIB_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/glib/$(GLIB_VERSION)
GLIB_PACKAGE := glib-$(GLIB_VERSION).tar.bz2
GLIB_SRC_DIR := $(PACKAGES_BUILD)/glib-$(GLIB_VERSION)
GLIB_BUILD_DIR := $(PACKAGES_BUILD)/glib-$(GLIB_VERSION)

GLIB_BINS = 	glib-genmarshal glib-gettextize glib-mkenums gobject-query \
		gtester gtester-report
GLIB_SBINS =
GLIB_INCLUDES = gio-unix-* glib-*
GLIB_LIBS = gio* libgio-* libglib-* libgmodule-* libgobject-* libgthread-* glib-*
GLIB_PKGCONFIGS = gio-*.pc glib-*.pc gmodule-*.pc gobject-*.pc gthread-*.pc

GLIB_CONFIGURE_ENV :=	glib_cv_stack_grows=no			\
			glib_cv_uscore=no			\
			ac_cv_func_posix_getpwuid_r=yes		\
			ac_cv_func_nonposix_getpwuid_r=no	\
			ac_cv_func_posix_getgrgid_r=yes
GLIB_CONFIGURE_OPTS :=	--disable-fam

GLIB_DEPS := zlib_target_install gettext_install

glib_install:
	@test -e $(GLIB_BUILD_DIR)/.installed || \
	$(MAKE) $(GLIB_BUILD_DIR)/.installed

$(GLIB_BUILD_DIR)/.installed: $(GLIB_DEPS) \
	download_glib $(GLIB_BUILD_DIR)/.decompressed \
	$(GLIB_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	glib-$(GLIB_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(GLIB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(GLIB_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(GLIB_BUILD_DIR)/.patchlibtool
	@touch $@

download_glib:
	$(call EMBTK_DOWNLOAD_PKG,GLIB)

$(GLIB_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,GLIB)

$(GLIB_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,GLIB)

#FIXME: this should be fixed in glib2 project
$(GLIB_BUILD_DIR)/.patchlibtool:
	$(Q)sed \
	-e "s;\/usr\/$(LIBDIR)\/libgobject-2.0.la;$(SYSROOT)\/usr\/$(LIBDIR)\/libgobject-2.0.la;" \
	-e "s;\/usr\/$(LIBDIR)\/libgmodule-2.0.la;$(SYSROOT)\/usr\/$(LIBDIR)\/libgmodule-2.0.la;" \
	-e "s;\/usr\/$(LIBDIR)\/libglib-2.0.la;$(SYSROOT)\/usr\/$(LIBDIR)\/libglib-2.0.la;" \
	-e "s;\/usr\/$(LIBDIR)\/libgthread-2.0.la;$(SYSROOT)\/usr\/$(LIBDIR)\/libgthread-2.0.la;" \
	< $(SYSROOT)/usr/$(LIBDIR)/libgio-2.0.la > libgio-2.0.la.new; \
	mv libgio-2.0.la.new $(SYSROOT)/usr/$(LIBDIR)/libgio-2.0.la
	$(Q)sed \
	-e "s;\/usr\/$(LIBDIR)\/libglib-2.0.la;$(SYSROOT)\/usr\/$(LIBDIR)\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/$(LIBDIR)/libgmodule-2.0.la > libgmodule-2.0.la.new; \
	mv libgmodule-2.0.la.new $(SYSROOT)/usr/$(LIBDIR)/libgmodule-2.0.la
	$(Q)sed \
	-e "s;\/usr\/$(LIBDIR)\/libglib-2.0.la;$(SYSROOT)\/usr\/$(LIBDIR)\/libglib-2.0.la;" \
	-e "s;\/usr\/$(LIBDIR)\/libgthread-2.0.la;$(SYSROOT)\/usr\/$(LIBDIR)\/libgthread-2.0.la;" \
	< $(SYSROOT)/usr/$(LIBDIR)/libgobject-2.0.la > libgobject-2.0.la.new; \
	mv libgobject-2.0.la.new $(SYSROOT)/usr/$(LIBDIR)/libgobject-2.0.la
	$(Q)sed \
	-e "s;\/usr\/$(LIBDIR)\/libglib-2.0.la;$(SYSROOT)\/usr\/$(LIBDIR)\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/$(LIBDIR)/libgthread-2.0.la > libgthread-2.0.la.new; \
	mv libgthread-2.0.la.new $(SYSROOT)/usr/$(LIBDIR)/libgthread-2.0.la

glib_clean:
	$(call EMBTK_CLEANUP_PKG,GLIB)

