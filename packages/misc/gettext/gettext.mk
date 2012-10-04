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
# \file         gettext.mk
# \brief	gettext.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

GETTEXT_NAME		:= gettext
GETTEXT_VERSION		:= $(call embtk_get_pkgversion,gettext)
GETTEXT_SITE		:= http://ftp.gnu.org/pub/gnu/gettext
GETTEXT_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GETTEXT_PACKAGE		:= gettext-$(GETTEXT_VERSION).tar.gz
GETTEXT_SRC_DIR		:= $(PACKAGES_BUILD)/gettext-$(GETTEXT_VERSION)
GETTEXT_BUILD_DIR	:= $(PACKAGES_BUILD)/gettext-$(GETTEXT_VERSION)

# gettext for target
GETTEXT_BINS =	autopoint gettext gettext.sh msgcat msgcomm msgen	\
		msgfilter msggrep msgmerge msguniq recode-sr-latin	\
		envsubst gettextize msgattrib msgcmp msgconv msgexec	\
		msgfmt msginit msgunfmt ngettext xgettext
GETTEXT_SBINS =
GETTEXT_INCLUDES = autosprintf.h gettext-po.h libintl.h
GETTEXT_LIBS = gettext libgettext* libasprintf* libintl*
GETTEXT_PKGCONFIGS =

GETTEXT_CONFIGURE_ENV	:= gl_cv_func_wcwidth_works=yes			\
			am_cv_func_iconv_works=yes			\
			gt_cv_func_printf_posix=yes			\
			gt_cv_int_divbyzero_sigfpe=no
GETTEXT_CONFIGURE_OPTS	:= --enable-relocatable --with-included-gettext	\
			--disable-rpath --disable-openmp --disable-java	\
			--with-libxml2-prefix=$(embtk_sysroot)/usr		\
			--disable-openmp

GETTEXT_DEPS = ncurses_install libxml2_install


define embtk_postinstall_gettext
	$(Q)test -e $(GETTEXT_BUILD_DIR)/.patchlibtool || \
	$(MAKE) $(GETTEXT_BUILD_DIR)/.patchlibtool
endef

#FIXME: this should be fixed in gettext project
$(GETTEXT_BUILD_DIR)/.patchlibtool:
	$(Q)sed \
	-i "s;/usr/$(LIBDIR)/libintl.la;$(embtk_sysroot)/$(LIBDIR)/libintl.la;" \
	$(embtk_sysroot)/usr/$(LIBDIR)/libgettextlib.la \
	$(embtk_sysroot)/usr/$(LIBDIR)/libgettextpo.la \
	$(embtk_sysroot)/usr/$(LIBDIR)/libgettextsrc.la
	$(Q)sed \
	-i "s;/usr/$(LIBDIR)/libgettextlib.la;$(embtk_sysroot)/$(LIBDIR)/libgettextlib.la;" \
	$(embtk_sysroot)/usr/$(LIBDIR)/libgettextsrc.la
	@touch $@

# gettext for host development machine
GETTEXT_HOST_NAME		:= $(GETTEXT_NAME)
GETTEXT_HOST_VERSION		:= $(GETTEXT_VERSION)
GETTEXT_HOST_SITE		:= $(GETTEXT_SITE)
GETTEXT_HOST_SITE_MIRROR1	:= $(GETTEXT_SITE_MIRROR1)
GETTEXT_HOST_SITE_MIRROR2	:= $(GETTEXT_SITE_MIRROR2)
GETTEXT_HOST_SITE_MIRROR3	:= $(GETTEXT_SITE_MIRROR3)
GETTEXT_HOST_PATCH_SITE		:= $(GETTEXT_PATCH_SITE)
GETTEXT_HOST_PACKAGE		:= $(GETTEXT_PACKAGE)
GETTEXT_HOST_SRC_DIR		:= $(embtk_toolsb)/gettext-$(GETTEXT_VERSION)
GETTEXT_HOST_BUILD_DIR		:= $(embtk_toolsb)/gettext-$(GETTEXT_VERSION)

GETTEXT_HOST_CONFIGURE_OPTS	:= --disable-java --disable-native-java	\
	--disable-openmp --with-included-gettext --with-included-glib	\
	--with-included-libcroco --with-included-libxml

