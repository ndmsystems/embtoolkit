################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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
# \file         graphics.mk
# \brief	graphics.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

#atk
include $(EMBTK_ROOT)/packages/graphics/atk/atk.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_ATK) += atk_install

#Cairo
include $(EMBTK_ROOT)/packages/graphics/cairo/cairo.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_CAIRO) += cairo_install

#DirectFB
include $(EMBTK_ROOT)/packages/graphics/directfb/directfb.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_DIRECTFB) += directfb_install

#fontconfig
include $(EMBTK_ROOT)/packages/graphics/fontconfig/fontconfig.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FONTCONFIG) += fontconfig_install

#FreeFont
include $(EMBTK_ROOT)/packages/graphics/freefont/freefont.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FREEFONT_TTF) += freefont_ttf_install

#FreeType
include $(EMBTK_ROOT)/packages/graphics/freetype/freetype.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FREETYPE) += freetype_install

#gtk+
include $(EMBTK_ROOT)/packages/graphics/gtk/gtk.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GTK) += gtk_install

#imlib2
include $(EMBTK_ROOT)/packages/graphics/imlib2/imlib2.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_IMLIB2) += imlib2_install

#libjpeg
include $(EMBTK_ROOT)/packages/graphics/libjpeg/libjpeg.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBJPEG) += libjpeg_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_LIBJPEG) += libjpeg_host_install

#libpng
include $(EMBTK_ROOT)/packages/graphics/libpng/libpng.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBPNG) += libpng_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_LIBPNG) += libpng_host_install

#libtiff
include $(EMBTK_ROOT)/packages/graphics/libtiff/libtiff.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBTIFF) += libtiff_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_LIBTIFF) += libtiff_host_install

#Pango
include $(EMBTK_ROOT)/packages/graphics/pango/pango.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_PANGO) += pango_install

#pixman
include $(EMBTK_ROOT)/packages/graphics/pixman/pixman.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_PIXMAN) += pixman_install

