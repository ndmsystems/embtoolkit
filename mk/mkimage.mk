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
# \file         mkimage.mk
# \brief	mkimage.mk of Embtoolkit. u-boot makimage tool, needed to create
# \brief	uImage.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2010
################################################################################

MAKEIMAGE_VERSION := 0.4
MAKEIMAGE_SITE := http://ftp.debian.org/debian/pool/main/u/uboot-mkimage
MAKEIMAGE_PACKAGE :=
MAKEIMAGE_BUILD_DIR := $(TOOLS_BUILD)/mkimage
MAKEIMAGE_BIN := $(HOSTTOOLS)/usr/bin/mkimage
export MAKEIMAGE_BIN

mkimage_install:
	@test -e $(MAKEIMAGE_BUILD_DIR)/.installed || \
	$(MAKE) $(MAKEIMAGE_BUILD_DIR)/.installed

$(MAKEIMAGE_BUILD_DIR)/.installed:
	$(Q)cp -R $(EMBTK_ROOT)/src/mkimage $(TOOLS_BUILD)/
	$(MAKE) -C $(MAKEIMAGE_BUILD_DIR)
	$(MAKE) -C $(MAKEIMAGE_BUILD_DIR) DESTDIR=$(HOSTTOOLS) install
	@touch $@
