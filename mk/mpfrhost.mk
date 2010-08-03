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
# \file         mpfrhost.mk
# \brief	mpfrhost.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

MPFR_HOST_VERSION:=$(subst ",,$(strip $(CONFIG_EMBTK_MPFR_HOST_VERSION_STRING)))
MPFR_HOST_SITE := http://www.mpfr.org/mpfr-$(MPFR_HOST_VERSION)
MPFR_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/mpfr/$(MPFR_HOST_VERSION)
MPFR_HOST_PACKAGE := mpfr-$(MPFR_HOST_VERSION).tar.bz2
MPFR_HOST_BUILD_DIR := $(TOOLS_BUILD)/mpfr
MPFR_HOST_DIR := $(HOSTTOOLS)/usr/local/mpfr-host

export MPFR_HOST_DIR

mpfrhost_install: $(MPFR_HOST_BUILD_DIR)/.built

$(MPFR_HOST_BUILD_DIR)/.built: download_mpfr_host \
	$(MPFR_HOST_BUILD_DIR)/.decompressed $(MPFR_HOST_BUILD_DIR)/.configured
	@cd $(MPFR_HOST_BUILD_DIR) && $(MAKE) $(J) && $(MAKE) install
	@touch $@

$(MPFR_HOST_BUILD_DIR)/.decompressed:
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(MPFR_HOST_PACKAGE)
ifeq ($(CONFIG_EMBTK_MPFR_HOST_VERSION_PATCH),y)
	cd $(TOOLS_BUILD)/mpfr-$(MPFR_HOST_VERSION); \
	patch -p1 < $(DOWNLOAD_DIR)/mpfr-$(MPFR_HOST_VERSION).patch
endif
	@mkdir -p $(MPFR_HOST_BUILD_DIR)
	@touch $@

download_mpfr_host:
	@test -e $(DOWNLOAD_DIR)/$(MPFR_HOST_PACKAGE) || \
	wget $(MPFR_HOST_SITE)/$(MPFR_HOST_PACKAGE) \
	-O $(DOWNLOAD_DIR)/$(MPFR_HOST_PACKAGE)
ifeq ($(CONFIG_EMBTK_MPFR_HOST_VERSION_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/mpfr-$(MPFR_HOST_VERSION).patch || \
	wget $(MPFR_PATCH_SITE)/mpfr-$(MPFR_HOST_VERSION)-*.patch \
	-O $(DOWNLOAD_DIR)/mpfr-$(MPFR_HOST_VERSION).patch
endif

$(MPFR_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"mpfrhost: Configuring \
	mpfr-$(MPFR_HOST_VERSION) ...")
	@mkdir -p $(MPFR_HOST_DIR)
	cd $(MPFR_HOST_BUILD_DIR); CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	$(TOOLS_BUILD)/mpfr-$(MPFR_HOST_VERSION)/configure \
	--prefix=$(MPFR_HOST_DIR) --disable-shared --enable-static \
	--with-gmp=$(GMP_HOST_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@
