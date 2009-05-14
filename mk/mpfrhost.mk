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
# \file         mpfrhost.mk
# \brief	mpfrhost.mk of Embtoolkit. To build gcc, we need mpfr.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

MPFR_HOST_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_MPFR_HOST_VERSION_STRING)))
MPFR_HOST_SITE := http://www.mpfr.org/mpfr-$(MPFR_HOST_VERSION)
MPFR_HOST_PACKAGE := mpfr-$(MPFR_HOST_VERSION).tar.bz2
MPFR_HOST_BUILD_DIR := $(TOOLS_BUILD)/mpfr
MPFR_HOST_DIR := $(TOOLS_BUILD)/mpfr-host

export MPFR_HOST_DIR

mpfrhost_install: $(MPFR_HOST_BUILD_DIR)/.built

$(MPFR_HOST_BUILD_DIR)/.built: download_mpfr_host $(MPFR_HOST_BUILD_DIR)/.decompressed \
	$(MPFR_HOST_BUILD_DIR)/.configured
	@cd $(MPFR_HOST_BUILD_DIR) && make && make install
	@touch $@

$(MPFR_HOST_BUILD_DIR)/.decompressed:
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(MPFR_HOST_PACKAGE)
ifeq ($(CONFIG_EMBTK_MPFR_HOST_VERSION_PATCH),y)
	cd $(TOOLS_BUILD)/mpfr-$(MPFR_HOST_VERSION); patch -p1 < $(DOWNLOAD_DIR)/mpfr-$(MPFR_HOST_VERSION).patch
endif
	@mkdir -p $(MPFR_HOST_BUILD_DIR)
	@touch $@

download_mpfr_host:
	@test -e $(DOWNLOAD_DIR)/$(MPFR_HOST_PACKAGE) || \
	wget $(MPFR_HOST_SITE)/$(MPFR_HOST_PACKAGE) \
	-O $(DOWNLOAD_DIR)/$(MPFR_HOST_PACKAGE)
ifeq ($(CONFIG_EMBTK_MPFR_HOST_VERSION_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/mpfr-$(MPFR_HOST_VERSION).patch || \
	wget $(MPFR_HOST_SITE)/patches \
	-O $(DOWNLOAD_DIR)/mpfr-$(MPFR_HOST_VERSION).patch
endif

$(MPFR_HOST_BUILD_DIR)/.configured:
	@mkdir -p $(MPFR_HOST_DIR)
	@cd $(MPFR_HOST_BUILD_DIR); $(TOOLS_BUILD)/mpfr-$(MPFR_HOST_VERSION)/configure \
	 --prefix=$(MPFR_HOST_DIR) --disable-shared --enable-static --with-gmp=$(GMP_HOST_DIR)
	@touch $@
