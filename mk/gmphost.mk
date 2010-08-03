################################################################################
# Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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
# \file         gmphost.mk
# \brief	gmphost.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

GMP_HOST_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GMP_HOST_VERSION_STRING)))
GMP_HOST_SITE := ftp://ftp.gmplib.org/pub/gmp-$(GMP_HOST_VERSION)
GMP_HOST_PACKAGE := gmp-$(GMP_HOST_VERSION).tar.bz2
GMP_HOST_BUILD_DIR := $(TOOLS_BUILD)/gmp
GMP_HOST_DIR := $(HOSTTOOLS)/usr/local/gmp-host

export GMP_HOST_DIR

gmphost_install: $(GMP_HOST_BUILD_DIR)/.built

$(GMP_HOST_BUILD_DIR)/.built: download_gmp_host \
	$(GMP_HOST_BUILD_DIR)/.decompressed $(GMP_HOST_BUILD_DIR)/.configured
	@cd $(GMP_HOST_BUILD_DIR) && $(MAKE) $(J) && $(MAKE) install
	@touch $@

download_gmp_host:
	@test -e $(DOWNLOAD_DIR)/$(GMP_HOST_PACKAGE) || \
	wget -P $(DOWNLOAD_DIR) $(GMP_HOST_SITE)/$(GMP_HOST_PACKAGE)

$(GMP_HOST_BUILD_DIR)/.decompressed:
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(GMP_HOST_PACKAGE)
	@mkdir -p $(GMP_HOST_BUILD_DIR)
	@touch $@

$(GMP_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"gmphost: Configuring \
	gmp-$(GMP_HOST_VERSION) ...")
	@mkdir -p $(GMP_HOST_DIR)
	cd $(GMP_HOST_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/gmp-$(GMP_HOST_VERSION)/configure \
	--prefix=$(GMP_HOST_DIR) --disable-shared --enable-static \
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
