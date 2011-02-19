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
# \file         gettext.mk
# \brief	gettext.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

GETTEXT_NAME := gettext
GETTEXT_VERSION := $(call EMBTK_GET_PKG_VERSION,GETTEXT)
GETTEXT_SITE := http://ftp.gnu.org/pub/gnu/gettext
GETTEXT_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GETTEXT_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/gettext/$(GETTEXT_VERSION)
GETTEXT_PACKAGE := gettext-$(GETTEXT_VERSION).tar.gz
GETTEXT_SRC_DIR := $(PACKAGES_BUILD)/gettext-$(GETTEXT_VERSION)
GETTEXT_BUILD_DIR := $(PACKAGES_BUILD)/gettext-$(GETTEXT_VERSION)

GETTEXT_BINS =	autopoint gettext gettext.sh msgcat msgcomm msgen	\
		msgfilter msggrep msgmerge msguniq recode-sr-latin	\
		envsubst gettextize msgattrib msgcmp msgconv msgexec	\
		msgfmt msginit msgunfmt ngettext xgettext
GETTEXT_SBINS =
GETTEXT_INCLUDES = autosprintf.h gettext-po.h libintl.h
GETTEXT_LIBS = gettext libgettext* libasprintf* libintl*
GETTEXT_PKGCONFIGS =

GETTEXT_CONFIGURE_ENV := gl_cv_func_wcwidth_works=yes			\
			am_cv_func_iconv_works=yes			\
			gt_cv_func_printf_posix=yes			\
			gt_cv_int_divbyzero_sigfpe=no
GETTEXT_CONFIGURE_OPTS := --enable-relocatable --with-included-gettext	\
			--disable-rpath --disable-openmp --disable-java	\
			--with-libxml2-prefix=$(SYSROOT)/usr		\
			--disable-openmp

GETTEXT_DEPS = ncurses_install libxml2_install

gettext_install:
	@test -e $(GETTEXT_BUILD_DIR)/.installed || \
	$(MAKE) $(GETTEXT_BUILD_DIR)/.installed

$(GETTEXT_BUILD_DIR)/.installed: $(GETTEXT_DEPS) download_gettext \
	$(GETTEXT_BUILD_DIR)/.decompressed $(GETTEXT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	gettext-$(GETTEXT_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(GETTEXT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(GETTEXT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) $(GETTEXT_BUILD_DIR)/.patchlibtool
	@touch $@

download_gettext:
	$(call EMBTK_DOWNLOAD_PKG,GETTEXT)

$(GETTEXT_BUILD_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,GETTEXT)

$(GETTEXT_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,GETTEXT)

gettext_clean:
	$(call EMBTK_CLEANUP_PKG,GETTEXT)

#FIXME: this should be fixed in gettext project
$(GETTEXT_BUILD_DIR)/.patchlibtool:
	$(Q)sed \
	-i "s;/usr/$(LIBDIR)/libintl.la;$(SYSROOT)/$(LIBDIR)/libintl.la;" \
	$(SYSROOT)/usr/$(LIBDIR)/libgettextlib.la \
	$(SYSROOT)/usr/$(LIBDIR)/libgettextpo.la \
	$(SYSROOT)/usr/$(LIBDIR)/libgettextsrc.la
	$(Q)sed \
	-i "s;/usr/$(LIBDIR)/libgettextlib.la;$(SYSROOT)/$(LIBDIR)/libgettextlib.la;" \
	$(SYSROOT)/usr/$(LIBDIR)/libgettextsrc.la

