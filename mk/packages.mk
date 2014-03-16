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
# \file         packages.kconfig
# \brief	packages.kconfig of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

ROOTFS_COMPONENTS-y		:=
HOSTTOOLS_COMPONENTS-y		:= mkimage_install
#
# Common include for target and host
#

# gperf
include mk/gperf_host.mk
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_GPERF) += gperf_host_install

# libelf
include packages/misc/libelf/libelf.mk
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_LIBELF) += libelf_install
HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_LIBELF) += libelf_host_install

include mk/makedevs.mk
include mk/mkimage.mk
include mk/squashfs.mk

# Install various tools in case of FreeBSD host development machine
ifeq ($(embtk_buildhost_os_type),bsd)
HOSTTOOLS_COMPONENTS-y += gsed_install gmake_install
endif


#
# Packages for TARGET and HOST
#

# Flash manipulation tools: mtd-utils
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_MTDUTILS) += mtdutils_install

# Compression packages
include packages/compression/compression.mk

# Database packages/libraries
include packages/database/database.mk

# Development libraries/packages
include packages/development/development.mk

# Graphics packages
include packages/graphics/graphics.mk

# Networking packages
include packages/net/net.mk

# Scripting languages
include packages/scripting-languages/scripting-languages.mk

# Security packages
include packages/security/security.mk

# System packages
include packages/system/system.mk

# X window system packages
include packages/x11/x11.mk

# Miscellaneous packages
include packages/misc/misc.mk

# Busybox
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_BB) += bb_install
include packages/busybox/busybox.mk

#
# Targets for host machine
#
define __embtk_hostpkgs_build
	$(if $(HOSTTOOLS_COMPONENTS-y),$(MAKE) $(HOSTTOOLS_COMPONENTS-y),true)
endef
host_packages_build:
	$(Q)$(__embtk_hostpkgs_build)

#
# Generic implicit rules
#

# This install implicit rule is intended for autotool'ed packages, or packages
# defininng an embtk_install_{pkgname} macro.
%_install:
	$(call embtk_install_xpkg,$*)

# Download generic implicit rule
download_% %_download:
	$(call embtk_download_pkg,$*)

# Decompress generic implicit rule
%_decompress:
	$(call embtk_decompress_pkg,$*)

# clean generic implicit rule
%_clean:
	$(call embtk_cleanup_pkg,$*)

# Download target for offline build
packages_fetch:: $(patsubst %_install,download_%,$(ROOTFS_COMPONENTS-y) $(HOSTTOOLS_COMPONENTS-y))
