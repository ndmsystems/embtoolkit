#########################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
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
#########################################################################################
#
# \file         rootfs.mk
# \brief	rootfs.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         June 2009
#########################################################################################

ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
#makedevs
include $(EMBTK_ROOT)/mk/makedevs.mk

#fakeroot
include $(EMBTK_ROOT)/mk/fakeroot.mk

rootfs_build: mkinitialpath $(ROOTFS_COMPONENTS)
ifeq ($(CONFIG_EMBTK_TARGET_ARCH_64BITS),y)
	@mkdir -p $(ROOTFS)/lib64
	@mkdir -p $(ROOTFS)/usr/lib64
	@rm -rf $(ROOTFS)/lib $(ROOTFS)/usr/lib
	@cp -d $(SYSROOT)/lib64/* $(ROOTFS)/lib64/
	@$(TOOLS)/bin/$(STRICT_GNU_TARGET)-strip  $(ROOTFS)/lib64/*.so
else
	@cp -d $(SYSROOT)/lib/* $(ROOTFS)/lib/
	@$(TOOLS)/bin/$(STRICT_GNU_TARGET)-strip  $(ROOTFS)/lib/*.so
endif
	$(FAKEROOT_BIN) -s $(EMBTK_ROOT)/.fakeroot.001 -- $(MAKEDEVS_DIR)/makedevs \
	-d $(EMBTK_ROOT)/src/devices_table.txt $(ROOTFS)
	cd $(ROOTFS) ; $(FAKEROOT_BIN) -i $(EMBTK_ROOT)/.fakeroot.001 -- \
	tar cjf rootfs-$(STRICT_GNU_TARGET).tar.bz2 * ; \
	mv rootfs-$(STRICT_GNU_TARGET).tar.bz2 $(EMBTK_ROOT)
else
rootfs_build:

endif
