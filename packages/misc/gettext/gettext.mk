################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009-2010 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
################################################################################
#
# \file         gettext.mk
# \brief	gettext.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

GETTEXT_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GETTEXT_VERSION_STRING)))
GETTEXT_SITE := http://ftp.gnu.org/pub/gnu/gettext
GETTEXT_PACKAGE := gettext-$(GETTEXT_VERSION).tar.gz
GETTEXT_BUILD_DIR := $(PACKAGES_BUILD)/gettext-$(GETTEXT_VERSION)

GETTEXT_BINS =	autopoint gettext gettext.sh msgcat msgcomm msgen msgfilter \
		msggrep msgmerge msguniq recode-sr-latin envsubst gettextize \
		msgattrib msgcmp msgconv msgexec msgfmt msginit msgunfmt \
		ngettext xgettext
GETTEXT_SBINS =
GETTEXT_INCLUDES = autosprintf.h gettext-po.h libintl.h
GETTEXT_LIBS = gettext libgettext* libasprintf* libintl*
GETTEXT_PKGCONFIGS =

GETTEXT_DEPS = ncurses_install libxml2_install

gettext_install: $(GETTEXT_BUILD_DIR)/.installed

$(GETTEXT_BUILD_DIR)/.installed: $(GETTEXT_DEPS) download_gettext \
	$(GETTEXT_BUILD_DIR)/.decompressed $(GETTEXT_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	gettext-$(GETTEXT_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(GETTEXT_BUILD_DIR))
	$(Q)$(MAKE) -C $(GETTEXT_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(GETTEXT_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) $(GETTEXT_BUILD_DIR)/.patchlibtool
	@touch $@

download_gettext:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(GETTEXT_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(GETTEXT_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(GETTEXT_PACKAGE) \
	$(GETTEXT_SITE)/$(GETTEXT_PACKAGE)

$(GETTEXT_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(GETTEXT_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(GETTEXT_PACKAGE)
	@touch $@

$(GETTEXT_BUILD_DIR)/.configured:
	$(Q)cd $(GETTEXT_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CXX=$(TARGETCXX_CACHED) \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	gl_cv_func_wcwidth_works=yes \
	am_cv_func_iconv_works=yes \
	gt_cv_func_printf_posix=yes \
	gt_cv_int_divbyzero_sigfpe=no \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr --enable-relocatable --with-included-gettext \
	--disable-rpath --disable-openmp --disable-java \
	--with-libxml2-prefix=$(SYSROOT)/usr --disable-openmp
	@touch $@

gettext_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup gettext-$(GETTEXT_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(GETTEXT_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(GETTEXT_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(GETTEXT_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(GETTEXT_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(GETTEXT_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(GETTEXT_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(GETTEXT_PKGCONFIGS)
endif

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

