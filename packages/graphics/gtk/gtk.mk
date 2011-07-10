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
# \file         gtk.mk
# \brief	gtk.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

GTK_NAME		:= gtk+
GTK_MAJOR_VERSION	:= $(call embtk_get_pkgversion,gtk_major)
GTK_VERSION		:= $(call embtk_get_pkgversion,gtk)
GTK_SITE		:= http://ftp.gnome.org/pub/gnome/sources/gtk+/$(GTK_MAJOR_VERSION)
GTK_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
GTK_PATCH_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/gtk/$(GTK_VERSION)
GTK_PACKAGE		:= gtk+-$(GTK_VERSION).tar.bz2
GTK_SRC_DIR		:= $(PACKAGES_BUILD)/gtk+-$(GTK_VERSION)
GTK_BUILD_DIR		:= $(PACKAGES_BUILD)/gtk+-$(GTK_VERSION)

GTK_BINS	= gtk-* gdk-*
GTK_SBINS	=
GTK_INCLUDES	= gail-* gtk-*
GTK_LIBS	= gtk-* libgail* libgdk-* libgdk_* libgtk-*
GTK_PKGCONFIGS	= gail*.pc gdk*.pc gtk*.pc
GTK_ETC		= gtk-*

GTK_DEPS	:=	libjpeg_install libpng_install libtiff_install \
			fontconfig_install glib_install gdkpixbuf_host_install \
			atk_install cairo_install pango_install
ifeq ($(CONFIG_EMBTK_GTK_BACKEND_DIRECTFB),y)
GTK_BACKEND	:= --with-gdktarget=directfb --without-x
GTK_DEPS	+= directfb_install
else
GTK_BACKEND	:= --with-gdktarget=x11 --with-x --with-xinput=yes
GTK_DEPS	+= libx11_install libxext_install libxrender_install xinput_install
endif

GTK_CONFIGURE_ENV	:= gio_can_sniff=yes
GTK_CONFIGURE_OPTS	:= $(GTK_BACKEND)
GTK_CONFIGURE_OPTS	+= --disable-cups --disable-gtk-doc --disable-glibtest
GTK_CONFIGURE_OPTS	+= LIBPNG=-lpng

gtk_install:
	$(call embtk_install_pkg,gtk)
	$(Q)test -e $(GTK_BUILD_DIR)/.patchlibtool || \
	$(MAKE) $(GTK_BUILD_DIR)/.patchlibtool
	$(Q)$(MAKE) $(GTK_BUILD_DIR)/.special

download_gtk:
	$(call embtk_download_pkg,gtk)

gtk_clean:
	$(call embtk_cleanup_pkg,gtk)

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
	$(Q)-cp -R $(SYSROOT)/usr/$(LIBDIR)/gtk-* $(ROOTFS)/usr/$(LIBDIR)/
	@touch $@
