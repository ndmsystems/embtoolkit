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
include $(EMBTK_ROOT)/packages/graphics/atk/atk.mk
ROOTFS_COMPONENTS_CLEAN += atk_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_ATK) += atk_install

#Cairo
include $(EMBTK_ROOT)/packages/graphics/cairo/cairo.mk
ROOTFS_COMPONENTS_CLEAN += cairo_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_CAIRO) += cairo_install

#DirectFB
include $(EMBTK_ROOT)/packages/graphics/directfb/directfb.mk
ROOTFS_COMPONENTS_CLEAN += directfb_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_DIRECTFB) += directfb_install

#fontconfig
include $(EMBTK_ROOT)/packages/graphics/fontconfig/fontconfig.mk
ROOTFS_COMPONENTS_CLEAN += fontconfig_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FONTCONFIG) += fontconfig_install

#FreeFont
include $(EMBTK_ROOT)/packages/graphics/freefont/freefont.mk
ROOTFS_COMPONENTS_CLEAN += ttmkfdir_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FREEFONT_TTF) += freefont_ttf_install

#FreeType
include $(EMBTK_ROOT)/packages/graphics/freetype/freetype.mk
ROOTFS_COMPONENTS_CLEAN += freetype_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FREETYPE) += freetype_install

#gtk+
include $(EMBTK_ROOT)/packages/graphics/gtk/gtk.mk
ROOTFS_COMPONENTS_CLEAN += gtk_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GTK) += gtk_install

#libjpeg
include $(EMBTK_ROOT)/packages/graphics/libjpeg/libjpeg.mk
ROOTFS_COMPONENTS_CLEAN += libjpeg_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBJPEG) += libjpeg_install

#libpng
include $(EMBTK_ROOT)/packages/graphics/libpng/libpng.mk
ROOTFS_COMPONENTS_CLEAN += libpng_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBPNG) += libpng_install

#libtiff
include $(EMBTK_ROOT)/packages/graphics/libtiff/libtiff.mk
ROOTFS_COMPONENTS_CLEAN += libtiff_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBTIFF) += libtiff_install

#pixman
include $(EMBTK_ROOT)/packages/graphics/pixman/pixman.mk
ROOTFS_COMPONENTS_CLEAN += pixman_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_PIXMAN) += pixman_install

