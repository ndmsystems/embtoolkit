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
include $(EMBTK_ROOT)/packages/misc/gettext/gettext.mk
ROOTFS_COMPONENTS_CLEAN += gettext_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GETTEXT) += gettext_install

#GLib
include $(EMBTK_ROOT)/packages/misc/glib/glib.mk
ROOTFS_COMPONENTS_CLEAN += glib_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GLIB) += glib_install

#libelf
include $(EMBTK_ROOT)/packages/misc/libelf/libelf.mk
ROOTFS_COMPONENTS_CLEAN += libelf_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBELF) += libelf_install

#libxml2
include $(EMBTK_ROOT)/packages/misc/libxml/libxml.mk
ROOTFS_COMPONENTS_CLEAN += libxml2_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXML2) += libxml2_install

#ncurses
include $(EMBTK_ROOT)/packages/misc/ncurses/ncurses.mk
ROOTFS_COMPONENTS_CLEAN += ncurses_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_NCURSES) += ncurses_install

#Pango
include $(EMBTK_ROOT)/packages/misc/pango/pango.mk
ROOTFS_COMPONENTS_CLEAN += pango_clean
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_PANGO) += pango_install

