################################################################################
# Embtoolkit
# Copyright(C) 2014 GAYE Abdoulaye Walsimou.
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
# \file         audio.mk
# \brief	audio.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2014
################################################################################

embtk_pkgincdir := packages/audio

# libsndfile
$(call embtk_include_pkg,libsndfile)

# lilv
$(call embtk_include_pkg,lilv)

# lv2
$(call embtk_include_pkg,lv2)
