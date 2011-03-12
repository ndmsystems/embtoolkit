################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
################################################################################
#
# \file         mpchost.mk
# \brief	mpchost.mk of Embtoolkit. To build gcc, we need mpc.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         Jan 2010
################################################################################

MPC_HOST_VERSION:=$(subst ",,$(strip $(CONFIG_EMBTK_MPC_HOST_VERSION_STRING)))
MPC_HOST_SITE := http://www.multiprecision.org/mpc/download
MPC_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/mpc
MPC_HOST_PACKAGE := mpc-$(MPC_HOST_VERSION).tar.gz
MPC_HOST_BUILD_DIR := $(TOOLS_BUILD)/mpc
MPC_HOST_DIR := $(HOSTTOOLS)/usr/local/mpc-host

export MPC_HOST_DIR

mpchost_install: $(MPC_HOST_BUILD_DIR)/.installed

$(MPC_HOST_BUILD_DIR)/.installed: download_mpc_host \
	$(MPC_HOST_BUILD_DIR)/.decompressed $(MPC_HOST_BUILD_DIR)/.configured
	$(Q)$(MAKE) -C $(MPC_HOST_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(MPC_HOST_BUILD_DIR) install
	@touch $@

$(MPC_HOST_BUILD_DIR)/.decompressed:
	@tar -C $(TOOLS_BUILD) -xzf $(DOWNLOAD_DIR)/$(MPC_HOST_PACKAGE)
ifeq ($(CONFIG_EMBTK_MPC_NEED_PATCH),y)
	cd $(TOOLS_BUILD)/mpc-$(MPC_HOST_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/mpc-$(MPC_HOST_VERSION).patch
endif
	@mkdir -p $(MPC_HOST_BUILD_DIR)
	@touch $@

download_mpc_host:
	@test -e $(DOWNLOAD_DIR)/$(MPC_HOST_PACKAGE) || \
	wget $(MPC_HOST_SITE)/$(MPC_HOST_PACKAGE) \
	-O $(DOWNLOAD_DIR)/$(MPC_HOST_PACKAGE)
ifeq ($(CONFIG_EMBTK_MPC_HOST_VERSION_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/mpc-$(MPC_HOST_VERSION).patch || \
	wget $(MPC_PATCH_SITE)/mpc-$(MPC_HOST_VERSION)-*.patch \
	-O $(DOWNLOAD_DIR)/mpc-$(MPC_HOST_VERSION).patch
endif

$(MPC_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring mpc-$(MPC_HOST_VERSION) ...")
	cd $(MPC_HOST_BUILD_DIR); \
	CC=$(HOSTCC_CACHED) \
	CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/mpc-$(MPC_HOST_VERSION)/configure \
	--build=$(HOST_BUILD) --host=$(HOST_ARCH) \
	--prefix=$(MPC_HOST_DIR) --disable-shared --enable-static \
	--with-gmp=$(GMP_HOST_DIR) --with-mpfr=$(MPFR_HOST_DIR)
	@touch $@
