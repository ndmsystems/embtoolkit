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
# \file         misc.mk
# \brief	misc.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         February 2010
################################################################################

#gettext
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GETTEXT) += gettext_install
ROOTFS_COMPONENTS_CLEAN += gettext_clean
ifeq ($(CONFIG_EMBTK_HAVE_GETTEXT),y)
include $(EMBTK_ROOT)/packages/misc/gettext/gettext.mk
endif

#GLib
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GLIB) += glib_install
ROOTFS_COMPONENTS_CLEAN += glib_clean
ifeq ($(CONFIG_EMBTK_HAVE_GLIB),y)
include $(EMBTK_ROOT)/packages/misc/glib/glib.mk
endif

#libelf
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBELF) += libelf_install
ROOTFS_COMPONENTS_CLEAN += libelf_clean
ifeq ($(CONFIG_EMBTK_HAVE_LIBELF),y)
include $(EMBTK_ROOT)/packages/misc/libelf/libelf.mk
endif

#libxml2
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXML2) += libxml2_install
ROOTFS_COMPONENTS_CLEAN += libxml2_clean
ifeq ($(CONFIG_EMBTK_HAVE_LIBXML2),y)
include $(EMBTK_ROOT)/packages/misc/libxml/libxml.mk
endif

#ncurses
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_NCURSES) += ncurses_install
ROOTFS_COMPONENTS_CLEAN += ncurses_clean
ifeq ($(CONFIG_EMBTK_HAVE_NCURSES),y)
include $(EMBTK_ROOT)/packages/misc/ncurses/ncurses.mk
endif

#Pango
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_PANGO) += pango_install
ROOTFS_COMPONENTS_CLEAN += pango_clean
ifeq ($(CONFIG_EMBTK_HAVE_PANGO),y)
include $(EMBTK_ROOT)/packages/misc/pango/pango.mk
endif

