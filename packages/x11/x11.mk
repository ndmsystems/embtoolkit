################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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

#########
# X Tools
#########
#utilmacros
include $(EMBTK_ROOT)/packages/x11/utilmacros/utilmacros.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_UTILMACROS) += utilmacros_install

#xcb-util
include $(EMBTK_ROOT)/packages/x11/xcbutil/xcbutil.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XCBUTIL) += xcbutil_install

##############
# X prototypes
##############
#bigreqsproto
include $(EMBTK_ROOT)/packages/x11/bigreqsproto/bigreqsproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_BIGREQSPROTO) += bigreqsproto_install

#compositeproto
include $(EMBTK_ROOT)/packages/x11/compositeproto/compositeproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_COMPOSITEPROTO) += compositeproto_install

#damageproto
include $(EMBTK_ROOT)/packages/x11/damageproto/damageproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_DAMAGEPROTO) += damageproto_install

#fixesproto
include $(EMBTK_ROOT)/packages/x11/fixesproto/fixesproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FIXESPROTO) += fixesproto_install

#fontsproto
include $(EMBTK_ROOT)/packages/x11/fontsproto/fontsproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_FONTSPROTO) += fontsproto_install

#inputproto
include $(EMBTK_ROOT)/packages/x11/inputproto/inputproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_INPUTPROTO) += inputproto_install

#kbproto
include $(EMBTK_ROOT)/packages/x11/kbproto/kbproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_INPUTPROTO) += kbproto_install

#randrproto
include $(EMBTK_ROOT)/packages/x11/randrproto/randrproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_RANDRPROTO) += randrproto_install

#recordproto
include $(EMBTK_ROOT)/packages/x11/recordproto/recordproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_RECORDPROTO) += recordproto_install

#renderproto
include $(EMBTK_ROOT)/packages/x11/renderproto/renderproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_RENDERPROTO) += renderproto_install

#resourceproto
include $(EMBTK_ROOT)/packages/x11/resourceproto/resourceproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_RESOURCEPROTO) += resourceproto_install

#videoproto
include $(EMBTK_ROOT)/packages/x11/videoproto/videoproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_VIDEOPROTO) += videoproto_install

#xcbproto
include $(EMBTK_ROOT)/packages/x11/xcbproto/xcbproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XCBPROTO) += xcbproto_install

#xcmiscproto
include $(EMBTK_ROOT)/packages/x11/xcmiscproto/xcmiscproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XCMISCPROTO) += xcmiscproto_install

#xextcproto
include $(EMBTK_ROOT)/packages/x11/xextproto/xextproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XEXTPROTO) += xextproto_install

#xproto
include $(EMBTK_ROOT)/packages/x11/xproto/xproto.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XPROTO) += xproto_install

#####################################
# X windowing system library packages
#####################################
#libfontenc
include $(EMBTK_ROOT)/packages/x11/libfontenc/libfontenc.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBFONTENC) += libfontenc_install

#libpthreadstubs
include $(EMBTK_ROOT)/packages/x11/libpthreadstubs/libpthreadstubs.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBPTHREADSTUBS) += libpthreadstubs_install

#libpciaccess
include $(EMBTK_ROOT)/packages/x11/libpciaccess/libpciaccess.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBPCIACCESS) += libpciaccess_install

#libx11
include $(EMBTK_ROOT)/packages/x11/libx11/libx11.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBX11) += libx11_install

#libxau
include $(EMBTK_ROOT)/packages/x11/libxau/libxau.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXAU) += libxau_install

#libxi
include $(EMBTK_ROOT)/packages/x11/libxi/libxi.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXI) += libxi_install

#libxcb
include $(EMBTK_ROOT)/packages/x11/libxcb/libxcb.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXCB) += libxcb_install

#libxcomposite
include $(EMBTK_ROOT)/packages/x11/libxcomposite/libxcomposite.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXCOMPOSITE) += libxcomposite_install

#libXext
include $(EMBTK_ROOT)/packages/x11/libxext/libxext.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXEXT) += libxext_install

#libxfixes
include $(EMBTK_ROOT)/packages/x11/libxfixes/libxfixes.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXFIXES) += libxfixes_install

#libxfont
include $(EMBTK_ROOT)/packages/x11/libxfont/libxfont.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXFONT) += libxfont_install

#libXft
include $(EMBTK_ROOT)/packages/x11/libxft/libxft.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXFT) += libxft_install

#libxkbfile
include $(EMBTK_ROOT)/packages/x11/libxkbfile/libxkbfile.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXKBFILE) += libxkbfile_install

#libxrandr
include $(EMBTK_ROOT)/packages/x11/libxrandr/libxrandr.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXRANDR) += libxrandr_install

#libxrender
include $(EMBTK_ROOT)/packages/x11/libxrender/libxrender.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBXRENDER) += libxrender_install

#########################################
# X windowing system application packages
#########################################
#xinput
include $(EMBTK_ROOT)/packages/x11/xinput/xinput.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XINPUT) += xinput_install

#xkbcomp
include $(EMBTK_ROOT)/packages/x11/xkbcomp/xkbcomp.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XKBCOMP) += xkbcomp_install

#xkeyboard-config
include $(EMBTK_ROOT)/packages/x11/xkeyboardconfig/xkeyboardconfig.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XKEYBOARDCONFIG) += xkeyboardconfig_install

#xtrans
include $(EMBTK_ROOT)/packages/x11/xtrans/xtrans.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XTRANS) += xtrans_install

##########
# X server
##########
#kdrive and Xorg
include $(EMBTK_ROOT)/packages/x11/xserver/xserver.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XSERVER) += xserver_install

# X server input drivers
########################
#xf86inputevdev
include $(EMBTK_ROOT)/packages/x11/xf86inputevdev/xf86inputevdev.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XF86INPUTEVDEV) += xf86inputevdev_install

# X server video drivers
########################
#xf86videofbdev
include $(EMBTK_ROOT)/packages/x11/xf86videofbdev/xf86videofbdev.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_XF86VIDEOFBDEV) += xf86videofbdev_install
