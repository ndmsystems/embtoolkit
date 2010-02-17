################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2010 GAYE Abdoulaye Walsimou. All rights reserved.
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
# \file         graphics.mk
# \brief	graphics.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         February 2010
################################################################################

#atk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_ATK) += atk_install
ROOTFS_COMPONENTS_CLEAN += atk_clean
ifeq ($(CONFIG_EMBTK_HAVE_ATK),y)
include $(EMBTK_ROOT)/packages/graphics/atk/atk.mk
endif

#Cairo
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_CAIRO) += cairo_install
ROOTFS_COMPONENTS_CLEAN += cairo_clean
ifeq ($(CONFIG_EMBTK_HAVE_CAIRO),y)
include $(EMBTK_ROOT)/packages/graphics/cairo/cairo.mk
endif

#DirectFB
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_DIRECTFB) += directfb_install
ROOTFS_COMPONENTS_CLEAN += directfb_clean
ifeq ($(CONFIG_EMBTK_HAVE_DIRECTFB),y)
include $(EMBTK_ROOT)/packages/graphics/directfb/directfb.mk
endif

#fontconfig
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FONTCONFIG) += fontconfig_install
ROOTFS_COMPONENTS_CLEAN += fontconfig_clean
ifeq ($(CONFIG_EMBTK_HAVE_FONTCONFIG),y)
include $(EMBTK_ROOT)/packages/graphics/fontconfig/fontconfig.mk
endif

#FreeFont
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FREEFONT_TTF) += freefont_ttf_install
ROOTFS_COMPONENTS_CLEAN += ttmkfdir_clean
ifeq ($(CONFIG_EMBTK_HAVE_FREEFONT_TTF),y)
include $(EMBTK_ROOT)/packages/graphics/freefont/freefont.mk
endif

#FreeType
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FREETYPE) += freetype_install
ROOTFS_COMPONENTS_CLEAN += freetype_clean
ifeq ($(CONFIG_EMBTK_HAVE_FREETYPE),y)
include $(EMBTK_ROOT)/packages/graphics/freetype/freetype.mk
endif

#gtk+
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GTK) += gtk_install
ROOTFS_COMPONENTS_CLEAN += gtk_clean
ifeq ($(CONFIG_EMBTK_HAVE_GTK),y)
include $(EMBTK_ROOT)/packages/graphics/gtk/gtk.mk
endif

#libjpeg
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBJPEG) += libjpeg_install
ROOTFS_COMPONENTS_CLEAN += libjpeg_clean
ifeq ($(CONFIG_EMBTK_HAVE_LIBJPEG),y)
include $(EMBTK_ROOT)/packages/graphics/libjpeg/libjpeg.mk
endif

#libpng
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBPNG) += libpng_clean
ROOTFS_COMPONENTS_CLEAN += libpng_clean
ifeq ($(CONFIG_EMBTK_HAVE_LIBPNG),y)
include $(EMBTK_ROOT)/packages/graphics/libpng/libpng.mk
endif

#libtiff
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBTIFF) += libtiff_install
ROOTFS_COMPONENTS_CLEAN += libtiff_clean
ifeq ($(CONFIG_EMBTK_HAVE_LIBTIFF),y)
include $(EMBTK_ROOT)/packages/graphics/libtiff/libtiff.mk
endif

#pixman
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_PIXMAN) += pixman_install
ROOTFS_COMPONENTS_CLEAN += pixman_clean
ifeq ($(CONFIG_EMBTK_HAVE_PIXMAN),y)
include $(EMBTK_ROOT)/packages/graphics/pixman/pixman.mk
endif

