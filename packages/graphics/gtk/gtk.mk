################################################################################
# Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# Copyright(C) 2009-2010 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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
# \file         gtk.mk
# \brief	gtk.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

GTK_MAJOR_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GTK_MAJOR_VERSION_STRING)))
GTK_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GTK_VERSION_STRING)))
GTK_SITE := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(GTK_MAJOR_VERSION)
GTK_PACKAGE := gtk+-$(GTK_VERSION).tar.bz2
GTK_BUILD_DIR := $(PACKAGES_BUILD)/gtk+-$(GTK_VERSION)

GTK_BINS = gtk-* gdk-*
GTK_SBINS =
GTK_INCLUDES = gail-* gtk-*
GTK_LIBS = gtk-* libgail* libgdk-* libgdk_* libgtk-*
GTK_PKGCONFIGS = gail*.pc gdk*.pc gtk*.pc

GTK_DEPS := libjpeg_install libpng_install libtiff_install fontconfig_install \
		glib_install atk_install cairo_install pango_install

ifeq ($(CONFIG_EMBTK_GTK_BACKEND_DIRECTFB),y)
GTK_BACKEND := --with-gdktarget=directfb --without-x
GTK_DEPS += directfb_install
else
GTK_BACKEND := --with-gdktarget=x11 --with-x
GTK_DEPS += libx11_install libxext_install libxrender_install
endif

gtk_install: $(GTK_BUILD_DIR)/.installed $(GTK_BUILD_DIR)/.special

$(GTK_BUILD_DIR)/.installed: $(GTK_DEPS) download_gtk \
	$(GTK_BUILD_DIR)/.decompressed $(GTK_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	gtk-$(GTK_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(GTK_BUILD_DIR))
	$(Q)$(MAKE) -C $(GTK_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(GTK_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(GTK_BUILD_DIR)/.patchlibtool
	@touch $@

download_gtk:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(GTK_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(GTK_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(GTK_PACKAGE) \
	$(GTK_SITE)/$(GTK_PACKAGE)

$(GTK_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(GTK_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(GTK_PACKAGE)
	@touch $@

$(GTK_BUILD_DIR)/.configured:
	$(Q)cd $(GTK_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) \
	CXX=$(TARGETCXX_CACHED) \
	AR=$(TARGETAR) \
	RANLIB=$(TARGETRANLIB) \
	AS=$(CROSS_COMPILE)as \
	LD=$(TARGETLD) \
	NM=$(TARGETNM) \
	STRIP=$(TARGETSTRIP) \
	OBJDUMP=$(TARGETOBJDUMP) \
	OBJCOPY=$(TARGETOBJCOPY) \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	gio_can_sniff=yes \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) \
	--prefix=/usr --disable-cups --disable-gtk-doc --disable-glibtest \
	$(GTK_BACKEND) --libdir=/usr/$(LIBDIR)
	@touch $@

$(GTK_BUILD_DIR)/.patchlibtool:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	GTK_LT_FILES=`find $(SYSROOT)/usr/lib32/ -type f -name *.la`; \
	for i in $$GTK_LT_FILES; \
	do \
	sed \
	-e "s; \/usr\/lib32\/libgtk-directfb-2.0.la ; $(SYSROOT)\/usr\/lib32\/libgtk-directfb-2.0.la ;" \
	-e "s; \/usr\/lib32\/libgdk-directfb-2.0.la ; $(SYSROOT)\/usr\/lib32\/libgdk-directfb-2.0.la ;" \
	-e "s; \/usr\/lib32\/libgdk_pixbuf-2.0.la ; $(SYSROOT)\/usr\/lib32\/libgdk_pixbuf-2.0.la ;" \
	-e "s; \/usr\/lib\/libgtk-x11-2.0.la ; $(SYSROOT)\/usr\/lib\/libgtk-x11-2.0.la ;" \
	-e "s; \/usr\/lib\/libgdk-x11-2.0.la ; $(SYSROOT)\/usr\/lib\/libgdk-x11-2.0.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done
else
	GTK_LT_FILES=`find $(SYSROOT)/usr/lib/ -type f -name *.la`; \
	for i in $$GTK_LT_FILES; \
	do \
	sed \
	-e "s; \/usr\/lib\/libgtk-directfb-2.0.la ; $(SYSROOT)\/usr\/lib\/libgtk-directfb-2.0.la ;" \
	-e "s; \/usr\/lib\/libgdk-directfb-2.0.la ; $(SYSROOT)\/usr\/lib\/libgdk-directfb-2.0.la ;" \
	-e "s; \/usr\/lib\/libgdk_pixbuf-2.0.la ; $(SYSROOT)\/usr\/lib\/libgdk_pixbuf-2.0.la ;" \
	-e "s; \/usr\/lib\/libgtk-x11-2.0.la ; $(SYSROOT)\/usr\/lib\/libgtk-x11-2.0.la ;" \
	-e "s; \/usr\/lib\/libgdk-x11-2.0.la ; $(SYSROOT)\/usr\/lib\/libgdk-x11-2.0.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done
endif


.PHONY: gtk_clean $(GTK_BUILD_DIR)/.special

$(GTK_BUILD_DIR)/.special:
	$(Q)-cp -R $(SYSROOT)/usr/etc/gtk-* $(ROOTFS)/etc/
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cp -R $(SYSROOT)/usr/lib32/gtk-* $(ROOTFS)/usr/lib32/
else
	$(Q)-cp -R $(SYSROOT)/usr/lib/gtk-* $(ROOTFS)/usr/lib/
endif
	@touch $@

gtk_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup gtk-$(GTK_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(GTK_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(GTK_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(GTK_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(GTK_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(GTK_PKGCONFIGS)

