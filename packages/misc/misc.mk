################################################################################
# Embtoolkit
# Copyright(C) 2010-2014 GAYE Abdoulaye Walsimou.
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

embtk_pkgincdir := packages/misc

# expat
$(call embtk_include_pkg,expat)

# gettext
$(call embtk_include_hostpkg,gettext_host)

# glib
$(call embtk_include_pkg,glib)
$(call embtk_include_hostpkg,glib_host)

# intltool
$(call embtk_include_hostpkg,intltool_host)

# ncurses
$(call embtk_include_pkg,ncurses)

# raptor
$(call embtk_include_pkg,raptor)

# serd
$(call embtk_include_pkg,serd)

# sord
$(call embtk_include_pkg,sord)

# sratom
$(call embtk_include_pkg,sratom)

# tslib
$(call embtk_include_pkg,tslib)
