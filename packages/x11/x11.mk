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
# \file         x11.mk
# \brief	x11.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         March 2010
################################################################################

embtk_pkgincdir := packages/x11

#########
# X Tools
#########

# utilmacros
$(call embtk_include_pkg,utilmacros)

# xcb-util
$(call embtk_include_pkg,xcbutil)

##############
# X prototypes
##############

# bigreqsproto
$(call embtk_include_pkg,bigreqsproto)

# compositeproto
$(call embtk_include_pkg,compositeproto)

# damageproto
$(call embtk_include_pkg,damageproto)

# fixesproto
$(call embtk_include_pkg,fixesproto)

# fontsproto
$(call embtk_include_pkg,fontsproto)

# inputproto
$(call embtk_include_pkg,inputproto)

# kbproto
$(call embtk_include_pkg,kbproto)

# randrproto
$(call embtk_include_pkg,randrproto)

# recordproto
$(call embtk_include_pkg,recordproto)

# renderproto
$(call embtk_include_pkg,renderproto)

# resourceproto
$(call embtk_include_pkg,resourceproto)

# videoproto
$(call embtk_include_pkg,videoproto)

# xcbproto
$(call embtk_include_pkg,xcbproto)

# xcmiscproto
$(call embtk_include_pkg,xcmiscproto)

# xextcproto
$(call embtk_include_pkg,xextproto)

# xproto
$(call embtk_include_pkg,xproto)

#####################################
# X windowing system library packages
#####################################

# libfontenc
$(call embtk_include_pkg,libfontenc)

# libpthreadstubs
$(call embtk_include_pkg,libpthreadstubs)

# libpciaccess
$(call embtk_include_pkg,libpciaccess)

# libx11
$(call embtk_include_pkg,libx11)

# libxau
$(call embtk_include_pkg,libxau)

# libxi
$(call embtk_include_pkg,libxi)

# libxcb
$(call embtk_include_pkg,libxcb)

# libxcomposite
$(call embtk_include_pkg,libxcomposite)

# libXext
$(call embtk_include_pkg,libxext)

# libxfixes
$(call embtk_include_pkg,libxfixes)

# libxfont
$(call embtk_include_pkg,libxfont)

# libXft
$(call embtk_include_pkg,libxft)

# libxkbfile
$(call embtk_include_pkg,libxkbfile)

# libxrandr
$(call embtk_include_pkg,libxrandr)

# libxrender
$(call embtk_include_pkg,libxrender)

#########################################
# X windowing system application packages
#########################################

# xinput
$(call embtk_include_pkg,xinput)

# xkbcomp
$(call embtk_include_pkg,xkbcomp)

# xkeyboard-config
$(call embtk_include_pkg,xkeyboardconfig)

# xtrans
$(call embtk_include_pkg,xtrans)

##########
# X server
##########

# kdrive and Xorg
$(call embtk_include_pkg,xserver)

# X server input drivers
########################

# xf86inputevdev
$(call embtk_include_pkg,xf86inputevdev)

# X server video drivers
########################

# xf86videofbdev
$(call embtk_include_pkg,xf86videofbdev)
