################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
HOSTTOOLS_COMPONENTS-y		:= mkimage_install pkgconfig_install
#
# Common include for target and host
#
include $(EMBTK_ROOT)/mk/mkimage.mk
include $(EMBTK_ROOT)/mk/mtd-utils.mk
include $(EMBTK_ROOT)/mk/pkgconfig.mk
include $(EMBTK_ROOT)/mk/fakeroot.mk
include $(EMBTK_ROOT)/mk/makedevs.mk
include $(EMBTK_ROOT)/mk/squashfs.mk
include $(EMBTK_ROOT)/mk/zlib_host.mk

HOSTTOOLS_COMPONENTS-$(CONFIG_EMBTK_HOST_HAVE_ZLIB) += zlib_host_install



#
# Packages for TARGET and HOST
#

# Flash manipulation tools: mtd-utils
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_MTDUTILS) += mtdutils_install

# Compression packages
include $(EMBTK_ROOT)/packages/compression/compression.mk

# Database packages/libraries
include $(EMBTK_ROOT)/packages/database/database.mk

# Development libraries/packages
include $(EMBTK_ROOT)/packages/development/development.mk

# Graphics packages
include $(EMBTK_ROOT)/packages/graphics/graphics.mk

# Networking packages

# Scripting languages
include $(EMBTK_ROOT)/packages/scripting-languages/scripting-languages.mk

# Security packages
include $(EMBTK_ROOT)/packages/security/security.mk

# System packages
include $(EMBTK_ROOT)/packages/system/system.mk

# X window system packages
include $(EMBTK_ROOT)/packages/x11/x11.mk

# Miscellaneous packages
include $(EMBTK_ROOT)/packages/misc/misc.mk

# Busybox
ROOTFS_COMPONENTS-$(CONFIG_EMBTK_HAVE_BB) += bb_install
include $(EMBTK_ROOT)/packages/busybox/busybox.mk

#
# Targets for host machine
#
define __embtk_hostpkgs_build
	$(if $(HOSTTOOLS_COMPONENTS-y),$(MAKE) $(HOSTTOOLS_COMPONENTS-y),true)
endef
host_packages_build:
	$(Q)$(__embtk_hostpkgs_build)

#
# Generic implicite rules
#

# This install implicit rule is intended for autotool'ed packages
%_install:
	$(call embtk_install_$(findstring host,$@)pkg,$*)

# Download generic implicit rule
download_%:
	$(call embtk_download_pkg,$*)

# clean generic implicit rule
%_clean:
	$(call embtk_cleanup_pkg,$*)

# Download target for offline build
packages_fetch:: $(patsubst %_install,download_%,$(ROOTFS_COMPONENTS-y) $(HOSTTOOLS_COMPONENTS-y))
