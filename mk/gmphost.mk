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
# \file         gmphost.mk
# \brief	gmphost.mk of Embtoolkit. To build mpfr, we need gmp.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

GMP_HOST_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GMP_HOST_VERSION_STRING)))
GMP_HOST_SITE := ftp://ftp.gmplib.org/pub/
GMP_HOST_PACKAGE := gmp-$(GMP_HOST_VERSION).tar.bz2
GMP_HOST_BUILD_DIR := $(TOOLS_BUILD)/gmp
GMP_HOST_DIR := $(TOOLS_BUILD)/gmp-host

export GMP_HOST_DIR

gmphost_install: $(GMP_HOST_BUILD_DIR)/.built

$(GMP_HOST_BUILD_DIR)/.built: download_gmp_host $(GMP_HOST_BUILD_DIR)/.decompressed \
	$(GMP_HOST_BUILD_DIR)/.configured
	@cd $(GMP_HOST_BUILD_DIR) && $(MAKE) && $(MAKE) install
	@touch $@

download_gmp_host:
	@test -e $(DOWNLOAD_DIR)/$(GMP_HOST_PACKAGE) || \
	wget -P $(DOWNLOAD_DIR) $(GMP_HOST_SITE)/$(GMP_HOST_PACKAGE)

$(GMP_HOST_BUILD_DIR)/.decompressed:
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(GMP_HOST_PACKAGE)
	@mkdir -p $(GMP_HOST_BUILD_DIR)
	@touch $@

$(GMP_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"gmphost: Configuring gmp-$(GMP_HOST_VERSION) ...")
	@mkdir -p $(GMP_HOST_DIR)
	cd $(GMP_HOST_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/gmp-$(GMP_HOST_VERSION)/configure \
	--prefix=$(GMP_HOST_DIR) --disable-shared --enable-static \
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
