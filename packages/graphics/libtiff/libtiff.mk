################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         libtiff.mk
# \brief	libtiff.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBTIFF_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_LIBTIFF_VERSION_STRING)))
LIBTIFF_SITE := ftp://ftp.remotesensing.org/pub/libtiff
LIBTIFF_PACKAGE := tiff-$(LIBTIFF_VERSION).tar.gz
LIBTIFF_BUILD_DIR := $(PACKAGES_BUILD)/tiff-$(LIBTIFF_VERSION)

LIBTIFF_BINS =	vbmp2tiff fax2tiff pal2rgb  ras2tiff rgb2ycbcr tiff2bw tiff2ps \
		tiffcmp tiffcrop tiffdump tiffmedian tiffsplit fax2ps gif2tiff \
		ppm2tiff raw2tiff thumbnail tiff2pdf tiff2rgba tiffcp \
		tiffdither tiffinfo tiffset bmp2tiff
LIBTIFF_SBINS =
LIBTIFF_INCLUDES = tiffconf.h tiff.h tiffio.h tiffio.hxx tiffvers.h
LIBTIFF_LIBS = libtiff*
LIBTIFF_PKGCONFIGS =

libtiff_install:
	@test -e $(LIBTIFF_BUILD_DIR)/.installed || \
	$(MAKE) $(LIBTIFF_BUILD_DIR)/.installed

$(LIBTIFF_BUILD_DIR)/.installed: download_libtiff \
	$(LIBTIFF_BUILD_DIR)/.decompressed $(LIBTIFF_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	libtiff-$(LIBTIFF_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH, $(LIBTIFF_BUILD_DIR))
	$(Q)$(MAKE) -C $(LIBTIFF_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(LIBTIFF_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

download_libtiff:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(LIBTIFF_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(LIBTIFF_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(LIBTIFF_PACKAGE) \
	$(LIBTIFF_SITE)/$(LIBTIFF_PACKAGE)

$(LIBTIFF_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(LIBTIFF_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzf $(DOWNLOAD_DIR)/$(LIBTIFF_PACKAGE)
	@touch $@

$(LIBTIFF_BUILD_DIR)/.configured:
	$(Q)cd $(LIBTIFF_BUILD_DIR); \
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
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --disable-cxx \
	--prefix=/usr --program-prefix="" --libdir=/usr/$(LIBDIR)
	@touch $@

libtiff_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup libtiff...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(LIBTIFF_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(LIBTIFF_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(LIBTIFF_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(LIBTIFF_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(LIBTIFF_PKGCONFIGS)
	$(Q)-rm -rf $(LIBTIFF_BUILD_DIR)*

