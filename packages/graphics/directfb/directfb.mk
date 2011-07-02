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
# \file         directfb.mk
# \brief	directfb.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
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

CONFIG_DIRECTFB_OPTS :=	--build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
			--target=$(STRICT_GNU_TARGET) --prefix=/usr \
			--program-suffix="" --disable-x11

#Graphics
CONFIG_DIRECTFB_GRAPHICS-y := --with-gfxdrivers="
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_ATI128) += ati128
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_CLE266) += , cle266
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_CYBER5K) += , cyber5k
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_DAVINCI) += , davinci
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_EP9X) += , ep9x
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_GL) += , gl
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_I810) += , i810
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_I830) += , i830
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_MACH64) += , mach64
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_MATROX) += , matrox
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_NEOMAGIC) += , neomagic
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_NSC) += , nsc
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_NVIDIA) += , nvidia
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_OMAP) += , omap
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_PXA3XX) += , pxa3xx
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_RADEON) += , radeon
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_SAVAGE) += , savage
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_SH772X) += , sh772x
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_SIS315) += , sis315
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_TDFX) += , tdfx
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_UNICHROME) += , unichrome
CONFIG_DIRECTFB_GRAPHICS-$(CONFIG_EMBTK_DIRECTFB_GRAPHIC_VMWARE) += , vmware
CONFIG_DIRECTFB_GRAPHICS-y +="


#Inputs
CONFIG_DIRECTFB_INPUTS-y := --with-inputdrivers="
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_DBOX2REMOTE) += dbox2remote
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_DBOXREMOTE) += , dreamboxremote
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_DYNAPRO) += , dynapro
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_ELOINPUT) += , elo-input
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_GUNZE) += , gunze
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_H3600TS) += , h3600_ts
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_JOYSTICK) += , joystick
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_KEYBOARD) += , keyboard
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_LINUXINPUT) += , linuxinput
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_LIRC) += , lirc
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_MUTOUCH) += , mutouch
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_PENMOUNT) += , penmount
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_PS2MOUSE) += , ps2mouse
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_SERIALMOUSE) += , serialmouse
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_SONYPIJOGDIAL) += , sonypijogdial
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_TSLIB) += , tslib
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_UC1X00) += , ucb1x00
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_WM97XX) += , wm97xx
CONFIG_DIRECTFB_INPUTS-$(CONFIG_EMBTK_DIRECTFB_INPUT_ZYTRONIC) += , zytronic
CONFIG_DIRECTFB_INPUTS-y +="

#directfb deps
DIRECTFB_DEPS := libpng_install freetype_install libjpeg_install
ifeq ($(CONFIG_EMBTK_DIRECTFB_INPUT_TSLIB),y)
DIRECTFB_DEPS += tslib_install
endif

directfb_install:
	@test -e $(DIRECTFB_BUILD_DIR)/.installed || \
	$(MAKE) $(DIRECTFB_BUILD_DIR)/.installed
	$(Q)$(MAKE) $(DIRECTFB_BUILD_DIR)/.special

$(DIRECTFB_BUILD_DIR)/.installed:  $(DIRECTFB_DEPS) download_directfb \
	$(DIRECTFB_BUILD_DIR)/.decompressed $(DIRECTFB_BUILD_DIR)/.configured
	$(call embtk_generic_message,"Compiling and installing \
	DirectFB-$(DIRECTFB_VERSION) in your root filesystem...")
	$(call __embtk_kill_lt_rpath, $(DIRECTFB_BUILD_DIR))
	$(Q)$(MAKE) -C $(DIRECTFB_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(DIRECTFB_BUILD_DIR) DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	$(Q)$(MAKE) $(DIRECTFB_BUILD_DIR)/.patchlibtool
	@touch $@

download_directfb:
	$(call embtk_generic_message,"Downloading $(DIRECTFB_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(DIRECTFB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(DIRECTFB_PACKAGE) \
	$(DIRECTFB_SITE)/$(DIRECTFB_PACKAGE)

$(DIRECTFB_BUILD_DIR)/.decompressed:
	$(call embtk_generic_message,"Decompressing $(DIRECTFB_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(DIRECTFB_PACKAGE)
	@touch $@

$(DIRECTFB_BUILD_DIR)/.configured:
	cd $(DIRECTFB_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLAGS="-I$(SYSROOT)/usr/include" \
	./configure $(CONFIG_DIRECTFB_OPTS) $(CONFIG_DIRECTFB_GRAPHICS-y) \
	$(CONFIG_DIRECTFB_INPUTS-y) --libdir=/usr/$(LIBDIR)
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

.PHONY: $(DIRECTFB_BUILD_DIR)/.special directfb_clean

$(DIRECTFB_BUILD_DIR)/.special:
	$(Q)-cp $(DIRECTFB_BUILD_DIR)/fb.modes $(ROOTFS)/etc/
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)-cp -R $(SYSROOT)/usr/lib32/directfb-*-* $(ROOTFS)/usr/lib32
	$(Q)-cp -R $(SYSROOT)/usr/lib/directfb-*-* $(ROOTFS)/usr/lib
else
	$(Q)-cp -R $(SYSROOT)/usr/lib/directfb-*-* $(ROOTFS)/usr/lib
endif
	@touch $@

directfb_clean:
	$(call embtk_generic_message,"cleanup directfb...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(DIRECTFB_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(DIRECTFB_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(DIRECTFB_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(DIRECTFB_LIBS)
	$(Q)-rm -rf $(DIRECTFB_BUILD_DIR)*

