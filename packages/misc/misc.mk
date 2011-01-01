################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

#expat
include $(EMBTK_ROOT)/packages/misc/expat/expat.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_EXPAT) += expat_install

#gettext
include $(EMBTK_ROOT)/packages/misc/gettext/gettext.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GETTEXT) += gettext_install

#GLib
include $(EMBTK_ROOT)/packages/misc/glib/glib.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GLIB) += glib_install

#libelf
include $(EMBTK_ROOT)/packages/misc/libelf/libelf.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBELF) += libelf_install

#libxml2
include $(EMBTK_ROOT)/packages/misc/libxml/libxml.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXML2) += libxml2_install

#ncurses
include $(EMBTK_ROOT)/packages/misc/ncurses/ncurses.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_NCURSES) += ncurses_install

#tslib
include $(EMBTK_ROOT)/packages/misc/tslib/tslib.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_TSLIB) += tslib_install

