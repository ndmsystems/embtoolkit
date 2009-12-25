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
# \file         packages.mk
# \brief	packages.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
################################################################################

################################################################################
#################### Common include for target and host ########################
################################################################################

include $(EMBTK_ROOT)/mk/zlib.mk
include $(EMBTK_ROOT)/mk/lzo.mk
include $(EMBTK_ROOT)/mk/mtd-utils.mk
include $(EMBTK_ROOT)/mk/termcap.mk

#gdb
ifeq ($(CONFIG_EMBTK_HAVE_GDB),y)
include $(EMBTK_ROOT)/mk/gdb.mk
endif

################################################################################
############################# Packages for TARGET ##############################
################################################################################

#gdb
ifeq ($(CONFIG_EMBTK_HAVE_GDB_ON_TARGET),y)
ROOTFS_COMPONENTS += gdb_target_install
endif

#gdbserver
ifeq ($(CONFIG_EMBTK_HAVE_GDBSERVER_ON_TARGET),y)
ROOTFS_COMPONENTS += gdbserver_target_install
endif

#strace
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_STRACE),y)
include $(EMBTK_ROOT)/mk/strace.mk
ROOTFS_COMPONENTS += strace_install
endif

######################## Flash manipulation tools ##############################

#mtd-utils
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_MTDUTILS),y)
ROOTFS_COMPONENTS += mtd-utils_target_install
endif
ROOTFS_COMPONENTS_CLEAN += mtd-utils_target_clean

######################## Compression packages ##################################

########################### Graphics packages ##################################

#atk
include $(EMBTK_ROOT)/packages/graphics/atk/atk.mk
ifeq ($(CONFIG_EMBTK_HAVE_ATK),y)
ROOTFS_COMPONENTS += atk_install
endif
ROOTFS_COMPONENTS_CLEAN += atk_clean

#Cairo
include $(EMBTK_ROOT)/packages/graphics/cairo/cairo.mk
ifeq ($(CONFIG_EMBTK_HAVE_CAIRO),y)
ROOTFS_COMPONENTS += cairo_install
endif
ROOTFS_COMPONENTS_CLEAN += cairo_clean

#DirectFB
include $(EMBTK_ROOT)/packages/graphics/directfb/directfb.mk
ifeq ($(CONFIG_EMBTK_HAVE_DIRECTFB),y)
ROOTFS_COMPONENTS += directfb_install
endif
ROOTFS_COMPONENTS_CLEAN += directfb_clean

#fontconfig
include $(EMBTK_ROOT)/packages/graphics/fontconfig/fontconfig.mk
ifeq ($(CONFIG_EMBTK_HAVE_FONTCONFIG),y)
ROOTFS_COMPONENTS += fontconfig_install
endif
ROOTFS_COMPONENTS_CLEAN += fontconfig_clean

#FreeType
include $(EMBTK_ROOT)/packages/graphics/freetype/freetype.mk
ifeq ($(CONFIG_EMBTK_HAVE_FREETYPE),y)
ROOTFS_COMPONENTS += freetype_install
endif
ROOTFS_COMPONENTS_CLEAN += freetype_clean

#gtk+
include $(EMBTK_ROOT)/packages/graphics/gtk/gtk.mk
ifeq ($(CONFIG_EMBTK_HAVE_GTK),y)
ROOTFS_COMPONENTS += gtk_install
endif
ROOTFS_COMPONENTS_CLEAN += gtk_clean

#libjpeg
include $(EMBTK_ROOT)/packages/graphics/libjpeg/libjpeg.mk
ifeq ($(CONFIG_EMBTK_HAVE_LIBJPEG),y)
ROOTFS_COMPONENTS += libjpeg_install
endif
ROOTFS_COMPONENTS_CLEAN += libjpeg_clean

#libpng
include $(EMBTK_ROOT)/packages/graphics/libpng/libpng.mk
ifeq ($(CONFIG_EMBTK_HAVE_LIBPNG),y)
ROOTFS_COMPONENTS += libpng_install
endif
ROOTFS_COMPONENTS_CLEAN += libpng_clean

#pixman
include $(EMBTK_ROOT)/packages/graphics/pixman/pixman.mk
ifeq ($(CONFIG_EMBTK_HAVE_PIXMAN),y)
ROOTFS_COMPONENTS += pixman_install
endif
ROOTFS_COMPONENTS_CLEAN += pixman_clean

#libtiff
include $(EMBTK_ROOT)/packages/graphics/libtiff/libtiff.mk
ifeq ($(CONFIG_EMBTK_HAVE_LIBTIFF),y)
ROOTFS_COMPONENTS += libtiff_install
endif
ROOTFS_COMPONENTS_CLEAN += libtiff_clean
########################## Networking packages #################################

############################ Scripting languages ###############################

ifeq ($(CONFIG_EMBTK_HAVE_MICROPERL),y)
include $(EMBTK_ROOT)/packages/scripting-languages/perl/perl.mk
ROOTFS_COMPONENTS += microperl_install
endif
############################ System packages ###################################

########################## Miscellaneous packages ##############################

#gettext
include $(EMBTK_ROOT)/packages/misc/gettext/gettext.mk
ifeq ($(CONFIG_EMBTK_HAVE_GETTEXT),y)
ROOTFS_COMPONENTS += gettext_install
endif
ROOTFS_COMPONENTS_CLEAN += gettext_clean

#GLib
include $(EMBTK_ROOT)/packages/misc/glib/glib.mk
ifeq ($(CONFIG_EMBTK_HAVE_GLIB),y)
ROOTFS_COMPONENTS += glib_install
endif
ROOTFS_COMPONENTS_CLEAN += glib_clean

#libxml2
include $(EMBTK_ROOT)/packages/misc/libxml/libxml.mk
ifeq ($(CONFIG_EMBTK_HAVE_LIBXML2),y)
ROOTFS_COMPONENTS += libxml2_install
endif
ROOTFS_COMPONENTS_CLEAN += libxml2_clean

#Pango
include $(EMBTK_ROOT)/packages/misc/pango/pango.mk
ifeq ($(CONFIG_EMBTK_HAVE_PANGO),y)
ROOTFS_COMPONENTS += pango_install
endif
ROOTFS_COMPONENTS_CLEAN += pango_clean
################################### BUSYBOX ####################################
#Busybox
ifeq ($(CONFIG_EMBTK_ROOTFS_HAVE_BB),y)
include $(EMBTK_ROOT)/packages/busybox/busybox.mk
ROOTFS_COMPONENTS += busybox_install
endif

################################################################################
########################## Packages for HOST MACHINE ###########################
################################################################################

#gdb
ifeq ($(CONFIG_EMBTK_HAVE_GDB_ON_HOST),y)
HOSTTOOLS_COMPONENTS += gdb_host_install
endif

################################################################################
########################### Targets for HOST MACHINE ###########################
################################################################################
host_packages_build:
ifeq ($(HOSTTOOLS_COMPONENTS),)
else
	$(call EMBTK_GENERIC_MESSAGE,"Building extra packages intended to run \
	on your host machine ...")
	@$(MAKE) $(HOSTTOOLS_COMPONENTS)
endif

