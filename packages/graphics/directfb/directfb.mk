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

DIRECTFB_NAME		:= directfb
DIRECTFB_VERSION	:= $(call embtk_get_pkgversion,directfb)
DIRECTFB_BRANCH		:= $(call embtk_get_pkgversion,directfb_branch)
DIRECTFB_SITE		:= http://www.directfb.org/downloads/Core/$(DIRECTFB_BRANCH)
DIRECTFB_PACKAGE	:= DirectFB-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_SRC_DIR	:= $(embtk_pkgb)/DirectFB-$(DIRECTFB_VERSION)
DIRECTFB_BUILD_DIR	:= $(embtk_pkgb)/DirectFB-$(DIRECTFB_VERSION)

DIRECTFB_BINS		= c64xdump dfbfx dfbinfo dfbinspector dfbmaster		\
			dfbscreen directfb-csource mkdgiff dfbdump dfbg		\
			dfbinput dfblayer dfbpenmount directfb-config mkdfiff	\
			pxa3xx_dump
DIRECTFB_SBINS		=
DIRECTFB_LIBS		= directfb* libdavinci_c64x* libdirect* libdirectfb*	\
			libfusion*
DIRECTFB_INCLUDES	= directfb*

DIRECTFB_CONFIGURE_OPTS	:= --program-suffix="" --disable-x11

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

DIRECTFB_CONFIGURE_OPTS	+= $(CONFIG_DIRECTFB_GRAPHICS-y)
DIRECTFB_CONFIGURE_OPTS	+= $(CONFIG_DIRECTFB_INPUTS-y)

# directfb deps
DIRECTFB_DEPS	:= libpng_install freetype_install libjpeg_install
DIRECTFB_DEPS	+= $(if $(CONFIG_EMBTK_DIRECTFB_INPUT_TSLIB),tslib_install)

define embtk_postinstall_directfb
	$(Q)test -e $(DIRECTFB_BUILD_DIR)/.patchlibtool ||			\
	$(MAKE) $(DIRECTFB_BUILD_DIR)/.patchlibtool
	$(Q)mkdir -p $(embtk_rootfs)
	$(Q)mkdir -p $(embtk_rootfs)/etc
	$(Q)-cp $(DIRECTFB_BUILD_DIR)/fb.modes $(embtk_rootfs)/etc
	$(Q)mkdir -p $(embtk_rootfs)/usr
	$(Q)mkdir -p $(embtk_rootfs)/usr/$(LIBDIR)
	$(Q)-cp -R $(embtk_sysroot)/usr/lib/directfb-*-* $(embtk_rootfs)/usr/$(LIBDIR)
endef

$(DIRECTFB_BUILD_DIR)/.patchlibtool:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	$(Q)DIRECTFB_LT_FILES=`find $(embtk_sysroot)/usr/lib32/directfb-* -type f -name *.la`; \
	for i in $$DIRECTFB_LT_FILES; \
	do \
	sed \
	-e "s; \/usr\/lib32\/libfusion.la ; $(embtk_sysroot)\/usr\/lib32\/libfusion.la ;" \
	-e "s; \/usr\/lib32\/libdirect.la ; $(embtk_sysroot)\/usr\/lib32\/libdirect.la ;" \
	-e "s; \/usr\/lib32\/libdirectfb.la ; $(embtk_sysroot)\/usr\/lib32\/libdirectfb.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done
	$(Q)sed \
	-e "s; \/usr\/lib32\/libfusion.la ; $(embtk_sysroot)\/usr\/lib32\/libfusion.la ;" \
	-e "s; \/usr\/lib32\/libdirect.la ; $(embtk_sysroot)\/usr\/lib32\/libdirect.la ;" \
	-e "s; \/usr\/lib32\/libdirectfb.la ; $(embtk_sysroot)\/usr\/lib32\/libdirectfb.la ;" \
	< $(embtk_sysroot)/usr/lib32/libfusion.la > libfusion.la.new; \
	mv libfusion.la.new $(embtk_sysroot)/usr/lib32/libfusion.la
	$(Q)sed \
	-e "s; \/usr\/lib32\/libfusion.la ; $(embtk_sysroot)\/usr\/lib32\/libfusion.la ;" \
	-e "s; \/usr\/lib32\/libdirect.la ; $(embtk_sysroot)\/usr\/lib32\/libdirect.la ;" \
	-e "s; \/usr\/lib32\/libdirectfb.la ; $(embtk_sysroot)\/usr\/lib32\/libdirectfb.la ;" \
	< $(embtk_sysroot)/usr/lib32/libdirectfb.la > libdirectfb.la.new; \
	mv libdirectfb.la.new $(embtk_sysroot)/usr/lib32/libdirectfb.la
else
	$(Q)DIRECTFB_LT_FILES=`find $(embtk_sysroot)/usr/lib/directfb-* -type f -name *.la`; \
	for i in $$DIRECTFB_LT_FILES; \
	do \
	sed \
	-e "s; \/usr\/lib\/libfusion.la ; $(embtk_sysroot)\/usr\/lib\/libfusion.la ;" \
	-e "s; \/usr\/lib\/libdirect.la ; $(embtk_sysroot)\/usr\/lib\/libdirect.la ;" \
	-e "s; \/usr\/lib\/libdirectfb.la ; $(embtk_sysroot)\/usr\/lib\/libdirectfb.la ;" \
	< $$i > $$i.new; \
	mv $$i.new $$i; \
	done
	$(Q)sed \
	-e "s; \/usr\/lib\/libfusion.la ; $(embtk_sysroot)\/usr\/lib\/libfusion.la ;" \
	-e "s; \/usr\/lib\/libdirect.la ; $(embtk_sysroot)\/usr\/lib\/libdirect.la ;" \
	-e "s; \/usr\/lib\/libdirectfb.la ; $(embtk_sysroot)\/usr\/lib\/libdirectfb.la ;" \
	< $(embtk_sysroot)/usr/lib/libfusion.la > libfusion.la.new; \
	mv libfusion.la.new $(embtk_sysroot)/usr/lib/libfusion.la
	$(Q)sed \
	-e "s; \/usr\/lib\/libfusion.la ; $(embtk_sysroot)\/usr\/lib\/libfusion.la ;" \
	-e "s; \/usr\/lib\/libdirect.la ; $(embtk_sysroot)\/usr\/lib\/libdirect.la ;" \
	-e "s; \/usr\/lib\/libdirectfb.la ; $(embtk_sysroot)\/usr\/lib\/libdirectfb.la ;" \
	< $(embtk_sysroot)/usr/lib/libdirectfb.la > libdirectfb.la.new; \
	mv libdirectfb.la.new $(embtk_sysroot)/usr/lib/libdirectfb.la
endif
