################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         glib.mk
# \brief	glib.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         December 2009
################################################################################

GLIB_MAJOR_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GLIB_MAJOR_VERSION_STRING)))
GLIB_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GLIB_VERSION_STRING)))
GLIB_SITE := http://ftp.gnome.org/pub/gnome/sources/glib/$(GLIB_MAJOR_VERSION)
GLIB_PACKAGE := glib-$(GLIB_VERSION).tar.bz2
GLIB_BUILD_DIR := $(PACKAGES_BUILD)/glib-$(GLIB_VERSION)

GLIB_BINS = 	glib-genmarshal glib-gettextize glib-mkenums gobject-query \
		gtester gtester-report
GLIB_SBINS =
GLIB_INCLUDES = gio-unix-* glib-*
GLIB_LIBS = gio* libgio-* libglib-* libgmodule-* libgobject-* libgthread-* glib-*
GLIB_PKGCONFIGS = gio-*.pc glib-*.pc gmodule-*.pc gobject-*.pc gthread-*.pc

glib_install: $(GLIB_BUILD_DIR)/.installed

$(GLIB_BUILD_DIR)/.installed: gettext_install download_glib \
	$(GLIB_BUILD_DIR)/.decompressed $(GLIB_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	glib-$(GLIB_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(GLIB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(GLIB_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(GLIB_BUILD_DIR)/.patchlibtool
	@touch $@

download_glib:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(GLIB_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(GLIB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(GLIB_PACKAGE) \
	$(GLIB_SITE)/$(GLIB_PACKAGE)

$(GLIB_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(GLIB_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjvf $(DOWNLOAD_DIR)/$(GLIB_PACKAGE)
	@touch $@

$(GLIB_BUILD_DIR)/.configured:
	$(Q)cd $(GLIB_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CXX=$(TARGETCXX_CACHED) \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/lib -L$(SYSROOT)/usr/lib \
	-L$(SYSROOT)/lib32 -L$(SYSROOT)/usr/lib32" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	glib_cv_stack_grows=no \
	glib_cv_uscore=yes \
	ac_cv_func_posix_getpwuid_r=yes \
	ac_cv_func_nonposix_getpwuid_r=no \
	ac_cv_func_posix_getgrgid_r=yes \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr --disable-fam
	@touch $@

#FIXME: this should be fixed in glib2 project
$(GLIB_BUILD_DIR)/.patchlibtool:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)sed \
	-e "s;\/usr\/lib32\/libgobject-2.0.la;$(SYSROOT)\/usr\/lib32\/libgobject-2.0.la;" \
	-e "s;\/usr\/lib32\/libgmodule-2.0.la;$(SYSROOT)\/usr\/lib32\/libgmodule-2.0.la;" \
	-e "s;\/usr\/lib32\/libglib-2.0.la;$(SYSROOT)\/usr\/lib32\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/lib32/libgio-2.0.la > libgio-2.0.la.new; \
	mv libgio-2.0.la.new $(SYSROOT)/usr/lib32/libgio-2.0.la
	$(Q)sed \
	-e "s;\/usr\/lib32\/libglib-2.0.la;$(SYSROOT)\/usr\/lib32\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/lib32/libgmodule-2.0.la > libgmodule-2.0.la.new; \
	mv libgmodule-2.0.la.new $(SYSROOT)/usr/lib32/libgmodule-2.0.la
	$(Q)sed \
	-e "s;\/usr\/lib32\/libglib-2.0.la;$(SYSROOT)\/usr\/lib32\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/lib32/libgobject-2.0.la > libgobject-2.0.la.new; \
	mv libgobject-2.0.la.new $(SYSROOT)/usr/lib32/libgobject-2.0.la
	$(Q)sed \
	-e "s;\/usr\/lib32\/libglib-2.0.la;$(SYSROOT)\/usr\/lib32\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/lib32/libgthread-2.0.la > libgthread-2.0.la.new; \
	mv libgthread-2.0.la.new $(SYSROOT)/usr/lib32/libgthread-2.0.la
else
	$(Q)sed \
	-e "s;\/usr\/lib\/libgobject-2.0.la;$(SYSROOT)\/usr\/lib\/libgobject-2.0.la;" \
	-e "s;\/usr\/lib\/libgmodule-2.0.la;$(SYSROOT)\/usr\/lib\/libgmodule-2.0.la;" \
	-e "s;\/usr\/lib\/libglib-2.0.la;$(SYSROOT)\/usr\/lib\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/lib/libgio-2.0.la > libgio-2.0.la.new; \
	mv libgio-2.0.la.new $(SYSROOT)/usr/lib/libgio-2.0.la
	$(Q)sed \
	-e "s;\/usr\/lib\/libglib-2.0.la;$(SYSROOT)\/usr\/lib\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/lib/libgmodule-2.0.la > libgmodule-2.0.la.new; \
	mv libgmodule-2.0.la.new $(SYSROOT)/usr/lib/libgmodule-2.0.la
	$(Q)sed \
	-e "s;\/usr\/lib\/libglib-2.0.la;$(SYSROOT)\/usr\/lib\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/lib/libgobject-2.0.la > libgobject-2.0.la.new; \
	mv libgobject-2.0.la.new $(SYSROOT)/usr/lib/libgobject-2.0.la
	$(Q)sed \
	-e "s;\/usr\/lib\/libglib-2.0.la;$(SYSROOT)\/usr\/lib\/libglib-2.0.la;" \
	< $(SYSROOT)/usr/lib/libgthread-2.0.la > libgthread-2.0.la.new; \
	mv libgthread-2.0.la.new $(SYSROOT)/usr/lib/libgthread-2.0.la
endif

glib_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup glib-$(GLIB_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(GLIB_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(GLIB_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(GLIB_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(GLIB_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib/pkgconfig; rm -rf $(GLIB_PKGCONFIGS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(GLIB_LIBS)
	$(Q)-cd $(SYSROOT)/usr/lib32/pkgconfig; rm -rf $(GLIB_PKGCONFIGS)
endif

