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
# \file         directfb.mk
# \brief	directfb.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         October 2009
################################################################################

DIRECTFB_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_DIRECTFB_VERSION_STRING)))
DIRECTFB_BRANCH := $(subst ",,$(strip $(CONFIG_EMBTK_DIRECTFB_BRANCH_STRING)))
DIRECTFB_SITE := http://www.directfb.org/downloads/Core/$(DIRECTFB_BRANCH)
DIRECTFB_PACKAGE := DirectFB-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_BUILD_DIR := $(PACKAGES_BUILD)/DirectFB-$(DIRECTFB_VERSION)

DIRECTFB_BINS = c64xdump dfbfx dfbinfo dfbinspector dfbmaster dfbscreen \
	directfb-csource mkdgiff dfbdump dfbg dfbinput dfblayer dfbpenmount \
	directfb-config mkdfiff pxa3xx_dump
DIRECTFB_SBINS =
DIRECTFB_LIBS = directfb* libdavinci_c64x* libdirect* libdirectfb* libfusion*
DIRECTFB_INCLUDES = directfb*

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
FREETYPE_LIBS_FLAGS := "-L$(ROOTFS)/usr/lib32 -lfreetype"
else
FREETYPE_LIBS_FLAGS := "-L$(ROOTFS)/usr/lib -lfreetype"
endif
FREETYPE_CFLAGS_FLAGS := "-I$(SYSROOT)/usr/include/freetype2"

directfb_install: $(DIRECTFB_BUILD_DIR)/.installed

$(DIRECTFB_BUILD_DIR)/.installed: libpng_install freetype_install \
	libjpeg_install download_directfb \
	$(DIRECTFB_BUILD_DIR)/.decompressed $(DIRECTFB_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	DirectFB-$(DIRECTFB_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(DIRECTFB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(DIRECTFB_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(DIRECTFB_BUILD_DIR)/.patchlibtool
	$(Q)-cp $(DIRECTFB_BUILD_DIR)/fb.modes $(ROOTFS)/etc/
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cp -R $(SYSROOT)/usr/lib32/directfb-*-* $(ROOTFS)/usr/lib32
	$(Q)-cp -R $(SYSROOT)/usr/lib/directfb-*-* $(ROOTFS)/usr/lib
else
	$(Q)-cp -R $(SYSROOT)/usr/lib/directfb-*-* $(ROOTFS)/usr/lib
endif
	@touch $@

download_directfb:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(DIRECTFB_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(DIRECTFB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(DIRECTFB_PACKAGE) \
	$(DIRECTFB_SITE)/$(DIRECTFB_PACKAGE)

$(DIRECTFB_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(DIRECTFB_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(DIRECTFB_PACKAGE)
	@touch $@

$(DIRECTFB_BUILD_DIR)/.configured:
	cd $(DIRECTFB_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(ROOTFS)/usr/lib -L$(ROOTFS)/usr/lib32 \
	-L$(ROOTFS)/lib -L$(ROOTFS)/lib32 \
	-L$(SYSROOT)/usr/lib -L$(SYSROOT)/usr/lib32 \
	-L$(SYSROOT)/lib -L$(SYSROOT)/lib32" \
	CPPFLAGS="-I$(SYSROOT)/usr/include" \
	FREETYPE_LIBS=$(FREETYPE_LIBS_FLAGS) \
	FREETYPE_CFLAGS=$(FREETYPE_CFLAGS_FLAGS) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --prefix=/usr \
	--enable-static=no  --program-suffix=""
	@touch $@

$(DIRECTFB_BUILD_DIR)/.patchlibtool:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)DIRECTFB_LT_FILES=`find $(SYSROOT)/usr/lib32/directfb-* -type f -name *.la`; \
	for i in $$DIRECTFB_LT_FILES; \
	do \
	sed \
	-e "s; \/usr\/lib32\/libfusion.la ; $(SYSROOT)\/usr\/lib32\/libfusion.la ;" \
	-e "s; \/usr\/lib32\/libdirect.la ; $(SYSROOT)\/usr\/lib32\/libdirect.la ;" \
	-e "s; \/usr\/lib32\/libdirectfb.la ; $(SYSROOT)\/usr\/lib32\/libdirectfb.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done
	$(Q)sed \
	-e "s; \/usr\/lib32\/libfusion.la ; $(SYSROOT)\/usr\/lib32\/libfusion.la ;" \
	-e "s; \/usr\/lib32\/libdirect.la ; $(SYSROOT)\/usr\/lib32\/libdirect.la ;" \
	-e "s; \/usr\/lib32\/libdirectfb.la ; $(SYSROOT)\/usr\/lib32\/libdirectfb.la ;" \
	< $(SYSROOT)/usr/lib32/libfusion.la > libfusion.la.new; \
	mv libfusion.la.new $(SYSROOT)/usr/lib32/libfusion.la
	$(Q)sed \
	-e "s; \/usr\/lib32\/libfusion.la ; $(SYSROOT)\/usr\/lib32\/libfusion.la ;" \
	-e "s; \/usr\/lib32\/libdirect.la ; $(SYSROOT)\/usr\/lib32\/libdirect.la ;" \
	-e "s; \/usr\/lib32\/libdirectfb.la ; $(SYSROOT)\/usr\/lib32\/libdirectfb.la ;" \
	< $(SYSROOT)/usr/lib32/libdirectfb.la > libdirectfb.la.new; \
	mv libdirectfb.la.new $(SYSROOT)/usr/lib32/libdirectfb.la
else
	$(Q)DIRECTFB_LT_FILES=`find $(SYSROOT)/usr/lib/directfb-* -type f -name *.la`; \
	for i in $$DIRECTFB_LT_FILES; \
	do \
	sed \
	-e "s; \/usr\/lib\/libfusion.la ; $(SYSROOT)\/usr\/lib\/libfusion.la ;" \
	-e "s; \/usr\/lib\/libdirect.la ; $(SYSROOT)\/usr\/lib\/libdirect.la ;" \
	-e "s; \/usr\/lib\/libdirectfb.la ; $(SYSROOT)\/usr\/lib\/libdirectfb.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done
	$(Q)sed \
	-e "s; \/usr\/lib\/libfusion.la ; $(SYSROOT)\/usr\/lib\/libfusion.la ;" \
	-e "s; \/usr\/lib\/libdirect.la ; $(SYSROOT)\/usr\/lib\/libdirect.la ;" \
	-e "s; \/usr\/lib\/libdirectfb.la ; $(SYSROOT)\/usr\/lib\/libdirectfb.la ;" \
	< $(SYSROOT)/usr/lib/libfusion.la > libfusion.la.new; \
	mv libfusion.la.new $(SYSROOT)/usr/lib/libfusion.la
	$(Q)sed \
	-e "s; \/usr\/lib\/libfusion.la ; $(SYSROOT)\/usr\/lib\/libfusion.la ;" \
	-e "s; \/usr\/lib\/libdirect.la ; $(SYSROOT)\/usr\/lib\/libdirect.la ;" \
	-e "s; \/usr\/lib\/libdirectfb.la ; $(SYSROOT)\/usr\/lib\/libdirectfb.la ;" \
	< $(SYSROOT)/usr/lib/libdirectfb.la > libdirectfb.la.new; \
	mv libdirectfb.la.new $(SYSROOT)/usr/lib/libdirectfb.la
endif

directfb_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup directfb-$(DIRECTFB_VERSION)...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(DIRECTFB_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(DIRECTFB_SBINS)
	$(Q)-cd $(SYSROOT)/usr/lib; rm -rf $(DIRECTFB_LIBS)
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cd $(SYSROOT)/usr/lib32; rm -rf $(DIRECTFB_LIBS)
endif
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(DIRECTFB_INCLUDES)

