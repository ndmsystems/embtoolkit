################################################################################
# Embtoolkit
# Copyright(C) 2010-2012 GAYE Abdoulaye Walsimou.
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
# \file         misc.mk
# \brief	misc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         February 2010
################################################################################

#expat
include packages/misc/expat/expat.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_EXPAT) += expat_install

#gettext
include packages/misc/gettext/gettext.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GETTEXT) += gettext_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_GETTEXT) += gettext_host_install

#GLib
include packages/misc/glib/glib.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_GLIB) += glib_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_GLIB) += glib_host_install

# intltool
include packages/misc/intltool/intltool.mk
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_INTLTOOL) += intltool_host_install

#libxml2
include packages/misc/libxml/libxml.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXML2) += libxml2_install

#ncurses
include packages/misc/ncurses/ncurses.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_NCURSES) += ncurses_install

#tslib
include packages/misc/tslib/tslib.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_TSLIB) += tslib_install

