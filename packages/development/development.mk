################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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

embtk_pkgincdir := packages/development

# boost
$(call embtk_include_pkg,boost)

# fftw
$(call embtk_include_pkg,fftw)

# gtest
$(call embtk_include_pkg,gtest)

# libbsd
$(call embtk_include_pkg,libbsd)

# libevent
$(call embtk_include_pkg,libevent)

# libnih
$(call embtk_include_pkg,libnih)

# libsigsegv
$(call embtk_include_pkg,libsigsegv)

# libunwind
$(call embtk_include_pkg,libunwind)

# popt
$(call embtk_include_pkg,popt)
