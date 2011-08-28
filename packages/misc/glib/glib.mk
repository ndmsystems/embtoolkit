################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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

GLIB_NAME		:= glib
GLIB_MAJOR_VERSION	:= $(call embtk_get_pkgversion,glib_major)
GLIB_VERSION		:= $(call embtk_get_pkgversion,glib)
GLIB_SITE		:= http://ftp.gnome.org/pub/gnome/sources/glib/$(GLIB_MAJOR_VERSION)
GLIB_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GLIB_PATCH_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/glib/$(GLIB_VERSION)
GLIB_PACKAGE		:= glib-$(GLIB_VERSION).tar.bz2
GLIB_SRC_DIR		:= $(PACKAGES_BUILD)/glib-$(GLIB_VERSION)
GLIB_BUILD_DIR		:= $(PACKAGES_BUILD)/glib-$(GLIB_VERSION)

GLIB_BINS		= glib-genmarshal glib-gettextize glib-mkenums	\
			gobject-query gtester gtester-report
GLIB_SBINS		=
GLIB_INCLUDES		= gio-unix-* glib-*
GLIB_LIBS		= gio* libgio-* libglib-* libgmodule-*		\
			libgobject-* libgthread-* glib-*
GLIB_PKGCONFIGS		= gio-*.pc glib-*.pc gmodule-*.pc gobject-*.pc	\
			gthread-*.pc

GLIB_CONFIGURE_ENV	:= glib_cv_stack_grows=no			\
			glib_cv_uscore=no				\
			ac_cv_func_posix_getpwuid_r=yes			\
			ac_cv_func_nonposix_getpwuid_r=no		\
			ac_cv_func_posix_getgrgid_r=yes
GLIB_CONFIGURE_OPTS	:= --disable-fam

GLIB_DEPS		:= zlib_install gettext_install glib_host_install

define embtk_postinstall_glib
	$(Q)test -e $(GLIB_BUILD_DIR)/.patchlibtool || \
	$(MAKE) $(GLIB_BUILD_DIR)/.patchlibtool
endef

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
	@touch $@

#
# glib for host
#
GLIB_HOST_NAME		:= $(GLIB_NAME)
GLIB_HOST_MAJOR_VERSION	:= $(GLIB_MAJOR_VERSION)
GLIB_HOST_VERSION	:= $(GLIB_VERSION)
GLIB_HOST_SITE		:= $(GLIB_SITE)
GLIB_HOST_SITE_MIRROR1	:= $(GLIB_SITE_MIRROR1)
GLIB_HOST_SITE_MIRROR2	:= $(GLIB_SITE_MIRROR2)
GLIB_HOST_SITE_MIRROR3	:= $(GLIB_SITE_MIRROR3)
GLIB_HOST_PATCH_SITE	:= $(GLIB_PATCH_SITE)
GLIB_HOST_PACKAGE	:= $(GLIB_PACKAGE)
GLIB_HOST_SRC_DIR	:= $(TOOLS_BUILD)/glib-$(GLIB_VERSION)
GLIB_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/glib-$(GLIB_VERSION)

GLIB_HOST_SET_RPATH		:= y
GLIB_HOST_CONFIGURE_OPTS	:= --disable-fam
GLIB_HOST_DEPS			:= gettext_host_install

